FROM ghcr.io/linuxserver/baseimage-kasmvnc:ubuntujammy

# set version label
ARG BUILD_DATE
ARG VERSION
ARG FIREFOX_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="me"

# title
ENV TITLE=Firefox-Ubuntu

RUN \
  echo "**** install packages ****" && \
  apt update && \
  apt upgrade -y && \
  apt install -y \
    fonts-noto-core \
    fonts-noto-cjk \
    fonts-noto-cjk-extra \
    language-pack-zh* \
    && \
  add-apt-repository -y ppa:mozillateam/ppa && \
  apt update && \
  echo 'Package: *' > /etc/apt/preferences.d/mozilla-firefox && \
  echo 'Pin: release o=LP-PPA-mozillateam' >> /etc/apt/preferences.d/mozilla-firefox && \
  echo 'Pin-Priority: 1001' >> /etc/apt/preferences.d/mozilla-firefox && \
  apt install -y \
    firefox \
    python3-xdg \
    && \
  # curl -L -o /tmp/net.downloadhelper.coapp-1.6.3-1_amd64.deb https://github.com/mi-g/vdhcoapp/releases/download/v1.6.3/net.downloadhelper.coapp-1.6.3-1_amd64.deb && \
  curl -L -o /tmp/net.downloadhelper.coapp.deb https://github.com/aclap-dev/vdhcoapp/releases/latest/download/vdhcoapp-linux-x86_64.deb && \
  dpkg -i /tmp/net.downloadhelper.coapp.deb && \
  sed -i 's|</applications>|  <application title="Mozilla Firefox" type="normal">\n    <maximized>yes</maximized>\n  </application>\n</applications>|' /etc/xdg/openbox/rc.xml && \
  echo "**** default firefox settings ****" && \
  FIREFOX_SETTING="/usr/lib/firefox/browser/defaults/preferences/firefox.js" && \
  echo 'pref("datareporting.policy.firstRunURL", "");' > ${FIREFOX_SETTING} && \
  echo 'pref("datareporting.policy.dataSubmissionEnabled", false);' >> ${FIREFOX_SETTING} && \
  echo 'pref("datareporting.healthreport.service.enabled", false);' >> ${FIREFOX_SETTING} && \
  echo 'pref("datareporting.healthreport.uploadEnabled", false);' >> ${FIREFOX_SETTING} && \
  echo 'pref("trailhead.firstrun.branches", "nofirstrun-empty");' >> ${FIREFOX_SETTING} && \
  echo 'pref("browser.aboutwelcome.enabled", false);' >> ${FIREFOX_SETTING} && \
  echo "**** cleanup ****" && \
  rm -rf \
    /tmp/* \
    && \
  apt-get autoremove -y && \
  apt-get clean

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000

VOLUME /config
