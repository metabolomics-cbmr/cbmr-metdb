#from symbol import pass_stmt
import psycopg2
from metabolomics.components.db import close_db_conn, get_db_conn
from flask import render_template , current_app
from metabolomics.appbp import app_bp

@app_bp.route("/displayunknown/<data>")
def displayunknown(data):
    try:
        return render_template('unknowndata.html', data=data)

    except(Exception,psycopg2.DatabaseError) as err:
        raise err


