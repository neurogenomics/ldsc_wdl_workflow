FROM continuumio/anaconda3:2019.03
MAINTAINER "ll2319@ic.ac.uk"

RUN cd / && \
    git clone https://github.com/bulik/ldsc.git && \
    cd ldsc && \
    conda env create --file environment.yml

RUN echo "source activate ldsc" > ~/.bashrc

