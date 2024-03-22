"""ISA Model 1.0 implementation in Python.

This module implements the ISA Abstract Model 1.0 as Python classes, as
specified in the `ISA Model and Serialization Specifications 1.0`_, and
additional classes to support compatibility between ISA-Tab and ISA-JSON.

Todo:
    * Check consistency with published ISA Model
    * Finish docstringing rest of the module
    * Add constraints on attributes throughout, and test

.. _ISA Model and Serialization Specs 1.0: http://isa-specs.readthedocs.io/

"""

from metabolomics.isaapi.isatools.model.assay import Assay
from metabolomics.isaapi.isatools.model.characteristic import Characteristic
from metabolomics.isaapi.isatools.model.comments import Commentable, Comment
from metabolomics.isaapi.isatools.model.context import set_context
from metabolomics.isaapi.isatools.model.datafile import (
    DataFile,
    RawDataFile,
    DerivedDataFile,
    RawSpectralDataFile,
    DerivedArrayDataFile,
    ArrayDataFile,
    DerivedSpectralDataFile,
    ProteinAssignmentFile,
    PeptideAssignmentFile,
    DerivedArrayDataMatrixFile,
    PostTranslationalModificationAssignmentFile,
    AcquisitionParameterDataFile,
    FreeInductionDecayDataFile
)
from metabolomics.isaapi.isatools.model.factor_value import FactorValue, StudyFactor
from metabolomics.isaapi.isatools.model.investigation import Investigation
from metabolomics.isaapi.isatools.model.logger import log
from metabolomics.isaapi.isatools.model.material import Material, Extract, LabeledExtract
from metabolomics.isaapi.isatools.model.mixins import MetadataMixin, StudyAssayMixin, _build_assay_graph
from metabolomics.isaapi.isatools.model.ontology_annotation import OntologyAnnotation
from metabolomics.isaapi.isatools.model.ontology_source import OntologySource
from metabolomics.isaapi.isatools.model.parameter_value import ParameterValue
from metabolomics.isaapi.isatools.model.person import Person
from metabolomics.isaapi.isatools.model.process import Process
from metabolomics.isaapi.isatools.model.process_sequence import ProcessSequenceNode
from metabolomics.isaapi.isatools.model.protocol import Protocol, load_protocol_types_info
from metabolomics.isaapi.isatools.model.protocol_component import ProtocolComponent
from metabolomics.isaapi.isatools.model.protocol_parameter import ProtocolParameter
from metabolomics.isaapi.isatools.model.publication import Publication
from metabolomics.isaapi.isatools.model.sample import Sample
from metabolomics.isaapi.isatools.model.source import Source
from metabolomics.isaapi.isatools.model.study import Study
from metabolomics.isaapi.isatools.model.logger import log
from metabolomics.isaapi.isatools.model.utils import _build_assay_graph, plink, batch_create_assays, batch_create_materials, _deep_copy
