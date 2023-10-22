import psycopg2
import psycopg2.extras
from metabolomics.components.db import close_db_conn, get_db_conn
from flask import render_template , current_app, jsonify , redirect, url_for 
from metabolomics.appbp import app_bp
from metabolomics.components.utilityfns import get_unhandled_exception_details

@app_bp.route("/dashboarddata", methods=['GET'])
def get_dashboard_data():
    conn = None 

    try:
        conn = get_db_conn()
        cur = None 
        #curr = conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)
        cur = conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)

        sql = " select * from public.\"GetDashboardDisplayData\"() "

        cur.execute(sql)
        data = cur.fetchall() 
        cur.close()
        conn.close()

        prevCatg = ""
        currCatg = ""
        output = {}
        data_dict = {}

        if len(data) > 0:        
            for row in data:
                currCatg = row["category"]
                if prevCatg == "":
                    prevCatg = currCatg

                if prevCatg != currCatg:
                    output[prevCatg] = data_dict
                    prevCatg = currCatg 
                    data_dict = {}

                if not row["tag"].find("LIST") == -1:
                    lst_dict = {}
                    if row["tag_data"] != None:
                        lst = row["tag_data"].split(",") 
                        for el in lst:
                            lst_dict[el.split(":")[0]] =  el.split(":")[1]

                    data_dict[row["tag"].replace("_LIST", "")] = lst_dict  #row["tag_data"].split(",")


                    # if row["tag_data"] == None:
                    #     continue 
                    
                    # lst = row["tag_data"].split(",") 
                    # for el in lst:
                    #     lst_dict[el.split(":")[0]] =  el.split(":")[1]

                    # data_dict[row["tag"].replace("_LIST", "")] = lst_dict  #row["tag_data"].split(",")

                elif not row['tag'].find("GRAPH") == -1:

                    if row["tag_data"] == "0:":
                        continue 

                    data_dict["tag"] = row["tag"]
                    tdata = row["tag_data"].split(":")
                    data_dict["link"] = tdata[1]
                    data_dict["id"] = tdata[0]
                else:
                    data_dict[row["tag"]] = row["tag_data"]
            
            # #get  dict of last category in data 
            # if len(data_dict) != 0:
            output[prevCatg] = data_dict

        return jsonify(output),200

        
    except(Exception,psycopg2.DatabaseError) as err:
        if not conn is None:
            if not cur is None:
                if cur.closed == 0:
                    cur.close()

            if conn.closed == 0:
                close_db_conn(conn)
        
        e_dict = get_unhandled_exception_details()
        return jsonify(e_dict), 500
        #raise err

############
@app_bp.route("/dashboarddata/<tagdata>/<refid>", methods=['GET'])
def get_dashboard_data_ms1_ms2(tagdata, refid):

    try:
        if tagdata == "LAST_THREE_MS1":
            return redirect(url_for('app_bp.displayms1', id=refid, client="external"))

        elif tagdata == "LAST_THREE_MS2":
            return redirect(url_for('app_bp.displayms2list', mstid=refid, client="external"))
        
        else:
            raise Exception("Invalid  data tag for dashboard data history retrieval")

    except(Exception,psycopg2.DatabaseError) as err:
        e_dict = get_unhandled_exception_details()
        return jsonify(e_dict), 500



###########################
@app_bp.route("/dashboarddata/<tagdata>", methods=['GET'])
@app_bp.route("/dashboarddata/<tagdata>/<page>,<count>", methods=['GET'])
def get_dashboard_data_details(tagdata, page=0, count=0):

    try:
        conn = None
        if tagdata in ['MISSING_INCHIKEY', 'MISSING_SMILES', 'MISSING_CHEBIKEY', 'MISSING_URL', 'ALL_COMPOUNDS']:
            conn = get_db_conn()
            cur = None 

            qry = 'SELECT id, name as "Compound Name", name_corrected, mass_spec_polarity Polarity,  \
                        molecular_formula as  "Molecular Formula" , mono_molecule_mass as  "Mono Molecular Mass" ,  \
                        has_adduct_h as "Has Adduct H?" , has_adduct_na as "Has Adduct Na?" ,  \
                        has_adduct_k as  "Has Adduct K?" , has_adduct_fa as "Has Adduct Fa?" ,  \
                        has_fragment_loss_h2o  as "Has Fragment Loss H2O" ,  \
                        has_fragment_loss_hcooh as "Has Fragment Loss HCOOH?" , \
                        has_fragment_loss_fa as  "Has Fragment Loss Fa?" ,  \
                        pubchem_id as "PubChem Id", pubchem_url as "PubChem Url" , pubchem_sid as "PubChem SId" ,  \
                        extra_pc_cid as "Extra PubChem Ids" ,  \
                        cas_id  CAS , kegg_id_csid  as "KEGG Id" , hmdb_ymdb_id as "HMDB YMDB Id" ,  \
                        metlin_id as "METLIN Id" , chebi  CheBi ,  \
                        smiles as "SMILES" , canonical_smiles as "Canonical SMILES" , inchi_key as "InChi Key" ,  \
                        class_chemical_taxonomy as "Class Chemical Taxonomy" ,  \
                        subclass_chemical_taxonomy as "Sub Class Chemical Taxonomy" ,  \
                        supplier_cat_no as "Supplier Category No" , supplier_product_name as "Supplier Product Name" ,  \
                        biospecimen_locations as "Biospecimen Locations" , tissue_locations as "Tissue Locations"    \
                FROM "Compound"  '
            
            if tagdata == 'MISSING_INCHIKEY':
                filter = " inchi_key is null or inchi_key = 'nan' or inchi_key = '' "
            elif tagdata == "MISSING_SMILES":
                filter = " smiles is null or smiles = 'nan' or smiles = '' "
            elif tagdata == "MISSING_MS2":
                filter = " ms2_available = 'N' "
            elif tagdata == "MISSING_CHEBIKEY" :
                filter = " chebi =   ''  "
            elif tagdata == "MISSING_URL":
                filter = "pubchem_url = '' "
            elif tagdata == 'ALL_COMPOUNDS':
                filter = " name is not null "

            else:
                return  jsonify("{ code:405, description:'Invalid  data tag'}"), 405 

            qry = qry + " where " + filter + " order by name  "

            if int(count) > 0:
                qry = qry + " LIMIT %s OFFSET %s   "

            current_app.logger.info(qry + ' ' + filter )


            #curr = conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)
            cur = conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)

            offset = (int(page) - 1) * int(count)
            if int(count) == 0:
                cur.execute(qry)    
            else:
                cur.execute(qry, (int(count), offset))    


            data = cur.fetchall()
            cur.close()
            close_db_conn(conn)

            return jsonify(data),200
        elif tagdata == 'MISSING_MS2' :
            conn = get_db_conn()
            cur = None 
            filter = " ms2_available = 'N' "


            qry = 'SELECT cm.name "Compound Name", ion Ion,  \
                peak_note as "Peak Note", large_peak as "Large Peak",  \
                spectra_confirmation "Spectra Confirmation Source", \
                remarks Comments,  \
                library_rt_rf1 as "Library RT - RF", \
                library_rt_rf_updated as "Updated Library RT - RF", \
                library_rt_hillic1 as "Library RT - HILLIC",  \
                library_mz as "Library M/Z", measured_mz as "mesaured M/Z",  \
                mass_diff as "Difference in Observed Mass", \
                mass_diff_ppm "Difference in Mass PPM", \
                ms2_available "MS2 Data Available?",  \
                library_name as "Library Name", project_name as "Project Name", \
            data_file_name as "File Name" \
            FROM public."MS1Dets" join "Compound" cm  \
                on compound_id = cm.id   '
            

            qry = qry + " where  " + filter  + " order by cm.name  "

            if int(count) > 0:
                qry = qry + " LIMIT %s OFFSET %s   "

            cur = conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)

            if int(count) == 0:
                cur.execute(qry)    
            else:
                offset = (int(page) - 1) * int(count)
                cur.execute(qry, (int(count), offset)) 


            data = cur.fetchall()
            cur.close()
            close_db_conn(conn)

            return jsonify(data), 200
        
        else:
            raise Exception('Invalid missing data tag')

            

    except(Exception,psycopg2.DatabaseError) as err:
        if not conn is None:
            if not cur is None:
                if cur.closed == 0:
                    cur.close()

            if conn.closed == 0:
                close_db_conn(conn)
        
        e_dict = get_unhandled_exception_details()
        return jsonify(e_dict), 500
        #return jsonify("{code:500, description:" + str(err) + "}"), 500 


# @app_bp.route("/dashboarddata/ALL_COMPOUNDS/<page>,<count>", methods=['GET'])
# def display_all_compounds(page, count):

#     try:
#         qry = 'SELECT id, name as "Compound Name", name_corrected, mass_spec_polarity Polarity,  \
#                     molecular_formula as  "Molecular Formula" , mono_molecule_mass as  "Mono Molecular Mass" ,  \
#                     has_adduct_h as "Has Adduct H?" , has_adduct_na as "Has Adduct Na?" ,  \
#                     has_adduct_k as  "Has Adduct K?" , has_adduct_fa as "Has Adduct Fa?" ,  \
#                     has_fragment_loss_h2o  as "Has Fragment Loss H2O" ,  \
#                     has_fragment_loss_hcooh as "Has Fragment Loss HCOOH?" , \
#                     has_fragment_loss_fa as  "Has Fragment Loss Fa?" ,  \
#                     pubchem_id as "PubChem Id", pubchem_url as "PubChem Url" , pubchem_sid as "PubChem SId" ,  \
#                     extra_pc_cid as "Extra PubChem Ids" ,  \
#                     cas_id  CAS , kegg_id_csid  as "KEGG Id" , hmdb_ymdb_id as "HMDB YMDB Id" ,  \
#                     metlin_id as "METLIN Id" , chebi  CheBi ,  \
#                     smiles  SMILES , canonical_smiles as "Canonical SMILES" , inchi_key as "InChi Key" ,  \
#                     class_chemical_taxonomy as "Class Chemical Taxonomy" ,  \
#                     subclass_chemical_taxonomy as "Sub Class Chemical Taxonomy" ,  \
#                     supplier_cat_no as "Supplier Category No" , supplier_product_name as "Supplier Product Name" ,  \
#                     biospecimen_locations as "Biospecimen Locations" , tissue_locations as "Tissue Locations"    \
#             FROM "Compound"  order by name \
#             LIMIT %s OFFSET %s   '

#         conn = get_db_conn()
#         cur = None 
#         cur = conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)
#         cur.execute(qry, (int(count), int(page) - 1))    

#         data = cur.fetchall()
#         return jsonify(data), 200
    
#     except(Exception,psycopg2.DatabaseError) as err:
#         if not conn is None:
#             if not cur is None:
#                 if cur.closed == 0:
#                     cur.close()

#         if conn.closed == 0:
#             close_db_conn(conn)

#         return jsonify("{code:500, description:" + str(err) + "}"), 500 
        

    #return {"TAGDATA":tagdata, "ID":id}