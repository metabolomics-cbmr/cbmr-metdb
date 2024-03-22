import glob
import pandas as pd 
from pathlib import Path

from flask import json, current_app, render_template
from metabolomics.appbp import app_bp


#@current_app.route("/v1/selectms1")
#@app_bp.route("/selectms1")
def selectisa(tab_files_path):

   #convert to tab delimited files 
   files = glob.glob(f"{tab_files_path}/*.xlsx")        

   for file in files: 
      #convert to tab 
      
      file = pd.read_excel(file)

      #get the file name before the extension
      file.to_csv(Path(file).stem + ".txt",
            sep="\t",
            index=False)




   return render_template("uploadisa.html")
