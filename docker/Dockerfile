FROM ubuntu:focal

RUN if [ ! -f "/etc/localtime" ] ; then ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime; fi
RUN apt-get update
RUN apt-get install -q -y --no-install-recommends tzdata
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

CMD ["bash"]

RUN apt-get update
RUN apt-get install -q -y --no-install-recommends make ruby ghostscript
RUN gem install activesupport # NOTE: may not need all of active support..
RUN apt-get install -q -y --no-install-recommends texlive-latex-base texlive-latex-extra texlive-plain-generic
RUN apt-get install -q -y --no-install-recommends texlive-fonts-extra texlive-fonts-recommended cm-super
RUN apt-get install -q -y --no-install-recommends texlive-lang-english texlive-lang-french texlive-lang-spanish
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

RUN mkdir -p /venv/workspace
WORKDIR /venv/workspace
