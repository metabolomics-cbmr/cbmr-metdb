import os,sys

sys.path.append(os.path.abspath(os.path.join('..', 'metabolomics')))

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from components.db import get_sqlalchemy_conn_str
#from myisaobject import * 

# database_dir = os.path.abspath(os.path.dirname(__file__))

database_uri =  get_sqlalchemy_conn_str()           

#database_uri = f'postgresql://postgres:postgre@postgres/biodevs2'
 #postgresql://postgres:postgre@postgres/biodevs1
#print("SQLALCHEMY -> " + database_uri)
Session = sessionmaker()

engine = create_engine(database_uri)
session = Session(bind=engine)

#create_descriptor()


# to create tables in database 
'''
from main import engine 
from isatools.database.utils import Base
Base.metadata.create_all(engine)
'''
