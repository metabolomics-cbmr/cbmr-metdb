#from matchms.importing import load_from_mgf
import os 
from flask import Flask,  flash, url_for, current_app
from flask_restful import Api
import psycopg2
from werkzeug.utils import secure_filename
from metabolomics.components.db import close_db_conn, get_db_conn
from metabolomics.components.savemgf import *

from rdkit import Chem
from rdkit.Chem import Draw
from matplotlib import pyplot as plt
import uuid 
import matchms.filtering as ms_filters
from matchms import Spectrum, calculate_scores
from matchms.similarity import CosineGreedy
from metabolomics.my_exceptions import InputError, CustomException
import numpy as np


def process_unknown_compound(unknown_ms2_file, compareid, method_id):
    try:
        conn = None 

        ms2mst_id  = import_unknown_compound_ms2(unknown_ms2_file, method_id)

        conn = get_db_conn()
        cur = conn.cursor()

        qry = " select m2dt.*   \
                from \"UnknownMS2Dets\" m2dt \
                join \"UnknownMS2Mst\" m2m on m2dt.ms2mst_id = m2m.id  \
                where m2m.id  = %s "

        cur.execute(qry, (ms2mst_id,))
    
        ms2detrows = cur.fetchall()
        qry_spectrums = []

        for ms2detrow in ms2detrows:
            spectrum = create_spectrum_for_comparison(ms2detrow, conn, False, 0, "", "")

            qry_spectrums.append(spectrum)

        output = compare_compounds(qry_spectrums, conn, ms2mst_id, compareid, method_id)
        #save unknown mgf
        #save results

        close_db_conn(conn)
        #return output 
        return ms2mst_id

        # return results returned from compare_compounds

    except CustomException as err:
        raise err 
    except(Exception,psycopg2.DatabaseError) as err:
        if not conn is None:
           if conn.closed == 0:
               close_db_conn(conn)
        raise err

def compare_compounds(qry_spectrums, conn, ms2mst_id, compareid, method_id):

    try:
        cur = conn.cursor()
        qry = " select config from \"Configs\"  where id = %s " 

        cur.execute(qry, (compareid,))

        data = cur.fetchall()
        current_app.logger.info(" %s data  ", data)        
        config = data[0][0]

        current_app.logger.info(" %s config  ", config)
        output = [] 
        temp_path = os.path.normpath(os.path.join(os.getcwd(),"metabolomics/static/plots") ) 

        num_unique_compounds = 0
        num_rows = 0
        num_over_threshold = 0

        #current_app.logger.info('Query metadata %s  ', qry_spectrums[0].metadata)
        #spectrum = spectrums[0]

        # use non-interactive backend if matplotlib
        #matplotlib.use('agg')
        plt.switch_backend('Agg')

        #current_app.logger.info('NUmOeaks %s  ', numbers_of_peaks)
        numbers_of_peaks = [len(s.peaks.mz) for s in qry_spectrums]
        #current_app.logger.info('NUmOeaks %s  ', numbers_of_peaks)

        plt.figure(figsize=(5,4), dpi=150)
        plt.hist(numbers_of_peaks, 20, edgecolor="white")
        plt.title("Peaks per spectrum (before filtering)")
        plt.xlabel("Number of peaks in spectrum")
        plt.ylabel("Number of spectra")
        fnm ="m" + str(ms2mst_id) + "_"+ str(uuid.uuid4()) + ".png"
        imagefile = os.path.join(temp_path, fnm) 
        peak_prefilter_hist_url = url_for("static", filename="plots/" + fnm)
        plt.savefig(imagefile)
        plt.close(imagefile)

        qry_spectrums = [metadata_processing(s) for s in qry_spectrums]
        qry_spectrums = [peak_processing(s) for s in qry_spectrums]

        ###########################
        numbers_of_peaks = [len(s.peaks.mz) for s in qry_spectrums]
        #current_app.logger.info('NUmOeaks %s  ', numbers_of_peaks)

        plt.figure(figsize=(5,4), dpi=150)
        plt.hist(numbers_of_peaks, 20, edgecolor="white")
        plt.title("Peaks per spectrum (after filtering)")
        plt.xlabel("Number of peaks in spectrum")
        plt.ylabel("Number of spectra")
        fnm = "m" + str(ms2mst_id) + "_"+ str(uuid.uuid4()) + ".png"
        imagefile = os.path.join(temp_path, fnm) 
        peak_postfilter_hist_url = url_for("static", filename="plots/"+ fnm)
        plt.savefig(imagefile)
        plt.close(imagefile)


        #update hist url in UnknownMs2Mst
        qry = "update \"UnknownMS2Mst\" set peak_prefilter_hist_url = %s, \
                        peak_postfilter_hist_url = %s \
                where id = %s "
        cur.execute(qry, (peak_prefilter_hist_url, peak_postfilter_hist_url, ms2mst_id ))

        unknown_prefix = 'Unknown'
        ctr = 0
        for tspectrum in qry_spectrums:
            spectrums = []
            spectrums.append(tspectrum)
            ctr = ctr + 1

            qry_compound_name = unknown_prefix + str(ctr)

            #qry = " select tag, config_name, "
                
            precursor_mass = tspectrum.metadata["pepmass"]

            # from pepmass tolerance value is saved as a negative value, so no need to subtract
            filter_from = float(precursor_mass[0]) + float(config["pep_mass_tolerance"][0])
            filter_to = float(precursor_mass[0]) + float(config["pep_mass_tolerance"][1])

            #select compounds for comparison based on precursor mass
            sql = "select distinct md.compound_id, cm.name, cm.smiles \
                    from \"MS1Dets\" md \
                        inner join \"MS1Mst\"  ms \
                            on md.ms1_mst_id = ms.id \
                            inner join \"Compound\" cm  \
                                on md.compound_id = cm.id  \
                    where md.library_mz between %s and %s  and ms2_available = 'Y' \
                            and ms.method_id = %s  \
                                order by md.compound_id "
                    

            cur.execute(sql, (filter_from, filter_to, method_id))
            
            mstrows = cur.fetchall()
            if len(mstrows) == 0:
                raise InputError(f"Reference compounds matching query precursor mass {precursor_mass} not found")
            else:
                num_unique_compounds = len(mstrows)

            lib_spectrums =[]
            #dict_compound = {}
            # the compound and smiles data gets stored wrongly after the calculate_scores below. 
            # multiple rows for same compound & collison energy are shown but SMILES structure is different 
            dict_compound = {}
            for row in mstrows:
                num_rows = num_rows + 1

                lib_spectrums = []
                #for compound, fetch ms2dets
                # create metadata object
                # fetch peaks data
                # create spectrum object as reference .add to list

                #run cosine funtion
                #print the first 10 highest scores
                #along with compound name, structure, peak graph 
                smiles = row[2]
                compound_name = row[1]
                compound_id = row[0]
                #current_app.logger.info('Compound %s SMILES_1 %s  ', compound_name, smiles)

                dict_compound[compound_id] = smiles 
                #precursor mass filter from 0.1 to 0.001 Da)
                # sql = " select m2dt.*   \
                #         from \"MS2Dets\" m2dt \
                #         join \"MS2Mst\" m2m on m2dt.ms2mst_id = m2m.id  \
                #         where m2m.compound_id = %s "
                sql = " select distinct m2dt.*   \
                        from \"MS2Dets\" m2dt \
                            inner join \"MS2Mst\"  ms2ms on  m2dt.ms2mst_id = ms2ms.id \
                        where m2dt.compound_id = %s  and ms2ms.method_id = %s"

                cur.execute(sql, (compound_id, method_id))
            
                ms2detrows = cur.fetchall()
                if len(ms2detrows) == 0:
                    current_app.logger.info(f"MS2 data not uploaded for {compound_name}")
                    continue 

                scans = 0
                spectrum_id = 0

                for ms2detrow in ms2detrows:
                    lib_spectrums = []

                    lib_spectrum = create_spectrum_for_comparison(ms2detrow, conn, True, compound_id, compound_name, smiles)
                    
                    #lib_spectrum.metadata["compound_id"] = compound_id
                    #current_app.logger.info('Lib spectrum compound id %s   :  ',   compound_id)
                    #lib_spectrum.metadata["compound"] = compound_name 

                    current_app.logger.info('Lib_spectrum length %s   :  query spectrum length  %s ',   len(lib_spectrums), len(qry_spectrums))

                    lib_spectrums.append(lib_spectrum)
                    match_function = "Cosine Greedy"
                    scores = calculate_scores(references=lib_spectrums, \
                                        queries=spectrums, \
                                        similarity_function = CosineGreedy())
                    
                    #best_matches = scores.scores_by_query(query, sort=True)
                    # run a loop  assuming that qry_spectrum has multiple spectra
                    #current_app.logger.info(' Scores :  %s   :',  scores)
                    
                    over_threshold = "no"
                    for (reference, query, score) in scores:

                        if reference is query:
                            continue 
                        #current_app.logger.info(' In score loop : reference %s   : query %s', reference.metadata, query.metadata)
                        #if reference is not query:
                        # if "compound" in reference.metadata and "compound" in query.metadata:
                        #     if reference.metadata["compound"] == query.metadata["compound"]:
                        #         current_app.logger.info('Same compound %s  ', reference.metadata["compound"]) 
                        
                        matching_peaks = int(score["matches"])
                        match_score = float(score["score"])

                        if matching_peaks >= int(config["matching_peaks"]) and  match_score >= float(config["matching_score"]):
                            num_over_threshold = num_over_threshold + 1
                            over_threshold = "yes"

                        plt.figure(figsize=(5,4), dpi=100)
                        plt.title("MZ Intensity")
                        plt.xlabel("m/z")
                        plt.ylabel("Intensity")
                        fnm = "d" + str(query.metadata["ms2_det_row_id"]) + "_" + str(uuid.uuid4()) + ".png"
                        imagefile = os.path.join(temp_path, fnm) 
                        query.plot()

                        plt.savefig(imagefile)
                        plt.close(imagefile)
                        output_ele = {}
                        mz_intensity_plot_url = url_for("static", filename="plots/" + fnm)

                        qry = " update \"UnknownMS2Dets\" set mz_intensity_plot_url = %s \
                                where id = %s "
                        cur.execute (qry, (mz_intensity_plot_url, query.metadata["ms2_det_row_id"]))

                        plt.figure(figsize=(5,4), dpi=100)
                        plt.title("MZ Intensity")
                        plt.xlabel("m/z")
                        plt.ylabel("Intensity")
                        fnm = "r" + str(query.metadata["ms2_det_row_id"]) + "_" + str(uuid.uuid4()) + ".png"
                        imagefile = os.path.join(temp_path, fnm) 
                        ref_qry_mz_plot_url = url_for("static", filename="plots/" + fnm)

                        reference.plot_against(query)

                        plt.savefig(imagefile)  
                        plt.close(imagefile)              

                        current_app.logger.info('Reference compound id %s   :  ',   reference.metadata["compound_id"])

                        t_smiles = dict_compound[reference.metadata["compound_id"]]
                        m = Chem.MolFromSmiles(t_smiles)
                        #Draw.MolToFile(m, f"compound_{i}.png")  
                        fnm = "r" + str(query.metadata["ms2_det_row_id"]) + "_" + secure_filename(compound_name) + ".png"
                        imagefile = os.path.join(temp_path, fnm) 
                        ref_structure_url = url_for("static", filename="plots/" + fnm)
                        Draw.MolToFile(m, imagefile)  


                        

                        #mz_peak_hist_urlmz_intensity_plot_urlref_qry_mz_plot_url

                        qcompound_id = None
                        qry = "INSERT INTO \"UnknownDetectionResults\"( \
                                    ms2det_id, ref_compound_id, ref_retention_time, ref_collision_energy, \
                                    matching_peaks, score, ref_precursor_mass, qry_compound_id, qry_retention_time, \
                                    qry_collision_energy, qry_precursor_mass, match_method, \
                                    ref_scan_number, qry_scan_number, instrument_used, ref_qry_mz_plot_url, \
                                        ref_structure_url,over_threshold) \
                                values(%s, %s, %s, %s, \
                                        %s, %s, %s, %s, %s, \
                                        %s,%s,%s, %s, %s, %s, %s, %s,%s) "
                        cur.execute(qry, (query.metadata["ms2_det_row_id"], reference.metadata["compound_id"], \
                                        reference.metadata["retention_time"], reference.metadata["collision_energy"], \
                                        matching_peaks, match_score, reference.metadata["pepmass"][0] , \
                                        qcompound_id, query.metadata["retention_time"], query.metadata["collision_energy"], \
                                        query.metadata["pepmass"][0], match_function, reference.metadata["scans"], \
                                        query.metadata["scans"], "", ref_qry_mz_plot_url, ref_structure_url, over_threshold))
                                        

            qry = " INSERT INTO \"UnknownComparisonMisc\"( \
                        ms2mst_id, matching_peak_threshold, matching_score_threshold, \
                        pep_mass_tolerance_from, pep_mass_tolerance_to, num_rows_processed, \
                        num_unique_compounds, num_rows_over_threshold) \
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"
            cur.execute(qry, (ms2mst_id, int(config["matching_peaks"]), float(config["matching_score"]), \
                       int(config["pep_mass_tolerance"][0]), int(config["pep_mass_tolerance"][1]), num_rows, \
                       num_unique_compounds, num_over_threshold))

        conn.commit()
        cur.close()

    except CustomException as err:
        
        raise err 
    except InputError as err:
        raise err 
    except(Exception,psycopg2.DatabaseError) as err:
        raise err


# @app_bp.route("/upload_ms2", methods=['GET','POST'])
# def upload_ms2():
#     if request.method == 'POST':
#         allowed_extensions = ["mgf"]
#         upload_folder = os.path.normpath(os.path.join(os.getcwd(),"metabolomics/uploads")) 

#         current_app.logger.info('in POST ')

def peak_processing(spectrum):
    spectrum = ms_filters.default_filters(spectrum)
    spectrum = ms_filters.normalize_intensities(spectrum)
    spectrum = ms_filters.select_by_intensity(spectrum, intensity_from=0.01)
    spectrum = ms_filters.select_by_mz(spectrum, mz_from=10, mz_to=1000)
    return spectrum

def metadata_processing(spectrum):
    spectrum = ms_filters.default_filters(spectrum)
    spectrum = ms_filters.repair_inchi_inchikey_smiles(spectrum)
    spectrum = ms_filters.derive_inchi_from_smiles(spectrum)
    spectrum = ms_filters.derive_smiles_from_inchi(spectrum)
    spectrum = ms_filters.derive_inchikey_from_inchi(spectrum)
    spectrum = ms_filters.harmonize_undefined_smiles(spectrum)
    spectrum = ms_filters.harmonize_undefined_inchi(spectrum)
    spectrum = ms_filters.harmonize_undefined_inchikey(spectrum)
    spectrum = ms_filters.add_precursor_mz(spectrum)
    return spectrum


def create_spectrum_for_comparison(ms2detrow, conn, is_lib_data, compound_id, compound_name, smiles):

    try:
        #scans = ms2detrow[0]
        #spectrum_id = ms2detrow[1]
        ms2detid  = ms2detrow[0]
        #collision_energy  = ms2detrow[3]
        #retention_time = ms2detrow[4]

        spectrum_meta = {}
        spectrum_meta["compound_id"] = compound_id
        spectrum_meta["compound"] = compound_name
        spectrum_meta["smiles"] = smiles
        spectrum_meta["ms2_det_row_id"] = ms2detid
        spectrum_meta["scans"] = ms2detrow[2]
        spectrum_meta["mslevel"] = ms2detrow[3]
        spectrum_meta["retention_time"] = ms2detrow[4]
        spectrum_meta["centroided"] = ms2detrow[5]
        spectrum_meta["polarity"] = ms2detrow[6]
        spectrum_meta["precscannum"] = ms2detrow[7]
        spectrum_meta["pepmass"] = [ms2detrow[8]]
        spectrum_meta["pepmassint"] = ms2detrow[9]
        spectrum_meta["charge"] = ms2detrow[10]
        spectrum_meta["collision_energy"] = ms2detrow[11]  
        spectrum_meta["peakscount"] = ms2detrow[12]
        spectrum_meta["totioncurrent"] = ms2detrow[13]
        spectrum_meta["basepeakmz"] = ms2detrow[14]
        spectrum_meta["basepeakintensity"] = ms2detrow[15]  
        spectrum_meta["ionisationenergy"] = ms2detrow[16] 
        spectrum_meta["lowmz"] = ms2detrow[17] 
        spectrum_meta["highmz"] = ms2detrow[18]
        spectrum_meta["peak_index"] = ms2detrow[19]
        spectrum_meta["peak_id"] = ms2detrow[20]
        spectrum_meta["scanindex"] = ms2detrow[21]
        spectrum_meta["spectrum_id"] = ms2detrow[22]                    

        cur = conn.cursor()

        ms2peak_table = ""
        if is_lib_data == True:
            ms2peak_table = "MS2Peak"
        else:
            ms2peak_table = "UnknownMS2Peak"

        qry = sql.SQL(" select mz, intensity  from {table} m2pk \
            where   m2pk.ms2_det_id = %s  ").format(table=sql.Identifier(ms2peak_table))

        cur.execute(qry, (ms2detid, ))

        rows = cur.fetchall()
        numrows = len(rows)


        mz_list = []
        intensity_list = []

        #prepare mz and intensity list for library data spectrum object 
        for row in rows:
            mz_list.append(row[0])
            intensity_list.append(row[1]) 
            #assumption - one scan for a compound

        spectrum = Spectrum(mz=np.array(mz_list,dtype=np.float64),
                intensities=np.array(intensity_list,dtype=np.float64),
                metadata=spectrum_meta)
        #current_app.logger.info('PepMass 0 type %s  ', type(spectrum.metadata["pepmass"][0]))


        return spectrum

    except(Exception,psycopg2.DatabaseError) as err:
        raise err
