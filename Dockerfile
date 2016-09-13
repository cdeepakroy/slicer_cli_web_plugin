FROM girder/slicer_cli_web
MAINTAINER Deepak Roy Chittajallu <deepk.chittajallu@kitware.com>

# Insert commands to install any system pre-requisites and libraries here

# Copy files of the plugin into the docker container
ENV slicer_cli_web_plugin_path $build_path/slicer_cli_web_plugin
COPY . $slicer_cli_web_plugin_path

# pip install requirments.txt (if present) of each python CLI
RUN cd ${slicer_cli_web_plugin_path}/Applications && \
  find . -name requirements\*.txt -print -exec pip install -U -r {} \;

# Build C++ CLIs (Skip if you don't have C++ CLIs)
RUN cd ${slicer_cli_web_plugin_path}/Applications && \
    mkdir -p build && cd build && \
    echo "${PATH}" && \
    which cmake && \
    cmake \
        -G Ninja \
        -DCMAKE_BUILD_TYPE:STRING=Release \
        -DSlicerExecutionModel_DIR:PATH=$build_path/SEM-build \
        ../ && \
    ninja && \
    cd .. && \
    rm -rf build

# use entrypoint of slicer_cli_web to expose slicer CLIS of this plugin on web
WORKDIR ${slicer_cli_web_plugin_path}/Applications
ENTRYPOINT ["/build/miniconda/bin/python", "/build/slicer_cli_web/server/cli_list_entrypoint.py"]

