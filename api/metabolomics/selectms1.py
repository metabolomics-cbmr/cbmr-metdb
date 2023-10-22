from flask import json, current_app, render_template
from metabolomics.appbp import app_bp


#@current_app.route("/v1/selectms1")
#@app_bp.route("/selectms1")
def selectms1():
   return render_template("uploadms1.html")
