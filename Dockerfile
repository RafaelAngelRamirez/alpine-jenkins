FROM jenkins/jenkins:lts-jdk11

USER root

RUN apt-get update && apt-get install -y lsb-release
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
    https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
    signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
    https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

RUN apt-get update && apt-get install -y docker-ce-cli
# Setup Jenkins
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers
RUN usermod -a -G staff jenkins
USER jenkins



COPY plugins.txt /usr/share/jenkins/plugins.txt
# RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt
RUN jenkins-plugin-cli --plugins \
    blueocean \
    build-environment \
    cloudbees-folder \
    config-file-provider \
    credentials-binding \
    credentials \
    docker-plugin \
    docker-slaves \
    envinject \
    git \
    greenballs \
    groovy \
    http_request \
    job-dsl \
    jobConfigHistory \
    naginator \
    pam-auth \
    pipeline-utility-steps \
    nexus-artifact-uploader \
    slack \
    workflow-aggregator \
    sonar \
    subversion

COPY resources/basic-security.groovy /usr/share/jenkins/ref/init.groovy.d/basic-security.groovy
COPY resources/maven-global-settings-files.xml /usr/share/jenkins/ref/maven-global-settings-files.xml
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"
USER root
