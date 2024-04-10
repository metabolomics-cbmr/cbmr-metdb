import traceback
import sys

class CustomException(Exception):
    def __init__(self, message):
        self.message = message

    def __str__(self):
        return self.message 

    def get_error_dict(self):
        err = {}
        err["code"] = ""
        err["description"] = self.message 
        exc_info = sys.exc_info()
        err["details"] = (''.join(traceback.format_exception(*exc_info)))        
        return err 

class InputError(CustomException):
    def __init__(self, message):
        self.message = message 
        super().__init__(self.message)

    def __str__(self):
        return self.message 

    def get_error_dict(self):
        return super().get_error_dict()
