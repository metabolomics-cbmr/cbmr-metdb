from werkzeug.utils import secure_filename
from flask import json, current_app 
import psycopg2
import os 
import pandas as pd
import datetime 
import pytz
from metabolomics.my_exceptions import InputError
from metabolomics.components.db import close_db_conn, get_db_conn

def file_import(file_name, method_id):
    no_path_file_name = file_name[file_name.rfind("\\")+1:len(file_name)]
    polarity_list = ["POS", "NEG"]
    
    try:

        #read all the sheets in the MS1 Excel file 
        ms = pd.read_excel(file_name, sheet_name=None)


        conn=None 

        #open database connection 
        conn = get_db_conn()

        #vreate cursor to run commands
        cur = conn.cursor()

        # check if MS1 fil eis already uploaded 
        qry = "select id from \"MS1Mst\" where file_name = %s "
        cur.execute(qry, (no_path_file_name,))
        if cur.rowcount > 0:
            raise InputError("File already uploaded ")

        compound_id =  0
        dt = current_time = datetime.datetime.now()

        sql = " insert into \"MS1Mst\" ( file_name, import_date, user_id, method_id) VALUES (%s, %s, %s, %s)  returning id "
        cur.execute(sql, (no_path_file_name, dt, 1, method_id))
        ms1_mst_id = cur.fetchone()[0]


        #read all sheets in the XLS and save relevant data in database 
        for polarity in polarity_list:

            process_ms1_data(ms, polarity, ms1_mst_id, conn)

                                
        conn.commit()
        conn.close()

        return ms1_mst_id
        
    except(Exception,psycopg2.DatabaseError, InputError) as err:
        if not conn is None:
            if conn.closed == 0:
                close_db_conn(conn)
        raise err


def process_ms1_data(ms, polarity, ms1_mst_id, conn):

    data_suffix = ["_compound_table", "_adduct_fragment"]

    #a new compound is saved to database, and the name and id added to this dictionary
    # to obtain the compound_id. This reduces number of database hits to fetch compound id
    dict_compounds = {}
    try:
        for suffix in data_suffix:
            current_app.logger.info('in sheet  %s', polarity + suffix)
            df = ms[polarity + suffix]

            for index in range(len(df)):
                compound_id = 0

                compound_name = df['Compound.name'].loc[index].strip()

                if not compound_name in dict_compounds:  #compounds processed for first time
                    # current_app.logger.info('in not found in dict %s', compound_name )

                    compound_id = save_compound(df, index, polarity, conn)

                    dict_compounds[compound_name] = compound_id 
                else:
                    compound_id = dict_compounds[compound_name]


                save_ms1_dets(df, index, compound_id, ms1_mst_id,  conn)

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
