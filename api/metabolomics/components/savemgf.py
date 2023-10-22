from matchms.importing import load_from_mgf
from werkzeug.utils import secure_filename
from flask import json, current_app 
import psycopg2
from psycopg2 import sql 
import os 
import datetime 
from metabolomics.components.db import close_db_conn, get_db_conn
from metabolomics.my_exceptions import InputError, CustomException


def get_mgf_data(file_name):
    return list(load_from_mgf(file_name))


def  import_unknown_compound_ms2(file_name):
    try:
        spectrums = get_mgf_data(file_name)

        found_zero_peaks = check_zero_peaks(spectrums)

        if found_zero_peaks == True:
            raise InputError("One or more spectrum data does not contain peaks. Upload cancelled")


        ms2mst_id = save_ms2(spectrums, file_name, "")

        return ms2mst_id 

    except Exception as err:
        raise err


def import_known_compound_ms2(file_name, compound_name):

    try:

        spectrums = get_mgf_data(file_name)

        found_zero_peaks = check_zero_peaks(spectrums)

        if found_zero_peaks == True:
            raise InputError("One or more spectrum data does not contain peaks. Upload cancelled")


        ms2mst_id = save_ms2(spectrums, file_name, compound_name)

        return ms2mst_id     

    except Exception as err:
        raise err


def save_ms2(spectrums, file_name, pcompound_name):

    try:

        #file_name = "2,3-Dihydroxybenzoate_10.mgf"

        no_path_file_name = file_name[file_name.rfind("\\")+1:len(file_name)]

        conn=None 
        conn = get_db_conn()

        curr = conn.cursor()

        compound_id=  0
        is_library_data = False 

        ms2mst_table = ""
        ms2dets_table = ""
        ms2peak_table = ""

        if pcompound_name == "":
            is_library_data = False 
            compound_id = None 
        else:
            is_library_data = True


            qry = "select id from \"MS2Mst\" where file_name = %s "
            curr.execute(qry, (no_path_file_name,))
            if curr.rowcount > 0:
                raise InputError("File already uploaded ")

            compounds = {}
            compounds = get_compounds(spectrums, pcompound_name, conn)

            if len(compounds["not_found"]) > 0:
                if len(compounds["found"]) != 0:
                    # if some compounds are nissing in the compound table ignore for now
                    current_app.logger.info(' %s missing compounds', ','.join(compounds['not_found']))
                    #raise InputError(f"Compounds not found in database {','.join(compounds['not_found'])}")
                else:
                    # if no compounds found, that ,means all compounds in file are missin gin comound table 
                    raise InputError(f"All compounds in file are are not found in database {','.join(compounds['not_found'])}")



            #current_app.logger.info(' %s this  compound ', compound_name)

            # qry = " select id from \"Compound\"  where name = %s"
            # curr.execute(qry, (compound_name,))
            # if curr.rowcount > 0:
            #     compound_id = curr.fetchone()[0]
            # else:
            #     raise Exception("Compound name not found in database")

        dt = current_time = datetime.datetime.now()            

        num_spectra = len(spectrums)
        #predicted data or experimental data
        pred_or_exp = ""

        if is_library_data == True:
            ms2mst_table = "MS2Mst"
            ms2dets_table = "MS2Dets"
            ms2peak_table = "MS2Peak"
            pred_or_exp = "P"
        else:
            ms2mst_table = "UnknownMS2Mst"
            ms2dets_table = "UnknownMS2Dets"
            ms2peak_table = "UnknownMS2Peak"
            pred_or_exp = "E"

        qry = sql.SQL(" insert into {table} ( data_source_id, predicted_experimental, mass_spec_type_id, \
                spectrum_id, file_format, file_name, import_date, num_spectra_in_file)   \
                VALUES ( %s, %s, %s, %s, %s, %s, %s, %s) \
                returning id ").format(table=sql.Identifier(ms2mst_table))

        curr.execute(qry, (1, pred_or_exp, 1, 0, '.mgf', no_path_file_name, dt, num_spectra))
        ms2mst_id = curr.fetchone()[0]
            

        #current_app.logger.info(' Spectrum metadata type %  metadata %s ', type(spectrum), type(spectrum.metadata))
        for spectrum in spectrums:

            #check if data for that scan number already exists 
            # sql = " select id from  \"%s\"   where scan_index = %s  and ms2mst_id = %s"
            # curr.execute(sql, (spectrum.metadata["scanindex"], ms2mst_id ))

            # if curr.rowcount > 0:
            #     # data for that scan_index already exists
            #     # check with Lawrence .. whether same ms2 data can be obtained for same  scan index can we have different 
            #     # collision energy or retention time 

            #     continue 
            #     #raise Exception("Data for " + compound_name + " - Scan Index " +  str(spectrum.metadata["scanindex"]) + "already exists")

            peaks_count = 0
            peak_index = 0
            peak_id = ""

            # if mgf file does not contain compound_name element, that means file name 
            # contains the compound_name
            if "compound_name" in spectrum.metadata:
                compound_name = spectrum.metadata["compound_name"] 
            else:
                compound_name = pcompound_name
            
            if is_library_data == True:
                if compound_name in compounds["found"]:
                    compound_id = compounds["found"][compound_name]
                else:   
                    continue 
            else:
                compound_id = None

            if "peakscount"  in spectrum.metadata:
                peaks_count = spectrum.metadata["peakscount"] 

            if "peak_index"  in spectrum.metadata:
                peak_index = spectrum.metadata["peak_index"] 

            if "peak_id"  in spectrum.metadata:
                peak_id = spectrum.metadata["peak_id"] 

            qry = sql.SQL(" INSERT INTO  {table} (  \
                ms2mst_id, spec_scan_num, ms_level, retention_time_secs, centroided, polarity, prec_scan_num, \
                    precursor_mass, precursor_intensity, precursor_charge, collision_energy, from_file, original_peaks_count, \
                    total_ion_current, base_peak_mz, base_peak_intensity, ionisation_energy,  \
                    low_mz, high_mz, injection_time_secs, peak_index, peak_id, scan_index, spectrum_id, compound_id) \
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)  \
                returning id").format(table=sql.Identifier(ms2dets_table))
            
            curr.execute(qry, (ms2mst_id, spectrum.metadata["scans"],  spectrum.metadata["mslevel"], spectrum.metadata["retention_time"], spectrum.metadata["centroided"], spectrum.metadata["polarity"], \
                        spectrum.metadata["precscannum"], spectrum.metadata["pepmass"][0], spectrum.metadata["pepmassint"],spectrum.metadata["charge"], spectrum.metadata["collision_energy"], \
                        no_path_file_name, peaks_count,  spectrum.metadata["totioncurrent"], spectrum.metadata["basepeakmz"], spectrum.metadata["basepeakintensity"], \
                    spectrum.metadata["ionisationenergy"], spectrum.metadata["lowmz"], spectrum.metadata["highmz"], spectrum.metadata["injectiontime"], peak_index, peak_id,  \
                            spectrum.metadata["scanindex"], spectrum.metadata["spectrum_id"], compound_id))
            
            #spectrum.metadata["peakscount"]

            # curr.execute(sql, (scanid, spectrum.metadata["scans"],  spectrum.metadata["mslevel"], spectrum.metadata["retention_time"], spectrum.metadata["centroided"], spectrum.metadata["polarity"], \
            #             spectrum.metadata["precscannum"], spectrum.metadata["pepmass"][0], spectrum.metadata["pepmassint"],spectrum.metadata["charge"], spectrum.metadata["collision_energy"], \
            #             file_name, spectrum.metadata["peakscount"],  spectrum.metadata["totioncurrent"], spectrum.metadata["basepeakmz"], spectrum.metadata["basepeakintensity"], \
            #         spectrum.metadata["ionisationenergy"], spectrum.metadata["lowmz"], spectrum.metadata["highmz"], spectrum.metadata["injectiontime"], 0,0 ))

            id = curr.fetchone()[0]

            numpeaks = len(spectrum.peaks.mz) 

            for x in range(numpeaks):
                qry = sql.SQL(" INSERT INTO {table} (ms2_det_id, mz, intensity) 	\
                    VALUES ( %s, %s, %s)").format(table=sql.Identifier(ms2peak_table))

                curr.execute(qry, ( id,  spectrum.peaks.mz[x], spectrum.peaks.intensities[x]))

        conn.commit()
        close_db_conn(conn) 

        return ms2mst_id
        
    except InputError as err:
        raise err 
    except(Exception,psycopg2.DatabaseError) as err:
        if not conn is None:
            if conn.closed == 0:
                close_db_conn(conn)
        raise err




def get_compounds(spectrums, pcompound_name, conn):
    compounds = {}
    compounds_found = {}
    compounds_missing = []
    curr  = None 
    try:
        curr = conn.cursor()
        qry = "select count(*) from \"Compound\" "
        curr.execute(qry)
        if curr.rowcount == 0:
            raise InputError("Please upload MS1 Data first, then retry")

        #if one spectrum in file has compound_name element, it is assumed that all spectra in that file 
        #will have the compound_name element
        if "compound_name" in spectrums[0].metadata:

            for spectrum in spectrums:

                comp_name = spectrum.metadata["compound_name"] 

                qry = " select id from \"Compound\"  where name = %s"
                curr.execute(qry, (comp_name,))
                if curr.rowcount == 1:
                    compounds_found[comp_name] = curr.fetchone()[0]
                elif curr.rowcount == 0:
                    current_app.logger.info(' %s missing ', comp_name)
                    compounds_missing.append(comp_name)
                else:
                    raise CustomException(f"Multiple rows found for compound {comp_name}")
        else:
            qry = " select id from \"Compound\"  where name = %s"
            curr.execute(qry, (pcompound_name,))
            if curr.rowcount == 1:
                compounds_found[pcompound_name] = curr.fetchone()[0]
            elif curr.rowcount == 0:
                compounds_missing.append(pcompound_name)
            else:
                raise CustomException(f"Multiple rows found for compound {pcompound_name}")

        if curr.closed == False :
            curr.close() 

        compounds["found"] = compounds_found
        compounds["not_found"] = compounds_missing

        return compounds

    except InputError  as err:
        if curr != None:
            if curr.closed == False: 
                curr.close()
        raise err

    except CustomException  as err:
        if curr != None:
            if curr.closed == False: 
                curr.close()
        raise err

    except(Exception, psycopg2.DatabaseError) as err:
        if curr != None:
            if curr.closed == False: 
                curr.close()
        raise err



def check_zero_peaks(spectrums):
    
    for spectrum in spectrums:
        if len(spectrum.peaks.mz)  == 0:
            return True 

    return False 

#     {'title': 'msLevel 2; retentionTime ; scanNum', 'mslevel': '2', 
# 'scans': '1707', 
# 'scanindex': '1707', 
# 'centroided': 'TRUE', 
# 'polarity': '0', 
# 'precscannum': '1706', 
# 'pepmass': (153.01904297, None), 
# 'pepmassint': '0', 
# 'charge': 0, 
# 'peakscount': '58', 
# 'totioncurrent': '29048', 
# 'basepeakmz': '153.0195084',
# 'basepeakintensity': '15468', 
# 'ionisationenergy': '0',
# 'lowmz': '48.0426702', 
# 'highmz': '690.95388812', 
# 'injectiontime': '0', 
# 'retention_time': 180.1848, 
# 'collision_energy': '10',
# 'spectrum_id': 'scan=1707', 
# 'precursor_mz': 153.01904297}

# try:
#     file_import()
# except(Exception) as ex:
#     print("Error encountered", ex)


