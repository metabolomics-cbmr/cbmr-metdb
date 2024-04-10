# set base image (host OS)
FROM python:3.7

RUN pip install --upgrade pip
# set the working directory in the container
WORKDIR /Bio-Dev

# copy the dependencies file to the working directory
COPY requirements.txt .


RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

#RUN pip3 install setuptools_rust
#RUN sudo apt-get install libxrender1

# install dependencies
RUN pip install -r requirements.txt

# copy the content of the local src directory to the working directory
COPY metabolomics/ ./metabolomics

COPY wsgi.py ./

# ISA API
COPY isaapi/ ./isaapi

WORKDIR /Bio-Dev/isaapi

RUN pip install -r requirements.txt

WORKDIR /Bio-Dev

EXPOSE 5000

#CMD python /Bio-Dev/isaapi/create_isa_tables.py && gunicorn -w 8 --bind 0.0.0.0:5000  --timeout 600 wsgi:app
CMD   gunicorn -w 8 --bind 0.0.0.0:5000  --timeout 600 wsgi:app