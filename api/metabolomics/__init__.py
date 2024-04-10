import os
import logging 

from flask import Flask, render_template 
from metabolomics.appbp import app_bp
from flask_cors import CORS



def create_app(test_config=None):
    #logging.basicConfig(filename='example.log',level=logging.DEBUG)
    
    # create and configure the app
    app = Flask(__name__, instance_relative_config=True)
    CORS(app)


    # app.config.from_mapping(
    #     SECRET_KEY='dev',
    #     DATABASE=os.path.join(app.instance_path, 'flaskr.sqlite'),
    # )

    app.config.from_mapping(
        SECRET_KEY='dev',
        MATCHING_SCORE_THRESHOLD= 0.75,
        MATCHING_PEAK_THRESHOLD=1,
        PRECURSOR_MASS_TOLERANCE="-1 to +1" 
    )

    if test_config is None:
        # load the instance config, if it exists, when not testing
        app.config.from_pyfile('config.py', silent=True)
    else:
        # load the test config if passed in
        app.config.from_mapping(test_config)

    
    #from metabolomics import selectfile 
    with app.app_context():
        from metabolomics.components import db
        from metabolomics import ms1import 
        from metabolomics import ms2import 
        #from metabolomics import selectms1
        from metabolomics import selectms2
        from metabolomics import displayms1
        from metabolomics import displayms2
        from metabolomics import dashboard_data
        #from metabolomics.components import compare_compounds
        from metabolomics import unknown_import
        from metabolomics import displayunknown
        from metabolomics import display_detection_results
        from metabolomics import my_exceptions
        from metabolomics.auth import auth_user
        from metabolomics import userconfig
        from metabolomics import exportdata
        from metabolomics import isaimport
        from metabolomics import displayisadata


        

    # ensure the instance folder exists
    try:
        os.makedirs(app.instance_path)
    except OSError:
        pass

    # a simple page that says hello
    @app_bp.route('/')
    def home():
        return render_template("home.html")

    app.register_blueprint(app_bp,url_prefix="/v1")
    return app