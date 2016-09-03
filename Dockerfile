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
    ninja-build && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Working directory
ENV build_path=$PWD/build

# Install miniconda
RUN mkdir -p $build_path && \
    wget https://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh \
    -O $build_path/install_miniconda.sh && \
    bash $build_path/install_miniconda.sh -b -p $build_path/miniconda && \
    rm $build_path/install_miniconda.sh && \
    chmod -R +r $build_path && \
    chmod +x $build_path/miniconda/bin/python
ENV PATH=$build_path/miniconda/bin:${PATH}

# Install CMake
ENV CMAKE_ARCHIVE_SHA256 fdda4a8324e23c705ef0c2c45ba934ff3bd43798fb5631eec2d453693dbe777c
ENV CMAKE_VERSION_MAJOR 3
ENV CMAKE_VERSION_MINOR 6
ENV CMAKE_VERSION_PATCH 1
ENV CMAKE_VERSION ${CMAKE_VERSION_MAJOR}.${CMAKE_VERSION_MINOR}.${CMAKE_VERSION_PATCH}
RUN cd $build_path && \
  wget https://cmake.org/files/v${CMAKE_VERSION_MAJOR}.${CMAKE_VERSION_MINOR}/cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz && \
  hash=$(sha256sum ./cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz | awk '{ print $1 }') && \
  [ $hash = "${CMAKE_ARCHIVE_SHA256}" ] && \
  tar -xzvf cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz && \
  rm cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz
ENV PATH=$build_path/cmake-${CMAKE_VERSION}-Linux-x86_64/bin:${PATH}

# Download/configure/build/install ITK for SlicerExecutionModel (needed only for C++ CLIs)
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

# Download/configure/build SlicerExecutionModel (needed only for C++ CLIs)
ENV SEM_GIT_TAG 7525fc777a064529aff55e41aef6d91a85074553
RUN cd $build_path && \
    git clone git://github.com/Slicer/SlicerExecutionModel.git && \
    cd SlicerExecutionModel && git reset --hard ${SEM_GIT_TAG} && cd ../ && \
    mkdir SEM-build && cd SEM-build && \
    cmake \
        -G Ninja \
        -DCMAKE_BUILD_TYPE:STRING=Release \
        -DBUILD_TESTING:BOOL=OFF \
        ../SlicerExecutionModel && \
    ninja

# Install ctk-cli
RUN conda install --yes -c cdeepakroy ctk-cli=1.3.1

# Download/install slicer_cli_web
RUN cd $build_path && \
    git clone git://github.com/girder/slicer_cli_web.git && cd slicer_cli_web \
    pip install -U -r requirements.txt setuptools==19.4

# Copy 'Applications' from build context into the container
ENV APPLICATIONS_DIR $build_path/Applications
COPY Applications ${APPLICATIONS_DIR}

# Install python CLI requirements
RUN cd ${APPLICATIONS_DIR} && \
  find . -name requirements\*.txt -print -exec pip install -U -r {} \;

# Build C++ CLIs
RUN mkdir ${APPLICATIONS_DIR}-build && \
    cd ${APPLICATIONS_DIR}-build && \
    echo "${PATH}" && \
    which cmake && \
    cmake \
        -G Ninja \
        -DCMAKE_BUILD_TYPE:STRING=Release \
        -DSlicerExecutionModel_DIR:PATH=$build_path/SEM-build \
        ${APPLICATIONS_DIR} && \
    ninja && \
    cd .. && \
    rm -rf ${APPLICATIONS_DIR}-build

# use entrypoint of slicer_cli_web to expose slicer CLIS of this plugin on web
WORKDIR $APPLICATIONS_DIR
ENTRYPOINT ["/build/miniconda/bin/python" ,"/build/slicer_cli_web/server/cli_list_entrypoint.py"]

