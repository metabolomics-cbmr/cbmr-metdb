from flask import json, current_app, render_template
from metabolomics.appbp import app_bp


#@current_app.route("/v1/selectms2")
#@app_bp.route("/selectms2")
def selectms2():
    return render_template("uploadms2.html")
    