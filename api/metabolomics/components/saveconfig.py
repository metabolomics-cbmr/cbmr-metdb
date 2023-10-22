import psycopg2
from psycopg2 import sql 
import os 
import datetime 
from metabolomics.components.db import close_db_conn, get_db_conn
from metabolomics.my_exceptions import InputError, CustomException
from flask import jsonify, json

def save_config(settings_data):

    conn = None 

    try:
        

        conn = get_db_conn()
        cur = conn.cursor()

        config_data = {}
        config_data["matching_peaks"] = settings_data["matching_peaks"]
        config_data["matching_score"] = settings_data["matching_score"]

        pepmass_tolerance = []
        pepmass_tolerance.append(float(settings_data["pepmass_tolerance_from"]))
        pepmass_tolerance.append(float(settings_data["pepmass_tolerance_to"]))

        name = settings_data["name"]
        qry = "select id from \"Configs\"  where name = %s "
        cur.execute(qry, (name,))

        if cur.rowcount > 0:
            raise InputError("Configuration with name " + name +  " already exists")


        config_data["pep_mass_tolerance"] = pepmass_tolerance

        qry = " insert into \"Configs\" (name, type, config, active, created_by) values(%s, %s, %s, %s, %s) returning id"
        cur.execute(qry, (name, "USER", json.dumps(config_data), True, 1))

        settingsid = cur.fetchone()[0]
        conn.commit()

        cur.close()
        close_db_conn(conn)

        return settingsid

    except(Exception,psycopg2.DatabaseError, InputError) as err:
        if not conn is None:
            if conn.closed == 0:
                close_db_conn(conn)
        raise err
