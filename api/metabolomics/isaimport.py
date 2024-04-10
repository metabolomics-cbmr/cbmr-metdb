import os 
import glob 
from flask import Flask, request, flash, request, redirect, url_for, current_app, render_template  , jsonify
from flask_restful import Api
import psycopg2
from werkzeug.utils import secure_filename
from metabolomics.components.saveisa import *
#from metabolomics.displayisa import displayisa
from metabolomics.appbp import app_bp
from metabolomics.components.utilityfns import *
from metabolomics.my_exceptions import InputError, CustomException 
import pandas as pd
from pathlib import Path

@app_bp.route("/selectisa")
def selectisa():
   return render_template("uploadisa.html")


@app_bp.route("/isafiles/<from_client>", methods=['POST'])
def uploadisa(from_client):
    #if request.method == 'POST':


    allowed_extensions = ["xlsx"]

    try:
        upload_folder = os.path.normpath(os.path.join(os.getcwd(),"metabolomics/uploads")) 

        #convert into ISATAB files



        #current_app.logger.info('in POST ')
        #current_app.logger.info(' %sin POST ', request)

        # check if the post request has the file part
        if not is_file_uploaded(request):
            raise CustomException("No file part found to upload")


        #file = request.files['file']
        files = get_uploaded_files(request)

        #create random folder 
        folder_name = get_unique_id()
        #create folder in uploads folder 

        inv_files_path =  os.path.join(upload_folder, folder_name)  #    f"{upload_folder}/{folder_name}"
        os.mkdir(inv_files_path)

        os.mkdir(os.path.join(inv_files_path, "tabfiles"))
        os.mkdir(os.path.join(inv_files_path, "datatable"))

        #save uploaded file to hard disk
        for file in files: 
            if not allowed_file(file.filename, allowed_extensions):
                raise InputError("Allowed file extensions for ISa Data import are '" + ','.join(allowed_extensions) + '\'')

            filename = get_secure_file_name(file.filename)

            if filename.startswith("i_") or filename.startswith("s_") or filename.startswith("a_"):
                filepath = os.path.join(inv_files_path, "tabfiles", filename) 
            else:
                filepath = os.path.join(inv_files_path, "datatable", filename) 

            file.save(filepath) 
        

        isa_id = file_import(upload_folder, folder_name)  # master id regturned from savems1

        #print(f" Investigation Id = {isa_id}")

        #return redirect(url_for('app_bp.displayisadata', id=isa_id, client=from_client))
        return redirect(url_for('app_bp.displayisadata',  client=from_client))

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
    
    

