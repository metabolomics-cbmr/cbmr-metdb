# set base image (host OS)
FROM python:3.7

# set the working directory in the container
WORKDIR /Bio-Dev

# copy the dependencies file to the working directory
COPY requirements.txt .

# install dependencies
RUN pip install -r requirements.txt

# copy the content of the local src directory to the working directory
COPY metabolomics/ ./metabolomics
COPY wsgi.py ./

EXPOSE 5000

CMD gunicorn -w 8 --bind 0.0.0.0:5000  --timeout 300 wsgi:app
