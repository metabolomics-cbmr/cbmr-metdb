
# import psycopg2
# import psycopg2.extras
# from metabolomics.components.db import close_db_conn, get_db_conn
# from flask import render_template , current_app, jsonify
# from metabolomics.appbp import app_bp
# from metabolomics.components.utilityfns import *

# # @app_bp.route("/isadata/<id>, <client>")
# #@app_bp.route("/isadata/<client>")
# def displayisa(id, client):
#     try:
#         conn = get_db_conn()

#         curr = conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)

#         sql = " select investigation_id, identifier, title  \
#                  from \"investigation\"  inv \
#                   where investigation_id = %s "

#         curr.execute(sql, (id,))
#         mst = curr.fetchone() 

#         sql = " select investigation_id, isa_identifier, description, submission_date, public_release_date  \
#                  from \"investigation\"   inv  \
#                   where inv.investigation_id  = %s  "


#         curr.execute(sql, (id,))
#         det = curr.fetchall() 

#         #current_app.logger.info(' Type of det %s ', det)
#         if client =="flask":
#             return render_template('isadata.html', mst=mst, det=det)


#         output = {}
#         output["mst"] = mst
#         output["det"] = det

#         return jsonify(output),200

#     except(Exception,psycopg2.DatabaseError) as err:
#         if not conn is None:
#             if conn.closed == 0:
#                 close_db_conn(conn)

#         if client == "flask":
#             raise err
        
#         e_dict = get_unhandled_exception_details()
#         return jsonify(e_dict), 500
        
#         #return jsonify("{code:500, description:" + str(err) + "}"), 500 


