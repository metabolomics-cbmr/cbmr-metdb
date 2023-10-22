import os
from sqlite3 import DatabaseError
import sys
import psycopg2
from configparser import ConfigParser
from flask import current_app 


#fetch database configuration from ini file 
def get_db_config(filename='database.ini', section='postgresql'):

    """ database.ini has structure as given below

        host=localhost
        database="db_name"
        user="user_name"
        password="password"
    """    
    try:

        parser = ConfigParser()
        parser.read("metabolomics/" + filename)
        
        #dictionary
        db = {}
        if parser.has_section(section):
            params = parser.items(section)

            for param in params:
                current_app.logger.info(' in parser param ')
                db[param[0]] = param[1]
        
        return db

    except Exception as ex:
        raise ex 

def get_db_conn():

    conn = None
    try:
        params = get_db_config()
        conn = psycopg2.connect(**params)
        return conn 

    except (Exception, psycopg2.DatabaseError) as error:
        raise error 



def close_db_conn(conn):
    if conn.closed == 0:
        conn.close()

def get_cursor(conn, cursor_type=None):
    cur = None 
    if cursor_type == None:
        cur = conn.cursor()
    elif cursor_type == "col_names":
        cur = conn.cursor(cursor_factory = psycopg2.extras.RealDictCursor)
    else:
        raise Exception("Invalid cursor type passed")
    
    return cur 