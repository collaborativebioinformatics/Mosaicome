# ubuntu base image [pre-built debian-base python env]
FROM ubuntu:22.04

# reduce package overhead
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    CONDA_DIR=/opt/conda \
    PIP_NO_CACHE_DIR=1

# install dependencies
RUN apt-get update &&  apt-get install -y --no-install-recommends build-essential \
        python3 \
        python3-dev \
        python3-pip \
        wget \
        sudo \
        git \
        minimap2 \
        gfortran \
        bzip2 \
        ca-certificates \
        zlib1g-dev && \
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# workspace
RUN mkdir -p ~/analysis

WORKDIR ~/analysis

# (always specify exact version for python packages)
# COPY requirements.txt ./

# Download and install Miniforge
RUN wget "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh" -O /tmp/miniforge.sh \
    && bash /tmp/miniforge.sh -b -p $CONDA_DIR \
    && rm /tmp/miniforge.sh \
    && $CONDA_DIR/bin/conda clean --all --yes

# Initialize conda for bash (so activation works)
RUN echo ". $CONDA_DIR/etc/profile.d/conda.sh" >> /etc/bash.bashrc

# python pkgs
#RUN python3 -m venv 0env && source 0env/bin/activate && \
RUN conda create --name mosaicome bioconda::winnowmap bioconda::sniffles bioconda::samtools bioconda::bcftools bioconda::truvari bioconda::minimap2

SHELL ["/bin/bash", "--login", "-c"]
# python shell
CMD ["/bin/bash"]
