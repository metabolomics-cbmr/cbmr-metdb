import os 
from flask import Flask, request, flash, request,redirect, url_for, current_app, render_template, jsonify
from flask_restful import Api
import psycopg2
from werkzeug.utils import secure_filename
from metabolomics.components.compare_compounds import *
#from metabolomics.displayunknown  import displayunknow2
from metabolomics.appbp import app_bp
from metabolomics.components.utilityfns import *
from metabolomics.my_exceptions import InputError, CustomException


@app_bp.route("/selectums2")
def selectums2():
    return render_template("uploadums2.html")


@app_bp.route("/upload_ums2/<from_client>", methods=['POST'])
def upload_ums2(from_client):
    #if request.method == 'POST':
    allowed_extensions = ["mgf"]

    try:
        upload_folder = os.path.normpath(os.path.join(os.getcwd(),"metabolomics/uploads")) 

        current_app.logger.info('in POST ')
        current_app.logger.info(' %sin POST ', request)

        # check if the post request has the file part
        #if 'file' not in request.files:
        if not is_file_uploaded(request):
            raise CustomException("No file part found")

        current_app.logger.info('file in  request ')

        #file = request.files['file']
        file = get_uploaded_file(request)

        # If the user does not select a file, the browser submits an
        # empty file without a filename.
        if file.filename == '':
            raise InputError("No file seelcted for upload")

        else:
            if not allowed_file(file.filename, allowed_extensions):
                raise InputError("Allowed file extensions for MS2 import are %s", allowed_extensions)


        current_app.logger.info('%s in POST ', file.filename )
        # current_app.logger.info('%s in POST ', request.form )
        # current_app.logger.info( ' matching peaks %s in POST data', request.form["matching_peaks"] )
        # current_app.logger.info(' score thresjold %s in POST data', request.form["matching_score"] )
        # current_app.logger.info(' pepmass tolerance from %s in POST data', request.form["pepmass_tolerance_from"] )        
        # current_app.logger.info(' pepmass tolerance to %s in POST data', request.form["pepmass_tolerance_to"] )        

        #form_data = request.form 
        #if file and allowed_file(file.filename):
        filename = secure_filename(file.filename)
        current_app.logger.info('%s secure  ',  filename )

        filepath = os.path.join(upload_folder, filename) 

        file.save(filepath)

        current_app.logger.info('after save ')
        form_data = request.form
        
        compareid = form_data["config"]
        method_id = form_data["method"]
        #current_app.logger.info('%s compareid  ',  form_data )


        #data = process_unknown_compound(filepath)  #from compare_comound
        ms2mst_id = process_unknown_compound(filepath, compareid, method_id)  #from compare_comound
        
        if from_client == 'flask':
            return redirect(url_for('app_bp.display_results', id=ms2mst_id, client=from_client))
        
        output = {}
        output["resultid"] = ms2mst_id 
        output["description"] = "Comparison over"
        return jsonify(output), 200


    ################
    except InputError as err:
        if from_client == "flask":
            raise err

        e_dict = err.get_error_dict()
        return jsonify(e_dict), 400
        
    except CustomException as err :
        if from_client == "flask":
            raise err
        return jsonify(err.get_error_dict()), 500

    except Exception as err:
        e_dict = get_unhandled_exception_details()
        return jsonify(e_dict),500

    

        
    
    
