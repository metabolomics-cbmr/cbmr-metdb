import os
import glob
import pandas as pd 
from pathlib import Path
import datetime
import psycopg2 

import json 
from sqlalchemy import create_engine, select 
from sqlalchemy.orm import sessionmaker
from flask import current_app

from metabolomics.components.db import get_sqlalchemy_conn_str
from metabolomics.components.utilityfns import *

from metabolomics.isaapi.isatools import isatab2json
from metabolomics.isaapi.isatools.model.investigation import Investigation
from metabolomics.isaapi.isatools.database.models.investigation  import Investigation
from metabolomics.isaapi.isatools.isajson import load
from metabolomics.components.xlsx_to_tabdelim import *
from metabolomics.my_exceptions import InputError
from metabolomics.components.db import close_db_conn, get_db_conn



def file_import(upload_folder, folder_name):

    tab_files_path = os.path.join(upload_folder, folder_name, "tabfiles")
    datatable_files_path = os.path.join(upload_folder, folder_name, "datatable")

    print(" Tab files path " + tab_files_path)

    # print("DDDD---" + sys.path.append(os.path.abspath("../..")))

    #convert to tab delimited files 
    files = glob.glob(f"{tab_files_path}/*.xlsx")        

    print(" File count  " + str(len(files)))

    for file in files: 
      #convert to tab 
        tab_file_name = os.path.join(tab_files_path,  Path(file).stem + ".txt")
        convert_to_tab_delim(file, tab_file_name)

    isa_json = isatab2json.convert(tab_files_path, validate_first=True, use_new_parser=True)

    file_name = os.path.join(tab_files_path, get_unique_id() + ".json") 

    jsonFile = open(f"{file_name}", "w")
    jsonFile.write(json.dumps(isa_json))
    jsonFile.close()


    database_uri =  get_sqlalchemy_conn_str()           
    Session = sessionmaker()

    engine = create_engine(database_uri)
    session = Session(bind=engine, autoflush=False)

    f = open(file_name, "r")
    inv = load(f)
    dinv = inv.to_sql(session)
    session.commit()

    inv_id = 0
    stmt  = select(Investigation).where(Investigation.isa_identifier == dinv.isa_identifier)

    result  = session.execute(stmt)
    for row in result:
        inv_id = row.Investigation.investigation_id 
        break


    session = None 
    engine = None
    

    #start with the  results datatable import 
    results_file_import(inv_id, datatable_files_path)

    return inv_id 


def results_file_import(inv_id, results_file_path):

    #files = glob.glob(f"{results_file_path}/*.xlsx")        

   
    try:
        conn = get_db_conn()

        cur = conn.cursor()

        #fetch all assays and their results xlsx file for this investigation 
        stmt = " select distinct adtf.assay_id, dtf.filename  from assay_data_files adtf "
        stmt += " join datafile dtf  on  adtf.data_file_id = dtf.datafile_id  "
        stmt += " join study_assays on study_assays.assay_id = adtf.assay_id  "
        stmt += " join study on study_assays.study_id = study.study_id  "
        stmt += " join investigation i on i.investigation_id  = study.investigation_id "
        stmt += " where i.investigation_id = %s and dtf.label  = 'Derived Data File' "

		 

        cur.execute(stmt, (inv_id,))
        a_rows = cur.fetchall()
        
        print(f" lengh {len(a_rows)}")
        #process the results xls for all files
        for a_row  in a_rows:
            assay_id = a_row[0]
            filename = os.path.join(results_file_path, a_row[1])

            no_path_file_name = filename[filename.rfind("\\")+1:len(filename)]

            current_app.logger.info(f' Data Table {no_path_file_name}')
            print(f" Data table {filename}")

            if os.path.exists(filename):
                print(f" Data table path exists")

                results = pd.read_excel(filename, sheet_name=None)

                #check if file is uploaded 
                # qry = "select id from  PeakTableMerge  where file_name = %s  and assay_id = %s"
                # cur.execute(qry, (file, assay_id))
                # if cur.rowcount > 0:
                #     raise InputError("File already uploaded ")


                # save compound data eventually
                compound_id =  0
                current_time = datetime.datetime.now()


                df =results["datatable"]

                column_names = df.columns 
                num_columns = len(column_names)

                sample_name_colno = 14
                #column 15 is sample_unique 
                # rest from 16 to len(df.columns) - 1 are the compounds

                for index in range(len(df)):

                    sample_id = df.iat[index, sample_name_colno]
                    col_number = sample_name_colno

                    while col_number != num_columns - 1:
                        col_number += 1
                        compound_name = column_names[col_number]
                        intensity = df.iat[index, col_number]
                        print(f' Compound name  - {compound_name} - Intensity - {intensity}')

                        sample_name = df.iat[index, sample_name_colno]

                        # stmt = " select as_smp.sample_id from assay_samples as_smp   "
                        # stmt += "  inner join sample  on as_smp.sample_id = sample.sample_id   "
                        # stmt += " where sample.name = %s and assay_id = %s"

                        stmt = " select sample.id as sample_id from assay_samples as_smp   "
                        stmt += "  inner join sample  on as_smp.sample_id = sample.sample_id   "
                        stmt += " where sample.name = %s and assay_id = %s"

                        cur.execute(stmt, (sample_name, assay_id))
                        sample_row = cur.fetchone()

                        sample_id = sample_row[0]
                        print(f'SampleId {sample_id}')

                        compound_id = 1     #dummy value 
                        
                        #print(f"Assay Id {assay_id}")

                        #use sample_name to get aget assay id using assay_data_files, datafiles
                        stmt = " select data_file_id  from assay_data_files   adtf  "
                        stmt += " join datafile dtf  on  adtf.data_file_id = dtf.datafile_id "
                        stmt += " where dtf.filename = %s  and adtf.assay_id = %s and dtf.label= 'Derived Data File'"

                        cur.execute(stmt, (no_path_file_name, assay_id))
                        datafile_row = cur.fetchone()

                        #print(datafile_row)
                        data_file_id = datafile_row[0]

                        current_time = datetime.datetime.now()

                        stmt = " insert into \"PeakTableMerge\" (sample_id, compound_id, assay_id, data_file_id,  intensity, compound_name, date_time)"
                        stmt += " values(%s, %s, %s, %s, %s, %s, %s)"

                        cur.execute(stmt, (sample_id, compound_id, assay_id, data_file_id, intensity, compound_name, current_time))


                                    
        conn.commit()
        conn.close()
    
        
    except(Exception,psycopg2.DatabaseError, InputError) as err:
        if not conn is None:
            if conn.closed == 0:
                close_db_conn(conn)
        raise err




# def process_assay_results_data(ms, conn, assay_id):

#     #a new compound is saved to database, and the name and id added to this dictionary
#     # to obtain the compound_id. This reduces number of database hits to fetch compound id
#     dict_compounds = {}

#     try:
#             current_app.logger.info('in imprt ssay_results ')
#             df = ms["datatable"]

#             column_names = df.columns 
#             num_columns = len(column_names)

#             sample_name_colno = 15
#             #column 15 is sample_unique 
#             # rest from 16 to len(df.columns) - 1 are the compounds
#             cur = conn.cursor()
#             file_name = ""

#             for index in range(len(df)):

#                 sample_id = df.iat[index, sample_name_colno]
                

#                 while col_number != num_columns - 1:
#                     col_number += 1
#                     compound_name = column_names[col_number]
#                     intensity = df.iat[index, col_number]

#                     sample_name = df.iat[index, sample_name_colno]

#                     stmt = " select as_smp.sample_id from assay_samples as_smp   "
#                     stmt += "  inner join sample  on as_smp.sample_id = sample.sample_id   "
#                     stmt += " where sample.sample_name = %s and assay_id = %s"

#                     cur.execute(stmt, (sample_name, assay_id))
#                     sample_row = cur.fetchone()

#                     sample_id = sample_row[0][0]

#                     compound_id = 1     #dummy value 


#                     #use sample_name to get aget assay id using assay_data_files, datafiles
#                     stmt = " select  from assay_data_files   adtf  "
#                     stmt += " join datafile dtf  on  adtf.data_file_id = dtf.datafile_id "
#                     stmt += " where dtf.filename = %s  and adtf.assay_id = %s "

#                     cur.execute(stmt, (file_name, assay_id))
#                     datafile_row = cur.fetchone()

#                     data_file_id = datafile_row[0][0]

#                     current_time = datetime.datetime.now()

#                     stmt = " insert PeakTableMerge (sample_id, compound_id, intensity, assay_id, data_file_id, compound_name, date_time)"
#                     stmt += " values(%s, %s, %s, %s, %s, %s)"

#                     cur.execute(stmt, (sample_id, compound_id, assay_id, data_file_id, intensity, compound_name, current_time))



#     except(Exception,psycopg2.DatabaseError) as err:
#         raise err

