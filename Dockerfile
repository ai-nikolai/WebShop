FROM continuumio/miniconda3:latest

WORKDIR /app

# Copy project files
COPY docker_setup.sh requirements_arm.txt /app 
COPY web_agent_site /app/web_agent_site
COPY search_engine/convert_product_file_format.py /app/search_engine/
COPY search_engine/lucene_searcher.py /app/search_engine/
COPY search_engine/run_indexing.sh /app/search_engine/

# # Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# # creating conda env
RUN conda create -n webshop python=3.8.13
RUN . /opt/conda/etc/profile.d/conda.sh && \
    conda activate webshop && \
    conda install -c pytorch faiss-cpu && \
    conda install -c conda-forge openjdk=11 && \
    conda install spacy

# # Install Python dependencies
RUN . /opt/conda/etc/profile.d/conda.sh && \
    conda activate webshop && \
    pip install -r requirements_arm.txt

# # Download spaCy model
RUN . /opt/conda/etc/profile.d/conda.sh && \
    conda activate webshop && \
    python -m spacy download en_core_web_lg

# # Run setup script to download and prepare data
RUN chmod +x docker_setup.sh && \
    ./docker_setup.sh

# # Set up the default command
COPY run_prod_docker.sh /app 
EXPOSE 3000

# Actual command to run the server
CMD ["./run_prod_docker.sh"]