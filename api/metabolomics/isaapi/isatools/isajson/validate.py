"""
Functions validating ISA-JSON.

Don't forget to read the ISA-JSON spec:
https://isa-specs.readthedocs.io/en/latest/isajson.html
"""
from __future__ import absolute_import
import glob
import json
import logging
import os
import re
from io import StringIO
from jsonschema import Draft4Validator, RefResolver, ValidationError

from metabolomics.isaapi.isatools.isajson.load import load

__author__ = 'djcomlab@gmail.com (David Johnson)'

log = logging.getLogger('isatools')

errors = []
warnings = []
info = []

# REGEXES
_RX_DOI = re.compile("(10[.][0-9]{4,}(?:[.][0-9]+)*/(?:(?![%'#? ])\\S)+)")
_RX_PMID = re.compile("[0-9]{8}")
_RX_PMCID = re.compile("PMC[0-9]{8}")


"""Everything below here is for the validator"""


def get_source_ids(study_json):
    """Used for rule 1002"""
    return [source["@id"] for source in study_json["materials"]["sources"]]


def get_sample_ids(study_json):
    """Used for rule 1003"""
    return [sample["@id"] for sample in study_json["materials"]["samples"]]


def get_material_ids(study_json):
    """Used for rule 1005"""
    material_ids = list()
    for assay_json in study_json["assays"]:
        material_ids.extend([material["@id"] for material in assay_json["materials"]["otherMaterials"]])
    return material_ids


def get_data_file_ids(study_json):
    """Used for rule 1004"""
    data_file_ids = list()
    for assay_json in study_json["assays"]:
        data_file_ids.extend([data_file["@id"] for data_file in assay_json["dataFiles"]])
    return data_file_ids


def get_io_ids_in_process_sequence(study_json):
    """Used for rules 1001-1005"""
    all_process_sequences = list(study_json["processSequence"])
    for assay_json in study_json["assays"]:
        all_process_sequences.extend(assay_json["processSequence"])
    return [elem for iterabl in [[i["@id"] for i in process["inputs"]] + [o["@id"]
                                                                          for o in process["outputs"]] for process in
                                 all_process_sequences] for elem in iterabl]


def check_material_ids_declared_used(study_json, id_collector_func):
    """Used for rules 1015-1018"""
    node_ids = id_collector_func(study_json)
    io_ids_in_process_sequence = get_io_ids_in_process_sequence(study_json)
    is_node_ids_used = set(node_ids).issubset(set(io_ids_in_process_sequence))
    if not is_node_ids_used:
        warnings.append({
            "message": "Material declared but not used",
            "supplemental": "{} not used in any inputs/outputs in {}".format(node_ids, io_ids_in_process_sequence),
            "code": 1017
        })
        log.warning("(W) Not all node IDs in {} used by inputs/outputs {}".format(node_ids,
                                                                                  io_ids_in_process_sequence))


def check_material_ids_not_declared_used(study_json):
    """Used for rules 1002-1005"""
    node_ids = get_source_ids(study_json) \
               + get_sample_ids(study_json) \
               + get_material_ids(study_json) \
               + get_data_file_ids(study_json)
    io_ids_in_process_sequence = get_io_ids_in_process_sequence(study_json)
    if len(set(io_ids_in_process_sequence)) - len(set(node_ids)) > 0:
        diff = set(io_ids_in_process_sequence) - set(node_ids)
        errors.append({
            "message": "Missing Material",
            "supplemental": "Inputs/outputs in {}  not found in sources, samples, materials or datafiles "
                            "declarations".format(list(diff)),
            "code": 1005
        })
        log.error("(E) There are some inputs/outputs IDs {} not found in sources, samples, materials or data files"
                  "declared".format(list(diff)))


def check_process_sequence_links(process_sequence_json):
    """Used for rule 1006"""
    process_ids = [process["@id"] for process in process_sequence_json]
    for process in process_sequence_json:
        try:
            if process["previousProcess"]["@id"] not in process_ids:
                errors.append({
                    "message": "Missing Process link",
                    "supplemental": "previousProcess {} in process {} does not refer to another process in "
                                    "sequence".format(process["previousProcess"]["@id"], process["@id"]),
                    "code": 1006
                })
                log.error("(E) previousProcess link {} in process {} does not refer to another process in "
                          "sequence".format(process["previousProcess"]["@id"], process["@id"]))
        except KeyError:
            pass
        try:
            if process["nextProcess"]["@id"] not in process_ids:
                errors.append({
                    "message": "Missing Process link",
                    "supplemental": "nextProcess {} in process {} does not refer to another process in "
                                    "sequence".format(process["nextProcess"]["@id"], process["@id"]),
                    "code": 1006
                })
                log.error("(E) nextProcess {} in process {} does not refer to another process in sequence".format(
                    process["nextProcess"]["@id"], process["@id"]))
        except KeyError:
            pass


def get_study_protocol_ids(study_json):
    """Used for rule 1007"""
    return [protocol["@id"] for protocol in study_json["protocols"]]


def check_process_protocol_ids_usage(study_json):
    """Used for rules 1007 and 1019"""
    protocol_ids_declared = get_study_protocol_ids(study_json)
    process_sequence = study_json["processSequence"]
    protocol_ids_used = list()
    for process in process_sequence:
        try:
            protocol_ids_used.append(process["executesProtocol"]["@id"])
        except KeyError:
            pass
    for assay in study_json["assays"]:
        process_sequence = assay["processSequence"]
        for process in process_sequence:
            try:
                protocol_ids_used.append(process["executesProtocol"]["@id"])
            except KeyError:
                pass
    if len(set(protocol_ids_used) - set(protocol_ids_declared)) > 0:
        diff = set(protocol_ids_used) - set(protocol_ids_declared)
        errors.append({
            "message": "Missing Protocol declaration",
            "supplemental": "protocol IDs {} not declared".format(list(diff)),
            "code": 1007
        })
        log.error("(E) There are protocol IDs {} used in a study or assay process sequence not declared".format(
            list(diff)))
    elif len(set(protocol_ids_declared) - set(protocol_ids_used)) > 0:
        diff = set(protocol_ids_declared) - set(protocol_ids_used)
        warnings.append({
            "message": "Protocol declared but not used",
            "supplemental": "protocol IDs declared {} not used".format(list(diff)),
            "code": 1019
        })
        log.warning("(W) There are some protocol IDs declared {} not used in any study or assay process "
                    "sequence".format(list(diff)))


def get_study_protocols_parameter_ids(study_json):
    """Used for rule 1009"""
    return [elem for iterabl in [[param["@id"] for param in protocol["parameters"]] for protocol in
                                 study_json["protocols"]] for elem in iterabl]


def get_parameter_value_parameter_ids(study_json):
    """Used for rule 1009"""
    study_pv_parameter_ids = [elem for iterabl in
                              [[parameter_value["category"]["@id"] for parameter_value in process["parameterValues"]]
                               for process in study_json["processSequence"]] for elem in iterabl]
    for assay in study_json["assays"]:
        study_pv_parameter_ids.extend([elem for iterabl in
                                       [[parameter_value["category"]["@id"] for parameter_value in
                                         process["parameterValues"]]
                                        for process in assay["processSequence"]] for elem in iterabl]
                                      )
    return study_pv_parameter_ids


def check_protocol_parameter_ids_usage(study_json):
    """Used for rule 1009 and 1020"""
    protocols_declared = get_study_protocols_parameter_ids(study_json) + [
        "#parameter/Array_Design_REF"]  # + special case
    protocols_used = get_parameter_value_parameter_ids(study_json)
    if len(set(protocols_used) - set(protocols_declared)) > 0:
        diff = set(protocols_used) - set(protocols_declared)
        errors.append({
            "message": "Missing Protocol Parameter declaration",
            "supplemental": "protocol parameters {} used".format(list(diff)),
            "code": 1009
        })
        log.error("(E) There are protocol parameters {} used in a study or assay process not declared in any "
                  "protocol".format(list(diff)))
    elif len(set(protocols_declared) - set(protocols_used)) > 0:
        diff = set(protocols_declared) - set(protocols_used)
        warnings.append({
            "message": "Protocol parameter declared in a protocol but never used",
            "supplemental": "protocol declared {} are not used".format(list(diff)),
            "code": 1020
        })
        log.warning("(W) There are some protocol parameters declared {} not used in any study or assay process"
                    .format(list(diff)))


def get_characteristic_category_ids(study_or_assay_json):
    """Used for rule 1013"""
    return [category["@id"].replace("#ontology_annotation", "#characteristic_category")
            for category in study_or_assay_json["characteristicCategories"]]


def get_characteristic_category_ids_in_study_materials(study_json):
    """Used for rule 1013"""
    return [elem for iterabl in
            [[characteristic["category"]["@id"].replace("#ontology_annotation", "#characteristic_category")
              for characteristic in material["characteristics"]] for material in
             study_json["materials"]["sources"] + study_json["materials"]["samples"]] for elem in iterabl]


def get_characteristic_category_ids_in_assay_materials(assay_json):
    """Used for rule 1013"""
    return [elem for iterabl in [[characteristic["category"]["@id"].replace("#ontology_annotation",
                                                                            "#characteristic_category")
                                  for characteristic in material["characteristics"]]
                                 if "characteristics" in material.keys() else [] for material in
                                 assay_json["materials"]["samples"] + assay_json["materials"]["otherMaterials"]] for
            elem in iterabl]


def check_characteristic_category_ids_usage(studies_json):
    """Used for rule 1013"""
    characteristic_categories_declared = list()
    characteristic_categories_used = list()
    for study_json in studies_json:
        characteristic_categories_declared += get_characteristic_category_ids(study_json)
        for assay in study_json["assays"]:
            characteristic_categories_declared_in_assay = get_characteristic_category_ids(assay)
            characteristic_categories_declared += characteristic_categories_declared_in_assay
        characteristic_categories_used += get_characteristic_category_ids_in_study_materials(study_json)
        for assay in study_json["assays"]:
            characteristic_categories_used_in_assay = get_characteristic_category_ids_in_assay_materials(assay)
            characteristic_categories_used += characteristic_categories_used_in_assay
    if len(set(characteristic_categories_used) - set(characteristic_categories_declared)) > 0:
        diff = set(characteristic_categories_used) - set(characteristic_categories_declared)
        errors.append({
            "message": "Missing Characteristic Category declaration",
            "supplemental": "Characteristic Categories {} used not declared".format(list(diff)),
            "code": 1013
        })
        log.error("(E) There are characteristic categories {} used in a source or sample characteristic that have "
                  "not been not declared".format(list(diff)))
    elif len(set(characteristic_categories_declared) - set(characteristic_categories_used)) > 0:
        diff = set(characteristic_categories_declared) - set(characteristic_categories_used)
        warnings.append({
            "message": "Characteristic Category not used",
            "supplemental": "Characteristic Categories {} declared".format(list(diff)),
            "code": 1022
        })
        log.warning("(W) There are characteristic categories declared {} that have not been used in any source or "
                    "sample characteristic".format(list(diff)))


def get_study_factor_ids(study_json):
    """Used for rule 1008 and 1021"""
    return [factor["@id"] for factor in study_json["factors"]]


def get_study_factor_ids_in_sample_factor_values(study_json):
    """Used for rule 1008 and 1021"""
    return [elem for iterabl in [[factor["category"]["@id"] for factor in sample["factorValues"]] for sample in
                                 study_json["materials"]["samples"]] for elem in iterabl]


def check_study_factor_usage(study_json):
    """Used for rules 1008 and 1021"""
    factors_declared = get_study_factor_ids(study_json)
    factors_used = get_study_factor_ids_in_sample_factor_values(study_json)
    if len(set(factors_used) - set(factors_declared)) > 0:
        diff = set(factors_used) - set(factors_declared)
        errors.append({
            "message": "Missing Study Factor declaration",
            "supplemental": "Study Factors {} used".format(list(diff)),
            "code": 1008
        })
        log.error("(E) There are study factors {} used in a sample factor value that have not been not declared"
                  .format(list(diff)))
    elif len(set(factors_declared) - set(factors_used)) > 0:
        diff = set(factors_declared) - set(factors_used)
        warnings.append({
            "message": "Study Factor is not used",
            "supplemental": "Study Factors {} are not used".format(list(diff)),
            "code": 1021
        })
        log.warning("(W) There are some study factors declared {} that have not been used in any sample factor value"
                    .format(list(diff)))


def get_unit_category_ids(study_or_assay_json):
    """Used for rule 1014"""
    return [category["@id"] for category in study_or_assay_json["unitCategories"]]


def get_study_unit_category_ids_in_materials_and_processes(study_json):
    """Used for rule 1014"""
    study_characteristics_units_used = [elem for iterabl in
                                        [[characteristic["unit"]["@id"] if "unit" in characteristic.keys() else None for
                                          characteristic in material["characteristics"]] for material in
                                         study_json["materials"]["sources"] + study_json["materials"]["samples"]] for
                                        elem in iterabl]
    study_factor_value_units_used = [elem for iterabl in
                                     [[factor_value["unit"]["@id"] if "unit" in factor_value.keys() else None for
                                       factor_value in material["factorValues"]] for material in
                                      study_json["materials"]["samples"]] for
                                     elem in iterabl]
    parameter_value_units_used = [elem for iterabl in [[parameter_value["unit"]["@id"]
                                                        if "unit" in parameter_value.keys() else None for
                                                        parameter_value in process["parameterValues"]] for process in
                                                       study_json["processSequence"]] for
                                  elem in iterabl]
    return [x for x in study_characteristics_units_used + study_factor_value_units_used + parameter_value_units_used
            if x is not None]


def get_assay_unit_category_ids_in_materials_and_processes(assay_json):
    """Used for rule 1014"""
    assay_characteristics_units_used = [elem for iterabl in [[characteristic["unit"]["@id"] if "unit" in
                                                                                               characteristic.keys()
                                                              else None
                                                              for characteristic in material["characteristics"]]
                                                             if "characteristics" in material.keys() else None for
                                                             material in assay_json["materials"]["otherMaterials"]] for
                                        elem in iterabl]
    parameter_value_units_used = [elem for iterabl in [[parameter_value["unit"]["@id"]
                                                        if "unit" in parameter_value.keys() else None
                                                        for parameter_value in process["parameterValues"]] for process
                                                       in
                                                       assay_json["processSequence"]] for
                                  elem in iterabl]
    return [x for x in assay_characteristics_units_used + parameter_value_units_used if x is not None]


def check_unit_category_ids_usage(study_json):
    """Used for rules 1014 and 1022"""
    log.info("Getting units declared...")
    units_declared = get_unit_category_ids(study_json)
    for assay in study_json["assays"]:
        units_declared.extend(get_unit_category_ids(assay))
    log.info("Getting units used (study)...")
    units_used = get_study_unit_category_ids_in_materials_and_processes(study_json)
    log.info("Getting units used (assay)...")
    for assay in study_json["assays"]:
        units_used.extend(get_assay_unit_category_ids_in_materials_and_processes(assay))
    log.info("Comparing units declared vs units used...")
    if len(set(units_used) - set(units_declared)) > 0:
        diff = set(units_used) - set(units_declared)
        log.error("(E) There are units {} used in a material or parameter value that have not been not declared"
                  .format(list(diff)))
    elif len(set(units_declared) - set(units_used)) > 0:
        diff = set(units_declared) - set(units_used)
        warnings.append({
            "message": "Unit declared but not used",
            "supplemental": "Units declared {} not used".format(list(diff)),
            "code": 1022
        })
        log.warning("(W) There are some units declared {} that have not been used in any material or parameter value"
                    .format(list(diff)))


def check_utf8(fp):
    """Used for rule 0010"""
    import chardet
    with open(fp.name, "rb") as fp:
        charset = chardet.detect(fp.read())
        if charset["encoding"].upper() != "UTF-8" and charset["encoding"].lower() != "ascii":
            warnings.append({
                "message": "File should be UTF8 encoding",
                "supplemental": "Encoding is '{0}' with confidence {1}".format(charset["encoding"],
                                                                               charset["confidence"]),
                "code": 10
            })
            log.warning("(W) File should be UTF-8 encoding but found it is '{0}' encoding with {1} confidence"
                        .format(charset["encoding"], charset["confidence"]))
            raise SystemError()


def check_isa_schemas(isa_json, investigation_schema_path):
    """Used for rule 0003 and 4003"""
    try:
        with open(investigation_schema_path) as fp:
            investigation_schema = json.load(fp)
            resolver = RefResolver("file://" + investigation_schema_path, investigation_schema)
            validator = Draft4Validator(investigation_schema, resolver=resolver)
            validator.validate(isa_json)
    except ValidationError as ve:
        errors.append({
            "message": "Invalid JSON against ISA-JSON schemas",
            "supplemental": str(ve),
            "code": 3
        })
        log.fatal("(F) The JSON does not validate against the provided ISA-JSON schemas!")
        log.fatal("Fatal error: " + str(ve))
        raise SystemError("(F) The JSON does not validate against the provided ISA-JSON schemas!")


def check_date_formats(isa_json):
    """Used for rule 3001"""

    def check_iso8601_date(date_str):
        if date_str != "":
            try:
                iso8601.parse_date(date_str)
            except iso8601.ParseError:
                warnings.append({
                    "message": "Date is not ISO8601 formatted",
                    "supplemental": "Found {} in date field".format(date_str),
                    "code": 3001
                })
                log.warning("(W) Date {} does not conform to ISO8601 format".format(date_str))

    import iso8601
    try:
        check_iso8601_date(isa_json["publicReleaseDate"])
    except KeyError:
        pass
    try:
        check_iso8601_date(isa_json["submissionDate"])
    except KeyError:
        pass
    for study in isa_json["studies"]:
        try:
            check_iso8601_date(study["publicReleaseDate"])
        except KeyError:
            pass
        try:
            check_iso8601_date(study["submissionDate"])
        except KeyError:
            pass
        for process in study["processSequence"]:
            try:
                check_iso8601_date(process["date"])
            except KeyError:
                pass


def check_dois(isa_json):
    """Used for rule 3002"""

    def check_doi(doi_str):
        if doi_str != "":
            if not _RX_DOI.match(doi_str):
                warnings.append({
                    "message": "DOI is not valid format",
                    "supplemental": "Found {} in DOI field".format(doi_str),
                    "code": 3002
                })
                log.warning("(W) DOI {} does not conform to DOI format".format(doi_str))

    for ipub in isa_json["publications"]:
        try:
            check_doi(ipub["doi"])
        except KeyError:
            pass
    for study in isa_json["studies"]:
        for spub in study["publications"]:
            try:
                check_doi(spub["doi"])
            except KeyError:
                pass


def check_filenames_present(isa_json):
    """Used for rule 3005"""
    for s_pos, study in enumerate(isa_json["studies"]):
        if study["filename"] == "":
            warnings.append({
                "message": "Missing study file name",
                "supplemental": "At study position {}".format(s_pos),
                "code": 3005
            })
            log.warning("(W) A study filename is missing")
        for a_pos, assay in enumerate(study["assays"]):
            if assay["filename"] == "":
                warnings.append({
                    "message": "Missing assay file name",
                    "supplemental": "At study position {}, assay position {}".format(s_pos, a_pos),
                    "code": 3005
                })
                log.warning("(W) An assay filename is missing")


def check_pubmed_ids_format(isa_json):
    """Used for rule 3003"""

    def check_pubmed_id(pubmed_id_str):
        if pubmed_id_str != "":
            if (_RX_PMID.match(pubmed_id_str) is None) and (_RX_PMCID.match(pubmed_id_str) is None):
                warnings.append({
                    "message": "PubMed ID is not valid format",
                    "supplemental": "Found PubMedID {}".format(pubmed_id_str),
                    "code": 3003
                })
                log.warning("(W) PubMed ID {} is not valid format".format(pubmed_id_str))

    for ipub in isa_json["publications"]:
        check_pubmed_id(ipub["pubMedID"])
    for study in isa_json["studies"]:
        for spub in study["publications"]:
            check_pubmed_id(spub["pubMedID"])


def check_protocol_names(isa_json):
    """Used for rule 1010"""
    for study in isa_json["studies"]:
        for protocol in study["protocols"]:
            if protocol["name"] == "":
                warnings.append({
                    "message": "Protocol missing name",
                    "supplemental": "Protocol @id={}".format(protocol["@id"]),
                    "code": 1010
                })
                log.warning("(W) A Protocol {} is missing Protocol Name, so can't be referenced in ISA-tab"
                            .format(protocol["@id"]))


def check_protocol_parameter_names(isa_json):
    """Used for rule 1011"""
    for study in isa_json["studies"]:
        for protocol in study["protocols"]:
            for parameter in protocol["parameters"]:
                if parameter["parameterName"] == "":
                    warnings.append({
                        "message": "Protocol Parameter missing name",
                        "supplemental": "Protocol Parameter @id={}".format(parameter["@id"]),
                        "code": 1011
                    })
                    log.warning("(W) A Protocol Parameter {} is missing name, so can't be referenced in ISA-tab"
                                .format(parameter["@id"]))


def check_study_factor_names(isa_json):
    """Used for rule 1012"""
    for study in isa_json["studies"]:
        for factor in study["factors"]:
            if factor["factorName"] == "":
                warnings.append({
                    "message": "Study Factor missing name",
                    "supplemental": "Study Factor @id={}".format(factor["@id"]),
                    "code": 1012
                })
                log.warning("(W) A Study Factor is missing name, so can't be referenced in ISA-tab"
                            .format(factor["@id"]))


def check_ontology_sources(isa_json):
    """Used for rule 3008"""
    for ontology_source in isa_json["ontologySourceReferences"]:
        if ontology_source["name"] == "":
            warnings.append({
                "message": "Ontology Source missing name ref",
                "supplemental": "name={}".format(ontology_source["name"]),
                "code": 3008
            })
            log.warning("(W) An Ontology Source Reference is missing Term Source Name, so can't be referenced")


def get_ontology_source_refs(isa_json):
    """Used for rules 3007 and 3009"""
    return [ontology_source_ref["name"] for ontology_source_ref in isa_json["ontologySourceReferences"]]


def walk_and_get_annotations(isa_json, collector):
    """Used for rules 3007 and 3009

    Usage:
      collector = list()
      walk_and_get_annotations(isa_json, collector)
      # and then like magic all your annotations from the JSON should be in the collector list
    """
    #  Walk JSON tree looking for ontology annotation structures in the JSON
    if isinstance(isa_json, dict):
        if set(isa_json.keys()) == {"annotationValue", "termAccession", "termSource"} or \
                set(isa_json.keys()) == {"@id", "annotationValue", "termAccession", "termSource"}:
            collector.append(isa_json)
        for i in isa_json.keys():
            walk_and_get_annotations(isa_json[i], collector)
    elif isinstance(isa_json, list):
        for j in isa_json:
            walk_and_get_annotations(j, collector)


def check_term_source_refs(isa_json):
    """Used for rules 3007 and 3009"""
    term_sources_declared = get_ontology_source_refs(isa_json)
    collector = list()
    walk_and_get_annotations(isa_json, collector)
    term_sources_used = [annotation["termSource"] for annotation in collector if annotation["termSource"] != ""]
    if len(set(term_sources_used) - set(term_sources_declared)) > 0:
        diff = set(term_sources_used) - set(term_sources_declared)
        errors.append({
            "message": "Missing Term Source",
            "supplemental": "Ontology sources missing {}".format(list(diff)),
            "code": 3009
        })
        log.error("(E) There are ontology sources {} referenced in an annotation that have not been not declared"
                  .format(list(diff)))
    elif len(set(term_sources_declared) - set(term_sources_used)) > 0:
        diff = set(term_sources_declared) - set(term_sources_used)
        warnings.append({
            "message": "Ontology Source Reference != used",
            "supplemental": "Ontology sources not used {}".format(list(diff)),
            "code": 3007
        })
        log.warning("(W) There are some ontology sources declared {} that have not been used in any annotation"
                    .format(list(diff)))


def check_term_accession_used_no_source_ref(isa_json):
    """Used for rule 3010"""
    collector = list()
    walk_and_get_annotations(isa_json, collector)
    terms_using_accession_no_source_ref = [
        annotation for annotation in collector if annotation["termAccession"] != "" and annotation["termSource"] == ""
    ]
    if len(terms_using_accession_no_source_ref) > 0:
        warnings.append({
            "message": "Missing Term Source REF in annotation",
            "supplemental": "Terms with accession but no source reference {}".format(
                terms_using_accession_no_source_ref),
            "code": 3010
        })
        log.warning("(W) There are ontology annotations with termAccession set but no termSource referenced: {}"
                    .format(terms_using_accession_no_source_ref))


def load_config(config_dir):
    print('CONFIG at: ', config_dir)
    import json
    configs = dict()
    for file in glob.iglob(os.path.join(config_dir, "*.json")):
        try:
            with open(file) as fp:
                config_dict = json.load(fp)
                if os.path.basename(file) == "protocol_definitions.json":
                    configs["protocol_definitions"] = config_dict
                elif os.path.basename(file) == "study_config.json":
                    configs["study"] = config_dict
                else:
                    configs[(config_dict["measurementType"], config_dict["technologyType"])] = config_dict
        except ValidationError:
            errors.append({
                "message": "Configurations could not be loaded",
                "supplemental": "On loading {}".format(file),
                "code": 4001
            })
            log.error("(E) Could not load configuration file {}".format(os.path.basename(file)))
    return configs


def check_measurement_technology_types(assay_json, configs):
    measurement_type = ""
    technology_type = ""
    try:
        measurement_type = assay_json["measurementType"]["annotationValue"]
        technology_type = assay_json["technologyType"]["annotationValue"]
        config = configs[(measurement_type, technology_type)]
        if config is None:
            raise KeyError
    except KeyError:
        errors.append({
            "message": "Measurement/technology type invalid",
            "supplemental": "Measurement {}/technology {}".format(measurement_type, technology_type),
            "code": 4002
        })
        log.error("(E) Could not load configuration for measurement type '{}' and technology type '{}'"
                  .format(measurement_type, technology_type))


def check_study_and_assay_graphs(study_json, configs):
    def check_assay_graph(process_sequence_json, config):
        list_of_last_processes_in_sequence = [i for i in process_sequence_json if "nextProcess" not in i.keys()]
        log.info("Checking against assay protocol sequence configuration {}".format(config["description"]))
        config_protocol_sequence = [i["protocol"] for i in config["protocols"]]
        for process in list_of_last_processes_in_sequence:  # build graphs backwards
            assay_graph = list()
            try:
                while True:
                    process_graph = list()
                    if "outputs" in process.keys():
                        outputs = process["outputs"]
                        if len(outputs) > 0:
                            for output in outputs:
                                output_id = output["@id"]
                                process_graph.append(output_id)
                    protocol_id = protocols_and_types[process["executesProtocol"]["@id"]]
                    process_graph.append(protocol_id)
                    if "inputs" in process.keys():
                        inputs = process["inputs"]
                        if len(inputs) > 0:
                            for input_ in inputs:
                                input_id = input_["@id"]
                                process_graph.append(input_id)
                    process_graph.reverse()
                    assay_graph.append(process_graph)
                    process = [i for i in process_sequence_json if i["@id"] == process["previousProcess"]["@id"]][0]
                    if process['@id'] == process["previousProcess"]["@id"]:
                        log.fatal(
                            "Previous process is same as current process, which forms a loop!!!!!"
                            " Cannot find start node!!!!!!!")
                        break
            except KeyError:  # this happens when we can"t find a previousProcess
                pass
            assay_graph.reverse()
            assay_protocol_sequence = [[j for j in i if not j.startswith("#")] for i in assay_graph]
            assay_protocol_sequence = [i for j in assay_protocol_sequence for i in j]  # flatten list
            assay_protocol_sequence_of_interest = [i for i in assay_protocol_sequence if i in config_protocol_sequence]
            #  filter out protocols in sequence that are not of interest (additional ones to required by config)
            squished_assay_protocol_sequence_of_interest = list()
            prev_prot = None
            for prot in assay_protocol_sequence_of_interest:  # remove consecutive same protocols
                if prev_prot != prot:
                    squished_assay_protocol_sequence_of_interest.append(prot)
                prev_prot = prot
            from metabolomics.isaapi.isatools.utils import contains
            if not contains(squished_assay_protocol_sequence_of_interest, config_protocol_sequence):
                warnings.append({
                    "message": "Process sequence is not valid against configuration",
                    "supplemental": "Config protocol sequence {} does not in assay protocol sequence {}".format(
                        config_protocol_sequence,
                        squished_assay_protocol_sequence_of_interest),
                    "code": 4004
                })
                log.warning("Configuration protocol sequence {} does not match study graph found in {}"
                            .format(config_protocol_sequence, assay_protocol_sequence))

    protocols_and_types = dict([(i["@id"], i["protocolType"]["annotationValue"]) for i in study_json["protocols"]])
    # first check study graph
    log.info("Loading configuration (study)")
    config = configs["study"]
    check_assay_graph(study_json["processSequence"], config)
    for assay_json in study_json["assays"]:
        m = assay_json["measurementType"]["annotationValue"]
        t = assay_json["technologyType"]["annotationValue"]
        log.info("Loading configuration ({}, {})".format(m, t))
        config = configs[(m, t)]
        check_assay_graph(assay_json["processSequence"], config)


def check_study_groups(study_or_assay):
    samples = study_or_assay.samples
    study_groups = set()
    for sample in samples:
        if len(sample.factor_values) > 0:
            factors = tuple(sample.factor_values)
            study_groups.add(factors)
    num_study_groups = len(study_groups)
    log.info('Found {} study groups in {}'.format(num_study_groups,
                                                  study_or_assay.identifier))
    info.append({
        'message': 'Found {} study groups in {}'.format(
            num_study_groups, study_or_assay.identifier),
        'supplemental': 'Found {} study groups in {}'.format(
            num_study_groups, study_or_assay.identifier),
        'code': 5001
    })
    study_group_size_in_comment = study_or_assay.get_comment(
        'Number of Study Groups')
    if study_group_size_in_comment is not None:
        if study_group_size_in_comment != num_study_groups:
            warnings.append({
                'message': 'Reported study group size does not match table'
                    .format(num_study_groups,
                            study_or_assay.identifier),
                'supplemental': 'Study group size reported as {} but found {} '
                                'in {}'.format(study_group_size_in_comment, num_study_groups,
                                               study_or_assay.identifier),
                'code': 5002
            })


BASE_DIR = os.path.dirname(__file__)
default_config_dir = os.path.join(BASE_DIR, "..", "resources", "config", "json", "default")
default_isa_json_schemas_dir = os.path.join(
    BASE_DIR,
    "..",
    "resources",
    "schemas",
    "isa_model_version_1_0_schemas",
    "core"
)


def validate(
        fp,
        config_dir=default_config_dir,
        log_level=None,
        base_schemas_dir="isa_model_version_1_0_schemas"
):
    if config_dir is None:
        config_dir = default_config_dir
    if log_level in (
            logging.NOTSET, logging.DEBUG, logging.INFO, logging.WARNING,
            logging.ERROR, logging.CRITICAL):
        log.setLevel(log_level)
    log.info("ISA JSON Validator from ISA tools API v0.12.")
    stream = StringIO()
    handler = logging.StreamHandler(stream)
    log.addHandler(handler)
    try:
        global errors
        errors = list()
        global warnings
        warnings = list()
        log.info("Checking if encoding is UTF8")
        check_utf8(fp=fp)  # Rule 0010
        log.info("Loading json from " + fp.name)
        isa_json = json.load(fp=fp)  # Rule 0002
        log.info("Validating JSON against schemas using Draft4Validator")
        check_isa_schemas(isa_json=isa_json,
                          investigation_schema_path=os.path.join(BASE_DIR,
                                                                 "..", "resources", "schemas", base_schemas_dir,
                                                                 "core", "investigation_schema.json"))  # Rule 0003
        log.info("Checking if material IDs used are declared...")
        for study_json in isa_json["studies"]:
            check_material_ids_not_declared_used(study_json)  # Rules 1002-1005
        for study_json in isa_json["studies"]:
            check_material_ids_declared_used(study_json, get_source_ids)  # Rule 1015
            check_material_ids_declared_used(study_json, get_sample_ids)  # Rule 1016
            check_material_ids_declared_used(study_json, get_material_ids)  # Rule 1017
            check_material_ids_declared_used(study_json, get_data_file_ids)  # Rule 1018
        log.info("Checking characteristic categories usage...")
        check_characteristic_category_ids_usage(isa_json["studies"])  # Rules 1013 and 1022
        log.info("Checking study factor usage...")
        for study_json in isa_json["studies"]:
            check_study_factor_usage(study_json)  # Rules 1008 and 1021
        log.info("Checking protocol parameter usage...")
        for study_json in isa_json["studies"]:
            check_protocol_parameter_ids_usage(study_json)  # Rules 1009 and 1020
        log.info("Checking unit category usage...")
        for study_json in isa_json["studies"]:
            check_unit_category_ids_usage(study_json)  # Rules 1014 and 1022
        log.info("Checking process sequences (study)...")
        for study_json in isa_json["studies"]:
            check_process_sequence_links(study_json["processSequence"])  # Rule 1006
            log.info("Checking process sequences (assay)...")
            for assay_json in study_json["assays"]:
                check_process_sequence_links(assay_json["processSequence"])  # Rule 1006
        log.info("Checking process protocol usage...")
        for study_json in isa_json["studies"]:
            check_process_protocol_ids_usage(study_json)  # Rules 1007 and 1019
        log.info("Checking date formats...")
        check_date_formats(isa_json)  # Rule 3001
        log.info("Checking DOI formats...")
        check_dois(isa_json)  # Rule 3002
        log.info("Checking Pubmed ID formats...")
        check_pubmed_ids_format(isa_json)  # Rule 3003
        log.info("Checking filenames are present...")
        check_filenames_present(isa_json)  # Rule 3005
        log.info("Checking protocol names...")
        check_protocol_names(isa_json)  # Rule 1010
        log.info("Checking protocol parameter names...")
        check_protocol_parameter_names(isa_json)  # Rule 1011
        log.info("Checking study factor names...")
        check_study_factor_names(isa_json)  # Rule 1012
        log.info("Checking ontology sources...")
        check_ontology_sources(isa_json)  # Rule 3008
        log.info("Checking term source REFs...")
        check_term_source_refs(isa_json)  # Rules 3007 and 3009
        log.info("Checking missing term source REFs...")
        check_term_accession_used_no_source_ref(isa_json)  # Rule 3010
        log.info("Loading configurations from " + config_dir)
        configs = load_config(config_dir)  # Rule 4001
        log.info("Checking measurement and technology types...")
        for study_json in isa_json["studies"]:
            for assay_json in study_json["assays"]:
                check_measurement_technology_types(assay_json, configs)  # Rule 4002
        log.info("Checking against configuration schemas...")
        check_isa_schemas(
            isa_json=isa_json,
            investigation_schema_path=os.path.join(
                default_isa_json_schemas_dir,
                "investigation_schema.json"
            )
        )  # Rule 4003
        # if all ERRORS are resolved, then try and validate against configuration
        handler.flush()
        if "(E)" in stream.getvalue():
            log.fatal("(F) There are some errors that mean validation against configurations cannot proceed.")
            return stream
        fp.seek(0)  # reset file pointer
        log.info("Checking study and assay graphs...")
        for study_json in isa_json["studies"]:
            check_study_and_assay_graphs(study_json, configs)  # Rule 4004
        fp.seek(0)
        # try load and do study groups check
        log.info("Checking study groups...")
        isa = load(fp)
        for study in isa.studies:
            check_study_groups(study)
            for assay in study.assays:
                check_study_groups(assay)
        log.info("Finished validation...")
    except KeyError as k:
        errors.append({
            "message": "JSON Error",
            "supplemental": "Error when reading JSON; key: {}".format(str(k)),
            "code": 2
        })
        log.fatal("(F) There was an error when trying to read the JSON")
        log.fatal("Key: " + str(k))
    except ValueError as v:
        errors.append({
            "message": "JSON Error",
            "supplemental": "Error when parsing JSON; key: {}".format(str(v)),
            "code": 2
        })
        log.fatal("(F) There was an error when trying to parse the JSON")
        log.fatal("Value: " + str(v))
    except SystemError as e:
        errors.append({
            "message": "Unknown/System Error",
            "supplemental": str(e),
            "code": 0
        })
        log.fatal("(F) Something went very very wrong! :(")
    finally:
        handler.flush()
        return {
            "errors": errors,
            "warnings": warnings,
            "validation_finished": True
        }


def batch_validate(json_file_list):
    """ Validate a batch of ISA-JSON files
        :param json_file_list: List of file paths to the ISA-JSON files to validate
        :return: Dict of reports

        Example:
            from isatools import isajson
            my_jsons = [
                "/path/to/study1.json",
                "/path/to/study2.json"
            ]
            my_reports = isajson.batch_validate(my_jsons)
        """
    batch_report = {
        "batch_report": []
    }
    for json_file in json_file_list:
        log.info("***Validating {}***\n".format(json_file))
        if not os.path.isfile(json_file):
            log.warning("Could not find ISA-JSON file, skipping {}".format(json_file))
        else:
            with open(json_file) as fp:
                batch_report["batch_report"].append(
                    {
                        "filename": fp.name,
                        "report": validate(fp)
                    }
                )
    return batch_report
