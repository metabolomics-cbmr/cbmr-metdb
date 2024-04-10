
from main import engine 
from isatools.database.utils import Base
Base.metadata.create_all(engine)

print(" ISA tables created. ")
