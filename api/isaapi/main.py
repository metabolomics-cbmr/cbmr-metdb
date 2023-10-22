import os
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
#from myisaobject import * 

# database_dir = os.path.abspath(os.path.dirname(__file__))
database_uri = f'postgresql://postgres:postgre@localhost/biodevs'

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
