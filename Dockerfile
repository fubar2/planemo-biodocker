# Base Image for planemo-biocontainer:0.72.0
FROM biocontainers/biocontainers:vdebian-buster-backports_cv1
# Metadata
LABEL base_image="biocontainers/biocontainers:vdebian-buster-backports_cv1"
LABEL version="0.72.0"
LABEL software="planemo"
LABEL software.version="20201112"
LABEL about.summary="Planemo galaxy tool test and development package. Includes bioblend, galaxyxml and ephemeris"
LABEL about.home="https://github.com/galaxyproject/planemo"
LABEL about.documentation="https://github.com/galaxyproject/planemo"
LABEL about.license="Academic Free License version 3.0"
LABEL about.license_file="/usr/share/common-licenses/GPL3"
LABEL about.tags="Galaxy Tool Development package"
LABEL extra.identifiers.biotools=planemo
# Maintainer
MAINTAINER Ross Lazarus <ross.lazarus@gmail.com>
ARG GALAXY_RELEASE=release_20.09
ARG GALAXY_REPO=https://github.com/galaxyproject/galaxy
ARG GALAXY_ROOT=/home/biodocker/galaxy-central
USER root
RUN apt-get update \
&& apt-get install -y python3 python3-venv python3-pip python3-wheel mercurial wget unzip nano curl nodeenv procps git \
&& mkdir -p /home/biodocker/.cache  /home/biodocker/toolfactory  \
&& chown -R root /home/biodocker/.cache \
&& python3 -m pip install --upgrade pip planemo==0.72.0 ephemeris==0.10.6 \
&& git clone --recursive https://github.com/fubar2/planemo.git /home/biodocker/planemo \
&& cd /home/biodocker/planemo && python3 setup.py build && python3 setup.py install \
&& planemo conda_init --conda_prefix /home/biodocker/planemo_conda --conda_channels bioconda,conda-forge \
&& cp /usr/local/bin/planemo /home/biodocker/bin/ \
&& hg clone https://fubar@toolshed.g2.bx.psu.edu/repos/fubar/tacrev  /home/biodocker/tacrev \
&& mv /home/biodocker/tacrev/tacrev/* /home/biodocker/tacrev/ \
&& mkdir -p "$GALAXY_ROOT" \
&& curl -L -s $GALAXY_REPO/archive/$GALAXY_RELEASE.tar.gz | tar xzf - --strip-components=1 -C $GALAXY_ROOT \
&& python3 -m venv /home/biodocker/galaxy-central/.venv  \
&& . /home/biodocker/galaxy-central/.venv/bin/activate && /home/biodocker/galaxy-central/.venv/bin/python3 -m pip install --upgrade pip wheel \
&& apt-get clean && apt-get purge \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
&& rm -rf /usr/bin/python && ln -s /usr/bin/python3 /usr/bin/python \
&& mkdir -p /home/biodocker/.cache \
&& mkdir -p /home/biodocker/.planemo \
&& set PLANEMO_GLOBAL_WORKSPACE=/home/biodocker/.planemo \
&& chown -R biodocker /home/biodocker \
&& chmod -R 755  /home/biodocker
ENV PATH /home/biodocker/bin:$PATH
ENV PLANEMO_GLOBAL_WORKSPACE=/home/biodocker/.planemo
USER biodocker
RUN . /home/biodocker/galaxy-central/.venv/bin/activate \
&& planemo test --galaxy_root /home/biodocker/galaxy-central /home/biodocker/tacrev/tacrev.xml
# this fills the various planemo caches so the image doesn't need to install every time it tests
WORKDIR /data/
