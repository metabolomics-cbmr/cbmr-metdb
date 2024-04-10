import os 
from flask import Flask, request, flash, request,redirect, url_for, current_app, render_template, jsonify
from flask_restful import Api
import psycopg2
from werkzeug.utils import secure_filename
from metabolomics.components.savemgf import *
from metabolomics.displayms2 import displayms2list
from metabolomics.appbp import app_bp
from metabolomics.components.utilityfns import *
from metabolomics.my_exceptions import InputError, CustomException


@app_bp.route("/selectms2")
def selectms2():
    return render_template("uploadms2.html")



@app_bp.route("/upload_ms2/<from_client>", methods=['POST'])
def upload_ms2(from_client):
    #if request.method == 'POST':
    allowed_extensions = ["mgf"]
    try:
        upload_folder = os.path.normpath(os.path.join(os.getcwd(),"metabolomics/uploads")) 

        current_app.logger.info('in POST ')
        current_app.logger.info(' %sin POST ', request)

        # check if the post request has the file part
        #if 'file' not in request.files:
        if not is_file_uploaded(request):
            raise CustomException("No file part found to upload")

        current_app.logger.info('file in  request ')

        #file = request.files['file']
        file = get_uploaded_file(request)

        # If the user does not select a file, the browser submits an
        # empty file without a filename.
        if file.filename == '':
            raise InputError("No file selected for upload")
        else:
            if not allowed_file(file.filename, allowed_extensions):
                raise InputError("Allowed file extensions for MS2 import are '" + ','.join(allowed_extensions) + '\'')

        current_app.logger.info('%s in POST ', file.filename )

        compound_name = ""

        # if file name does not contain collision ebnergy suffix, use file name as compound name 
        if file.filename.find("_") == -1:
            compound_name =  file.filename    
        else:
            #extract compound_nme from file name 
            compound_name =  file.filename[0:file.filename.find("_")]


        #if file and allowed_file(file.filename):
        filename = secure_filename(file.filename)
        current_app.logger.info('%s secure  ',  filename )

        filepath = os.path.join(upload_folder, filename) 

        file.save(filepath)

        current_app.logger.info('after save ')

        id = import_known_compound_ms2(filepath, compound_name)  # from savemgf



        return redirect(url_for('app_bp.displayms2list', mstid=id, client=from_client))

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
        if from_client == "flask":
            raise err

        e_dict = get_unhandled_exception_details()
        return jsonify(e_dict),500



        # read the mgf file and save in database         
    
    #return redirect(url_for('app_bp.selectms2'))

    
    
# @app_bp.route("/upload_ms2_data", methods=['POST'])
# def upload_ms2_data():

#     allowed_extensions = ["mgf"]
#     upload_folder = os.path.normpath(os.path.join(os.getcwd(),"metabolomics/uploads")) 

#     current_app.logger.info('in POST ')
#     current_app.logger.info(' %sin POST ', request)

#     # check if the post request has the file part
#     #if 'file' not in request.files:
#     if not is_file_uploaded(request):
#         current_app.logger.info('in no file  ')
#         flash('No file part')
#         return redirect(request.url)

#     current_app.logger.info('file in  request ')

#     #file = request.files['file']
#     file = get_uploaded_file(request)

#     # If the user does not select a file, the browser submits an
#     # empty file without a filename.
#     if file.filename == '':
#         flash('No selected file')
#         return redirect(request.url)
#     else:
#         if not allowed_file(file.filename, allowed_extensions):
#             raise Exception("Allowed file extensions for MS2 import are %s", allowed_extensions)

#     current_app.logger.info('%s in POST ', file.filename )

#     compound_name = ""

#     # if file name does not contain collision ebnergy suffix, use file name as compound name 
#     if file.filename.find("_") == -1:
#         compound_name =  file.filename    
#     else:
#         #extract compound_nme from file name 
#         compound_name =  file.filename[0:file.filename.find("_")]


#     #if file and allowed_file(file.filename):
#     filename = secure_filename(file.filename)
#     current_app.logger.info('%s secure  ',  filename )

#     filepath = os.path.join(upload_folder, filename) 

#     file.save(filepath)

#     current_app.logger.info('after save ')

#     id = import_known_compound_ms2(filepath, compound_name)  # from savemgf

#     return redirect(url_for('app_bp.displayms2', scanid=id, client='external'))

        
    
    
