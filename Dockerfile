FROM ubuntu:mantic-20231011
# FROM ubuntu:focal-20231003
# FROM debian:bookworm-20231030

ARG TARGETARCH=amd64
ARG TARGETOS=linux

ARG USER=coder

    # ca-certificates \
    # software-properties-common \
    # curl \
    # wget \
    # unzip \
    # iputils-ping \
    # sudo \
    # git \
    # vim \
    # jq \
    # ssh \
    # pwgen \
    # gettext-base \
    # bash-completion \
    # zip \
    # liquidprompt \
    # locales \

    # xfce4 \
    # dbus-x11

RUN set -e; \
  apt-get update && DEBIAN_FRONTEND="noninteractive" TZ="Europe/Berlin" apt-get install -y \
    ca-certificates \
    software-properties-common \
    curl \
    wget \
    unzip \
    iputils-ping \
    sudo \
    git \
    vim \
    jq \
    ssh \
    pwgen \
    gettext-base \
    bash-completion \
    zip \
    liquidprompt \
    locales \
    dbus-x11 \
    kde-plasma-desktop; \
  rm -rf /var/lib/apt/lists/*; \
  rm -f /run/reboot-required*


RUN set -e; \
  cd /tmp; \
  # wget -O kasmvncserver.deb https://github.com/kasmtech/KasmVNC/releases/download/v1.2.0/kasmvncserver_bionic_1.2.0_${TARGETARCH}.deb; \
  wget -O kasmvncserver.deb https://github.com/kasmtech/KasmVNC/releases/download/v1.2.0/kasmvncserver_bookworm_1.2.0_${TARGETARCH}.deb; \
  apt-get update && DEBIAN_FRONTEND="noninteractive" TZ="Europe/Berlin" apt-get install -y ./kasmvncserver.deb; \
  rm kasmvncserver.deb; \
  rm -rf /var/lib/apt/lists/*

# RUN locale-gen en_US.UTF-8 && \
#   update-locale LANG=en_US.UTF-8

# https://hub.docker.com/_/docker/tags
COPY --from=docker:24.0.6-cli /usr/local/bin/docker /usr/local/bin/docker-compose /usr/local/bin/
# https://hub.docker.com/r/docker/buildx-bin/tags
COPY --from=docker/buildx-bin:0.11.2 /buildx /usr/libexec/docker/cli-plugins/docker-buildx

RUN curl -s https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker -o /etc/bash_completion.d/docker.sh

# https://hub.docker.com/_/eclipse-temurin/tags
COPY --from=eclipse-temurin:21_35-jdk-ubi9-minimal /opt/java/openjdk /opt/java/openjdk

# https://github.com/kubernetes/kubernetes/releases
ARG KUBECTL_VERSION=1.27.4
RUN set -e; \
    cd /tmp; \
    curl -sLO "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/${TARGETOS}/${TARGETARCH}/kubectl"; \
    mv kubectl /usr/local/bin/; \
    chmod +x /usr/local/bin/kubectl

# https://github.com/helm/helm/releases
ARG HELM_VERSION=3.12.3
RUN set -e; \
  cd /tmp; \
  curl -Ss -o helm.tar.gz https://get.helm.sh/helm-v${HELM_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz; \
  tar xzf helm.tar.gz; \
  mv ${TARGETOS}-${TARGETARCH}/helm /usr/local/bin/; \
  chmod +x /usr/local/bin/helm; \
  rm -rf ${TARGETOS}-${TARGETARCH} helm.tar.gz

# # https://www.eclipse.org/downloads/packages/
# RUN set -e; \
#   cd /tmp; \
#   wget -O eclipse.tar.gz https://ftp.fau.de/eclipse/technology/epp/downloads/release/2023-09/R/eclipse-jee-2023-09-R-linux-gtk-x86_64.tar.gz; \
#   tar xzf eclipse.tar.gz; \
#   mv eclipse /opt/; \
#   rm eclipse.tar.gz

# Install Chrome
RUN set -e; \
  cd /tmp; \
  wget -O chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb; \
  apt-get update && DEBIAN_FRONTEND="noninteractive" TZ="Europe/Berlin" apt-get install -y ./chrome.deb; \
  rm chrome.deb && rm -rf /var/lib/apt/lists/*


# Install pgadmin
RUN set -e; \
  curl -fsS https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo gpg --dearmor -o /usr/share/keyrings/packages-pgadmin-org.gpg; \
  sh -c 'echo "deb [signed-by=/usr/share/keyrings/packages-pgadmin-org.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/lunar pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list'; \
  apt-get update && DEBIAN_FRONTEND="noninteractive" TZ="Europe/Berlin" apt-get install -y pgadmin4-desktop; \
  rm -rf /var/lib/apt/lists/*

# Install postman
RUN set -e; \
  cd /tmp; \
  wget -O postman.tar.gz https://dl.pstmn.io/download/latest/linux64; \
  tar xzf postman.tar.gz; \
  mv Postman /opt/; \
  rm postman.tar.gz

# # Install spring tool suite
# # https://spring.io/tools
# RUN set -e; \
#   cd /tmp; \
#   wget -O spring-tool-suite.tar.gz https://cdn.spring.io/spring-tools/release/STS4/4.20.1.RELEASE/dist/e4.29/spring-tool-suite-4-4.20.1.RELEASE-e4.29.0-linux.gtk.x86_64.tar.gz; \
#   tar xzf spring-tool-suite.tar.gz; \
#   mv sts-4.20.1.RELEASE /opt/sts; \
#   rm spring-tool-suite.tar.gz

# # Instell intellij
# # https://www.jetbrains.com/idea/download/#section=linux
# # https://download.jetbrains.com/idea/ideaIC-2023.2.5.tar.gz
# RUN set -e; \
#   cd /tmp; \
#   wget -O idea.tar.gz https://download.jetbrains.com/idea/ideaIU-2023.2.4.tar.gz; \
#   tar xzf idea.tar.gz; \
#   mv idea-* /opt/idea; \
#   rm idea.tar.gz

COPY helpers /helpers

COPY run_kasmvnc.sh /usr/local/bin/run_kasmvnc.sh
COPY kasmvnc.yaml /etc/kasmvnc/kasmvnc.yaml

RUN userdel -r ubuntu || true && \
    useradd ${USER} \
      --create-home \
      --shell=/bin/bash \
      --uid=1000 \
      --groups=ssl-cert \
      --user-group && \
      echo "${USER} ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers.d/nopasswd

COPY bashrc.sh /tmp/
RUN set -e; \
  cat /tmp/bashrc.sh >> /etc/bash.bashrc; \
  rm /tmp/bashrc.sh

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV LANGUAGE=en_US:en

COPY desktop /desktop/
COPY wallpapers /usr/local/share/wallpapers/

USER ${USER}
WORKDIR /home/${USER}

ENV PATH=${HOME}/.local/bin:${HOME}/bin:${PATH}

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV LANGUAGE=en_US:en

ENV LP_ENABLE_RUNTIME=0
ENV LP_HOSTNAME_ALWAYS=-1
