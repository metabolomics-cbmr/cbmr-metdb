from werkzeug.utils import secure_filename
from flask import json, current_app 
import psycopg2
import os 
import pandas as pd
import datetime 
import pytz
from metabolomics.my_exceptions import InputError
from metabolomics.components.db import close_db_conn, get_db_conn

def file_import(file_name, assay_id):

    no_path_file_name = file_name[file_name.rfind("\\")+1:len(file_name)]
    
    try:


        results = pd.read_excel(file_name, sheet_name=None)

        conn=None 
        conn = get_db_conn()

        cur = conn.cursor()

        #check if file is uploaded 
        qry = "select id from  PeakTableMerge  where file_name = %s  and assay_id = %s"
        cur.execute(qry, (no_path_file_name, assay_id))
        if cur.rowcount > 0:
            raise InputError("File already uploaded ")


        # save compound data eventually



        # loop over the data in the file 
        # check if sample belongs to that assay
        # thenimport data 
        compound_id =  0
        current_time = datetime.datetime.now()

        # sql = " insert into \"MS1Mst\" ( file_name, import_date, user_id) VALUES (%s, %s, %s)  returning id "
        # cur.execute(sql, (no_path_file_name, dt, 1))
        # ms1_mst_id = cur.fetchone()[0]


        process_assay_results_data(results, conn, assay_id)

                                
        conn.commit()
        conn.close()

        
        
    except(Exception,psycopg2.DatabaseError, InputError) as err:
        if not conn is None:
            if conn.closed == 0:
                close_db_conn(conn)
        raise err




def process_assay_results_data(ms, conn, assay_id):

    #a new compound is saved to database, and the name and id added to this dictionary
    # to obtain the compound_id. This reduces number of database hits to fetch compound id
    dict_compounds = {}

    try:
            current_app.logger.info('in imprt ssay_results ')
            df = ms["datatable"]

            column_names = df.columns 
            num_columns = len(column_names)

            sample_name_colno = 15
            #column 15 is sample_unique 
            # rest from 16 to len(df.columns) - 1 are the compounds
            cur = conn.cursor()
            file_name = ""

            for index in range(len(df)):

                sample_id = df.iat[index, sample_name_colno]
                

                while col_number != num_columns - 1:
                    col_number += 1
                    compound_name = column_names[col_number]
                    intensity = df.iat[index, col_number]

                    sample_name = df.iat[index, sample_name_colno]

                    stmt = " select as_smp.sample_id from assay_samples as_smp   "
                    stmt += "  inner join sample  on as_smp.sample_id = sample.sample_id   "
                    stmt += " where sample.sample_name = %s and assay_id = %s"

                    cur.execute(stmt, (sample_name, assay_id))
                    sample_row = cur.fetchone()

                    sample_id = sample_row[0][0]

                    compound_id = 1     #dummy value 


                    #use sample_name to get aget assay id using assay_data_files, datafiles
                    stmt = " select  from assay_data_files   adtf  "
                    stmt += " join datafile dtf  on  adtf.data_file_id = dtf.datafile_id "
                    stmt += " where dtf.filename = %s  and adtf.assay_id = %s "

                    cur.execute(stmt, (file_name, assay_id))
                    datafile_row = cur.fetchone()

                    data_file_id = datafile_row[0][0]

                    current_time = datetime.datetime.now()

                    stmt = " insert PeakTableMerge (sample_id, compound_id, intensity, assay_id, data_file_id, compound_name, date_time)"
                    stmt += " values(%s, %s, %s, %s, %s, %s)"

                    cur.execute(stmt, (sample_id, compound_id, assay_id, data_file_id, intensity, compound_name, current_time))



    except(Exception,psycopg2.DatabaseError) as err:
        raise err


def save_compound(df, index, polarity, conn):

    try:    

        compound_id = 0
        cur = conn.cursor()
        sql = " select id from \"Compound\" where name = %s "
        cur.execute(sql, (df['Compound.name'].loc[index].strip(), ))

        if cur.rowcount > 0:
            #current_app.logger.info('%s  found in master', df['Compound.name'].loc[index].strip() )
            compound_id = cur.fetchone()[0]

            #MS1 excel does not have all valid values for compound.name_corrected , sp disabled 
            #until data is corrected 20221026
            #if (not df['Compound.name_corrected'].loc[index].strip() == ""):
            #    compound_name = df['Compound.name_corrected'].loc[index].strip()


        adduct_fa="N"
        adduct_na = "N"
        adduct_k = "N"
        adduct_h = "Y"      #by defaylt present in both POS and NEG compounds
        frag_loss_h2o = 'N'
        frag_loss_hcooh = 'N'
        frag_loss_fa = 'N'

        if  df['Fragment.loss.H2O'].loc[index] == "YES":
            frag_loss_h2o = "Y"
        else:
            frag_loss_h2o = "N"

        if 'Fragment.loss.HCOOH' in df:
            if  df['Fragment.loss.HCOOH'].loc[index] == "YES":
                frag_loss_hcooh = "Y"
            else:
                frag_loss_hcooh = "N"

        if  df['Fragment.loss.FA'].loc[index] == "YES":
            frag_loss_fa = "Y"
        else:
            frag_loss_fa = "N"


        if "Adduct.FA" in df:
            if df['Adduct.FA'].loc[index] == "YES":
                adduct_fa = "Y"
            else:
                adduct_fa = "N"
        else:
            adduct_fa = "N" 

        if "Adduct.Na" in df:
            if df['Adduct.Na'].loc[index] == "YES":
                adduct_na = "Y"
            else:
                adduct_na = "N"
        else:
            adduct_na = "N" 

        if "Adduct.K" in df:
            if df['Adduct.K'].loc[index] == "YES":
                adduct_k = "Y"
            else:
                adduct_k = "N"
        else:
            adduct_k = "N" 

        # check if data is string nan or numeric NaN
        pc_url = ''
        if 'PC.url' in df:
            if not pd.isna(df['PC.url'].loc[index]):
                #current_app.logger.info('PC URL not nan %s',  df['Compound.name'].loc[index])                            
                pc_url = str(df['PC.url'].loc[index])
        else:    
            if not pd.isna(df['pubchem_url'].loc[index]):
                pc_url = str(df['pubchem_url'].loc[index])

        pc_cid = ''
        if 'PC.CID' in df:
            if not pd.isna(df['PC.CID'].loc[index]):
                pc_cid = str(df['PC.CID'].loc[index])
        else:    
            if not pd.isna(df['pubchem_cid'].loc[index]):
                pc_cid = str(df['pubchem_cid'].loc[index])


        pc_sid = ''
        if 'PC.SID' in df:
            if not pd.isna(df['PC.SID'].loc[index]):
                pc_sid = str(df['PC.SID'].loc[index])

        cas = ''
        if not pd.isna(df['CAS'].loc[index]):
            cas = str(df['CAS'].loc[index])

        kegg_csid = ''
        if not pd.isna(df['KEGG.ID.CSID'].loc[index]):
            kegg_csid = str(df['KEGG.ID.CSID'].loc[index])

        hmdb_ymdb_id = ''
        if not pd.isna(df['HMDB.YMDB.ID'].loc[index]):
            hmdb_ymdb_id = str(df['HMDB.YMDB.ID'].loc[index])

        metlin_id = ''
        if not pd.isna(df['METLIN.ID'].loc[index]):
            metlin_id = str(df['METLIN.ID'].loc[index])

        chebi = ''
        if not pd.isna(df['ChEBI'].loc[index]):
            chebi  = str(df['ChEBI'].loc[index])

        smiles = ''
        if not pd.isna(df['SMILES'].loc[index]):
            smiles = str(df['SMILES'].loc[index])

        inchi_key = ''
        if not pd.isna(df['InChIKey'].loc[index]):
            inchi_key = str(df['InChIKey'].loc[index])

        cls_chem_taxnmy = ''
        if not pd.isna(df['Class.chemical.taxonomy'].loc[index]):
            cls_chem_taxnmy = str(df['Class.chemical.taxonomy'].loc[index])

        sub_cls_chem_taxnmy = ''
        if not pd.isna(df['Sub.class.chemical.taxonomy'].loc[index]):
            sub_cls_chem_taxnmy = str(df['Sub.class.chemical.taxonomy'].loc[index])

        supp_cat_no = ''
        if not pd.isna(df['Supplier.cat.no'].loc[index]):
            supp_cat_no = str(df['Supplier.cat.no'].loc[index])
        
        supp_prod_name = ''
        if not pd.isna(df['Supplier.product.name'].loc[index]):
            supp_prod_name = str(df['Supplier.product.name'].loc[index])

        bio_locations = ''
        if not pd.isna(df['Biospecimen.locations'].loc[index]):
            bio_locations = str(df['Biospecimen.locations'].loc[index])

        tissue_locations = ''
        if not pd.isna(df['Tissue.locations'].loc[index]):
            tissue_locations= str(df['Tissue.locations'].loc[index])

        canonical_smiles = ''
        if not pd.isna(df['CanonicalSMILES'].loc[index]):
                canonical_smiles = str(df['CanonicalSMILES'].loc[index])

        extra_pc_cid  = ''
        if not pd.isna(df['Comments.extra.PC.CID'].loc[index]):
                extra_pc_cid = str(df['Comments.extra.PC.CID'].loc[index])

        #current_app.logger.info('befroe save compounsd %s %s', compound_id, compound_name )

        sql = "call public.\"SaveCompound\" ( %s, %s, %s, %s, \
                        %s, %s, %s, \
                        %s, %s, %s, \
                        %s, %s, %s,\
                        %s, %s, %s, %s, \
                        %s, %s, %s, %s, \
                        %s, %s, \
                        %s, %s, \
                        %s, %s,  \
                        %s, %s, %s) "

        cur.execute(sql, (compound_id, df['Compound.name'].loc[index].strip(), polarity, df['Molecular.formula'].loc[index],  \
                    df['Monoisotopic.molecular.mass'].loc[index], adduct_h, adduct_na, \
                    adduct_k, adduct_fa, frag_loss_h2o, \
                    frag_loss_hcooh, pc_cid, pc_url, \
                    pc_sid, cas, kegg_csid, hmdb_ymdb_id, \
                    metlin_id, chebi, smiles,inchi_key, \
                    cls_chem_taxnmy,  sub_cls_chem_taxnmy, \
                    supp_cat_no, supp_prod_name, \
                    bio_locations, tissue_locations, \
                    extra_pc_cid, frag_loss_fa, canonical_smiles))                            
        
        if compound_id == 0:
            compound_id = cur.fetchone()[0]

        cur.close()

        return compound_id 

    except(Exception,psycopg2.DatabaseError) as err:
        raise err



def save_ms1_dets(df, index, compound_id, ms1_mst_id, conn):

    try:
        cur = conn.cursor() 
        ms2_available = "N"
        if "MS2.available" in df:
            if df['MS2.available'].loc[index] == "YES":
                ms2_available = "Y"
            else:
                ms2_available = "N"
        elif "MS2" in df:
            if df['MS2'].loc[index] == "YES":
                ms2_available = "Y"
            else:
                ms2_available = "N"
        else:
            ms2_available = "N"

        peak_note = ''
        if not pd.isna(df['Peak.note'].loc[index]):
            peak_note = df['Peak.note'].loc[index]

        comments = ''
        if not pd.isna(df['Comments'].loc[index]):
            comments = df['Comments'].loc[index]

        rt_RF1 = None
        if "Library.rt.RF" in df:
            if not pd.isna(df['Library.rt.RF'].loc[index]):
                rt_RF1 = df['Library.rt.RF'].loc[index]

        rt_HILLIC1 = None
        if "Library.rt.HILLIC" in df:
            if not pd.isna(df['Library.rt.HILLIC'].loc[index]):
                rt_HILLIC1 = df['Library.rt.HILLIC'].loc[index]


        project_name = ''
        if 'project.name' in df:
            if not pd.isna(df['project.name'].loc[index]):
                project_name = df['project.name'].loc[index]

        data_file_name = ''
        if 'Filename' in df:
            if not pd.isna(df['Filename'].loc[index]):
                data_file_name = df['Filename'].loc[index]

        rt_RF_updated = None 
        if 'Library.rt.RF_updated' in df:
            if not pd.isna(df['Library.rt.RF_updated'].loc[index]):
                rt_RF_updated = df['Library.rt.RF_updated'].loc[index]

        library_name = ''
        if 'Library.name' in df:
            if not pd.isna(df['Library.name'].loc[index]):
                library_name = df['Library.name'].loc[index]
        
        spectra_confirmation = ''
        if 'Spectra.confirmation' in df:
            if not pd.isna(df['Spectra.confirmation'].loc[index]):
                spectra_confirmation= df['Spectra.confirmation'].loc[index]

        # rt_RF1 = None
        # if not pd.isna(df['Library.rt.RF'].loc[index]):
        #         rt_RF1 = df['Library.rt.RF'].loc[index]

        # rt_HILLIC1 = None
        # if not pd.isna(df['Library.rt.HILLIC'].loc[index]):
        #         rt_HILLIC1 = df['Library.rt.HILLIC'].loc[index]

        # project_name = ''
        # if 'project.name' in df: 
        #     if not pd.isna(df['project.name'].loc[index]):
        #         project_name = df['project.name'].loc[index]
        # else:
        #     if not pd.isna(df['Project.name'].loc[index]):
        #         project_name = df['Project.name'].loc[index]

        # data_file_name = ''
        # if not pd.isna(df['Filename'].loc[index]):
        #         data_file_name = df['Filename'].loc[index]

        # rt_RF_updated = None 
        # if not pd.isna(df['Library.rt.RF_updated'].loc[index]):
        #         rt_RF_updated = df['Library.rt.RF_updated'].loc[index]

        # library_name = ''
        # if not pd.isna(df['Library.name'].loc[index]):
        #         library_name = df['Library.name'].loc[index]

        # spectra_confirmation = ''
        # if 'Spectra.confirmation' in df:
        #     if not pd.isna(df['Spectra.confirmation'].loc[index]):
        #         spectra_confirmation= df['Spectra.confirmation'].loc[index]


        sql = " INSERT INTO \"MS1Dets\" (  \
                    ms1_mst_id, compound_id, ion, peak_note,   \
                    mass_diff_ppm, spectra_confirmation, remarks,  \
                    library_mz, library_rt_rf1, library_rt_hillic1, \
                    measured_mz, mass_diff, ms2_available, \
                    project_name, data_file_name, library_rt_rf_updated, library_name) \
                VALUES (%s, %s, %s, %s,   \
                        %s, %s, %s,  \
                        %s, %s, %s, \
                        %s, %s, %s, \
                        %s, %s, %s, %s) "

        cur.execute(sql, (ms1_mst_id, compound_id,  df['Ion'].loc[index], peak_note,  \
                    df['Mass.diff.ppm'].loc[index], spectra_confirmation, comments, \
                    df['Library.mz'].loc[index], rt_RF1, rt_HILLIC1, \
                    df['Measured.mz'].loc[index]	, df['Mass.diff'].loc[index], ms2_available,  \
                    project_name, data_file_name, rt_RF_updated, library_name))

        cur.close()

    except(Exception,psycopg2.DatabaseError) as err:
        raise err
