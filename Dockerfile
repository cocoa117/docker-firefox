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
  apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y \
    fonts-noto-core \
    fonts-noto-cjk \
    fonts-noto-cjk-extra \
    language-pack-zh* \
    && \
  curl -L -o - -q https://packages.mozilla.org/apt/repo-signing-key.gpg | tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null && \
  echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null && \
  echo 'Package: *' > /etc/apt/preferences.d/mozilla && \
  echo 'Pin: origin packages.mozilla.org' >> /etc/apt/preferences.d/mozilla && \
  echo 'Pin-Priority: 1000' >> /etc/apt/preferences.d/mozilla && \
  apt-get update && \
  apt-get install -y \
    firefox \
    python3-xdg \
    && \
  curl -L -o /tmp/net.downloadhelper.coapp.deb https://github.com/aclap-dev/vdhcoapp/releases/latest/download/vdhcoapp-linux-x86_64.deb && \
  dpkg -i /tmp/net.downloadhelper.coapp.deb && \
  sed -i 's|</applications>|  <application title="Mozilla Firefox" type="normal">\n    <maximized>yes</maximized>\n  </application>\n</applications>|' /etc/xdg/openbox/rc.xml && \
  echo "**** default firefox settings ****" && \
  # FIREFOX_SETTING="/usr/lib/firefox/browser/defaults/preferences/firefox.js" && \
  # echo 'pref("datareporting.policy.firstRunURL", "");' > ${FIREFOX_SETTING} && \
  # echo 'pref("datareporting.policy.dataSubmissionEnabled", false);' >> ${FIREFOX_SETTING} && \
  # echo 'pref("datareporting.healthreport.service.enabled", false);' >> ${FIREFOX_SETTING} && \
  # echo 'pref("datareporting.healthreport.uploadEnabled", false);' >> ${FIREFOX_SETTING} && \
  # echo 'pref("trailhead.firstrun.branches", "nofirstrun-empty");' >> ${FIREFOX_SETTING} && \
  # echo 'pref("browser.aboutwelcome.enabled", false);' >> ${FIREFOX_SETTING} && \
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
