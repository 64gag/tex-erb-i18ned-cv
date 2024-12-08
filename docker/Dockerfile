FROM ubuntu:focal

RUN if [ ! -f "/etc/localtime" ] ; then ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime; fi

RUN apt-get update && apt-get install -y --no-install-recommends \
  tzdata \
  && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y --no-install-recommends \
  make ruby ghostscript \
  texlive-latex-base texlive-latex-extra texlive-plain-generic \
  texlive-fonts-extra texlive-fonts-recommended cm-super \
  texlive-lang-english texlive-lang-french texlive-lang-spanish \
  && rm -rf /var/lib/apt/lists/*

RUN gem install activesupport -v 7.0.0

CMD ["bash"]

RUN mkdir -p /venv
WORKDIR /venv
