import os 
from flask import Flask, request, flash, request, redirect, url_for, current_app, render_template  , jsonify
from flask_restful import Api
import psycopg2
from werkzeug.utils import secure_filename
from metabolomics.components.savems1 import *
from metabolomics.displayms1 import displayms1
from metabolomics.appbp import app_bp
from metabolomics.components.utilityfns import *
from metabolomics.my_exceptions import InputError, CustomException 


@app_bp.route("/selectms1")
def selectms1():
   return render_template("uploadms1.html")


@app_bp.route("/upload_ms1/<from_client>", methods=['POST'])
def uploadms1(from_client):
    #if request.method == 'POST':


    allowed_extensions = ["xlsx"]

    try:
        upload_folder = os.path.normpath(os.path.join(os.getcwd(),"metabolomics/uploads")) 

        #current_app.logger.info('in POST ')
        #current_app.logger.info(' %sin POST ', request)

        # check if the post request has the file part
        if not is_file_uploaded(request):
            raise CustomException("No file part found to upload")
        #current_app.logger.info('file in  request ')

        #file = request.files['file']
        file = get_uploaded_file(request)

        # If the user does not select a file, the browser submits an
        # empty file without a filename.
        if file.filename == '':
            raise InputError("No file selected for upload")
        else:
            if not allowed_file(file.filename, allowed_extensions):
                raise InputError("Allowed file extensions for MS1 import are '" + ','.join(allowed_extensions) + '\'')
        
        current_app.logger.info('%s in POST ', file.filename )

        #if file and allowed_file(file.filename):
        filename = get_secure_file_name(file.filename)
        current_app.logger.info('%s secure  ',  filename )

        filepath = os.path.join(upload_folder, filename) 

        file.save(filepath)

        current_app.logger.info('after save ')

        ms1_mst_id = file_import(filepath)  # master id regturned from savems1

        return redirect(url_for('app_bp.displayms1', id=ms1_mst_id, client=from_client))
    
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


    
    #return redirect(url_for('app_bp.selectms1'))

    # return '''
    # <!doctype html>
    # <title>Upload new File</title>
    # <h1>Upload new File</h1>
    # <form method="post" enctype="multipart/form-data">
    #   <input type=file name=file>
    #   <input type=submit value=Upload>
    # </form>
    # '''
    

        
    
# @app_bp.route("/upload_ms1_data", methods=['POST'])
# def uploadms1_data():

#     allowed_extensions = ["xlsx"]

#     upload_folder = os.path.normpath(os.path.join(os.getcwd(),"metabolomics/uploads")) 

#     #current_app.logger.info('in POST ')
#     #current_app.logger.info(' %sin POST ', request)

#     # check if the post request has the file part
#     if not is_file_uploaded(request):
#         current_app.logger.info('in no file  ')
#         flash('No file part')
#         return redirect(request.url)

#     #current_app.logger.info('file in  request ')

#     #file = request.files['file']
#     file = get_uploaded_file(request)

#     # If the user does not select a file, the browser submits an
#     # empty file without a filename.
#     if file.filename == '':
#         flash('No selected file')
#         return redirect(request.url)
#     else:
#         if not allowed_file(file.filename, allowed_extensions):
#             raise Exception("Allowed file extensions for MS1 import are %s", allowed_extensions)
    
#     current_app.logger.info('%s in POST ', file.filename )

#     #if file and allowed_file(file.filename):
#     filename = get_secure_file_name(file.filename)
#     current_app.logger.info('%s secure  ',  filename )

#     filepath = os.path.join(upload_folder, filename) 

#     file.save(filepath)

#     current_app.logger.info('after save ')

#     ms1_mst_id = file_import(filepath)  # master id regturned from savems1

#     return redirect(url_for('app_bp.displayms1', id=ms1_mst_id, client='external'))
    
    

