FROM ubuntu:14.04
MAINTAINER Deepak Roy Chittajallu <deepk.chittajallu@kitware.com>

# Install system pre-requisites
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    wget \
    git \
    make cmake cmake-curses-gui &&\
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install miniconda
ENV build_path=$PWD/build
RUN mkdir -p $build_path && \
    wget https://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh \
    -O $build_path/install_miniconda.sh && \
    bash $build_path/install_miniconda.sh -b -p $build_path/miniconda && \
    rm $build_path/install_miniconda.sh && \
    chmod -R +r $build_path && \
    chmod +x $build_path/miniconda/bin/python
ENV PATH=$build_path/miniconda/bin:${PATH}

# install ctk-cli
conda install --yes -c cdeepakroy ctk-cli=1.3.1

# git clone install slicer_cli_web
RUN git clone git@github.com:girder/slicer_cli_web.git && cd slicer_cli_web \
    pip install -U -r requirements.txt setuptools==19.4

# Copy files of my plugin
ENV my_plugin_path=$PWD/my_plugin
RUN mkdir -p $my_plugin_path
COPY . $my_plugin_path
RUN cd $my_plugin_path && \
    pip install -r requirements.txt

# use entrypoint of slicer_cli_web to expose slicer CLIS of this plugin on web
WORKDIR $my_plugin_path/Applications
ENTRYPOINT ["/build/miniconda/bin/python" ,"/slicer_cli_web/server/cli_list_entrypoint.py"]