# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.134.0/containers/cpp/.devcontainer/base.Dockerfile
ARG VARIANT="buster"
FROM mcr.microsoft.com/vscode/devcontainers/cpp:0-${VARIANT}

# Environmental variables
ARG REMOTE_USER="vscode"
ARG WORK_DIR="/work"
ARG EIGEN_VERSION=3.3.7
ARG VTKMESH_VERSION=v1.0.0
ARG TMP_WORK_DIR="/tmp_work"

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Configure apt and install packages
RUN apt-get update \
    && apt-get -y install ncftp libopenblas-dev liblapack-dev

# Clean up
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Install library
RUN mkdir ${TMP_WORK_DIR}

# Eigen
RUN cd ${TMP_WORK_DIR} \
    && git clone https://github.com/eigenteam/eigen-git-mirror.git \
    && cd ${TMP_WORK_DIR}/eigen-git-mirror \
    && git checkout ${EIGEN_VERSION} \
    && cd ${TMP_WORK_DIR} \
    && mv ${TMP_WORK_DIR}/eigen-git-mirror /opt/ \
    && ln -s /opt/eigen-git-mirror/Eigen/ /usr/local/include/Eigen \
    && ln -s /opt/eigen-git-mirror/unsupported/ /usr/local/include/unsupported

# vtkmesh
RUN cd ${TMP_WORK_DIR} \
    && git clone https://github.com/sKujirai/vtkmesh.git \
    && cd ${TMP_WORK_DIR}/vtkmesh \
    && git checkout ${VTKMESH_VERSION} \
    && mkdir /opt/vtkmesh \
    && mv ${TMP_WORK_DIR}/vtkmesh /opt/vtkmesh/

RUN rm -rf ${TMP_WORK_DIR}

# chown all files to remote user
RUN mkdir ${WORK_DIR} \
    && chown -R ${REMOTE_USER} ${WORK_DIR}
