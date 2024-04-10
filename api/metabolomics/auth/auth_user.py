from metabolomics.components.db import close_db_conn, get_db_conn, get_cursor
from metabolomics.appbp import app_bp
from metabolomics.my_exceptions import InputError
from flask import Flask, current_app, jsonify, request 
import psycopg2 

@app_bp.route("/auth/login", methods=['POST'])
def authenticate_user():
    try:
        conn = None 

        email = request.form['email']
        pwd = request.form['pwd']

        if email.strip() == "" or pwd.strip() == "":
            raise InputError("Email / Password cannot be blank")

        conn = get_db_conn()
        cur = get_cursor(conn, "col_names")

        msg = {}
        qry = " select id, name from \"User\" where email_id = %s and pwd = %s " 
        cur.execute(qry, (email, pwd))
        data = cur.fetchall()

        current_app.logger.info('Len of data %s ', data)
        if len(data) == 1:
            msg["user_id"] = data[0]["id"]
            msg["user_name"] = data[0]["name"]

            return jsonify(msg), 200
        elif len(data) == 0:
            raise InputError("User name/password is incorrect")
        else:
            raise Exception("Multiple user records found") 

        cur.close()
        close_db_conn(conn)

        return jsonify(msg), 200

    except InputError as err:
        return jsonify("{code:400, description:" + str(err) + "}"), 400

    except(Exception,psycopg2.DatabaseError) as err:
        if not conn is None:
            if conn.closed == 0:
                close_db_conn(conn)

        return jsonify("{code:500, description:" + str(err) + "}"), 500 
