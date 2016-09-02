FROM ubuntu:16.04
MAINTAINER Deepak Roy Chittajallu <deepk.chittajallu@kitware.com>

# Install system pre-requisites
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    wget \
    git \
    emacs vim \
    make cmake cmake-curses-gui \
    ninja-build \
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

# git clone install ITK for SlicerExecutionModel (needed only for C++ CLIs)
ENV ITK_GIT_TAG v4.10.0
RUN cd $build_path && git clone --depth 1 -b ${ITK_GIT_TAG} git://itk.org/ITK.git && \
    mkdir ITK-build && \
    cd ITK-build && \
    cmake \
        -G Ninja \
        -DCMAKE_INSTALL_PREFIX:PATH=/usr \
        -DBUILD_EXAMPLES:BOOL=OFF \
        -DBUILD_TESTING:BOOL=OFF \
        -DBUILD_SHARED_LIBS:BOOL=ON \
        -DCMAKE_POSITION_INDEPENDENT_CODE:BOOL=ON \
        -DITK_LEGACY_REMOVE:BOOL=ON \
        -DITK_BUILD_DEFAULT_MODULES:BOOL=OFF \
        -DITK_USE_SYSTEM_LIBRARIES:BOOL=OFF \
        -DModule_ITKCommon:BOOL=ON \
        -DModule_ITKIOXML:BOOL=ON \
        -DModule_ITKExpat:BOOL=ON \
        ../ITK && \
    ninja install && \
    rm -rf ITK ITK-build

# git clone install SlicerExecutionModel (needed only for C++ CLIs)
ENV SEM_GIT_TAG 7525fc777a064529aff55e41aef6d91a85074553
RUN cd $build_path && \
    git clone git@github.com:Slicer/SlicerExecutionModel.git && \
    cd SlicerExecutionModel && git reset --hard ${SEM_GIT_TAG} && cd ../ && \
    mkdir SEM-build && cd SEM-build && \
    cmake \
        -G Ninja \
        -DCMAKE_BUILD_TYPE:STRING=Release \
        -DBUILD_TESTING:BOOL=OFF \
        ../SlicerExecutionModel && \
    ninja

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

# build c++ CLIs and executable directory to PATH
RUN cd Applications && \
    mkdir build && \


# use entrypoint of slicer_cli_web to expose slicer CLIS of this plugin on web
WORKDIR $my_plugin_path/Applications
ENTRYPOINT ["/build/miniconda/bin/python" ,"/slicer_cli_web/server/cli_list_entrypoint.py"]