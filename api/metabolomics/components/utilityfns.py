from werkzeug.utils import secure_filename
import traceback
import sys
import uuid 

def allowed_file(filename, allowed_extensions):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in allowed_extensions


def get_uploaded_file(request):
    return request.files['file']

def get_uploaded_files(request):
    return request.files.getlist("file") 


def is_file_uploaded(request):
    # check if the post request has the file part
    if 'file' not in request.files:
        return False    

    return True 

def get_secure_file_name(filename):
    return secure_filename(filename)

def get_unhandled_exception_details():
    err = {}
    err["code"] = ""
    exc_info = sys.exc_info()
    err["description"] = (''.join(traceback.format_exception(*exc_info)))        
    err["details"] = err["description"]
    return err 


def get_unique_id():
    return str(uuid.uuid1())