from isatools.model import *
from isatools.database.models import * 
from isatools.isajson import load

import os,sys
sys.path.append(os.path.abspath(os.path.join('..', 'metabolomics')))

from components.db import get_sqlalchemy_conn_str
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

database_uri =  get_sqlalchemy_conn_str()           
Session = sessionmaker()

engine = create_engine(database_uri)
#session = Session(bind=engine, autoflush=False)
session = Session(bind=engine, autoflush=False)

file_name =r"C:\Users\pmedi\source\repos\lawrence\Bio-Dev\Bio-Dev\api\isaapi\isatab2json1234.json"
f = open(file_name, "r")
inv = load(f)
inv.to_sql(session)
session.commit()


print(inv)
