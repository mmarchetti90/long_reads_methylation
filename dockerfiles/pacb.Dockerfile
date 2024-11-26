FROM continuumio/miniconda3:latest

### SOFTWARE VERSIONS ---------------------- ###

ARG METHBAT=0.13.2
ARG PBCCS=6.4.0
ARG PBJASMINE=2.0.0
ARG PBMM2=1.14.99
ARG PB_CPG_TOOLS=v2.3.2

### UPDATING CONDA ------------------------- ###

RUN conda update -y conda

### INSTALLING PIPELINE PACKAGES ----------- ###

# Adding bioconda to the list of channels
RUN conda config --add channels bioconda

# Adding conda-forge to the list of channels
RUN conda config --add channels conda-forge

# Installing mamba
RUN conda install -y mamba

# Installing software
RUN mamba install -y \
    methbat=${METHBAT} \
    numpy \
    pandas \
    pbccs=${PBCCS} \
    pbjasmine=${PBJASMINE} \
    pbmm2=${PBMM2} && \
    conda clean -afty

# Downloading pb-CpG-tools binaries
RUN cd /tmp && \
    wget --no-check-certificate  https://github.com/PacificBiosciences/pb-CpG-tools/releases/download/${PB_CPG_TOOLS}/pb-CpG-tools-${PB_CPG_TOOLS}-x86_64-unknown-linux-gnu.tar.gz && \
    tar -xzf pb-CpG-tools-${PB_CPG_TOOLS}-x86_64-unknown-linux-gnu.tar.gz -C /opt && \
    rm /tmp/pb-CpG-tools-${PB_CPG_TOOLS}-x86_64-unknown-linux-gnu.tar.gz

# Adding pb-CpG-tools to PATH
ENV PATH $PATH:/opt/pb-CpG-tools-${PB_CPG_TOOLS}-x86_64-unknown-linux-gnu/bin

### SETTING WORKING ENVIRONMENT ------------ ###

# Set workdir to /home/
WORKDIR /home/

# Launch bash automatically
CMD ["/bin/bash"]
