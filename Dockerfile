FROM quay.io/jupyter/minimal-notebook:latest

USER root

ENV BOOTSTRAP_HASKELL_NONINTERACTIVE=1
ENV BOOTSTRAP_HASKELL_GHC_VERSION=9.6.7
ENV BOOTSTRAP_HASKELL_CABAL_VERSION=3.12.1.0
ENV BOOTSTRAP_HASKELL_STACK_VERSION=3.7.1
ENV BOOTSTRAP_HASKELL_INSTALL_HLS=1
ENV BOOTSTRAP_HASKELL_HLS_VERSION=2.12.0.0
ENV BOOTSTRAP_HASKELL_ADJUST_BASHRC=1

RUN apt-get update && \
    apt-get install -yq --no-install-recommends \
        build-essential curl libffi-dev libffi8ubuntu1 libgmp-dev libgmp10 libncurses-dev \
        git libtinfo-dev libzmq3-dev libcairo2-dev libpango1.0-dev libmagic-dev libblas-dev liblapack-dev && \
    rm -rf /var/lib/apt/lists/*

USER ${NB_USER} 
RUN conda install -c conda-forge jupytext

RUN curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
ENV PATH="/home/jovyan/.ghcup/bin:/home/jovyan/.cabal/bin:$PATH"

RUN cabal install ihaskell && \
    ihaskell install --ghclib=$(ghc --print-libdir) --prefix=$HOME/.local/ && \
    mkdir -p /home/jovyan/.stack/global-project/ && \
    printf "resolver: lts-22.44\npackages: []\n" > /home/jovyan/.stack/global-project/stack.yaml
