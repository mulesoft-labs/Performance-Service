
FROM alpine:3.9


ARG JMETER_VERSION="3.3"
ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
ENV	JMETER_BIN	${JMETER_HOME}/bin
ENV	JMETER_DOWNLOAD_URL  https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz

# Install extra packages
# See https://github.com/gliderlabs/docker-alpine/issues/136#issuecomment-272703023
# Change TimeZone TODO: TZ still is not set!
# ARG TZ="Europe/Amsterdam"

RUN    apk update \
	&& apk upgrade \
	&& apk add ca-certificates \
	&& update-ca-certificates \
	&& apk add --update openjdk8-jre tzdata curl unzip bash \
	&& apk add --no-cache nss \
	&& rm -rf /var/cache/apk/* \
	&& mkdir -p /tmp/dependencies  \
	&& curl -L --silent ${JMETER_DOWNLOAD_URL} >  /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz  \
	&& mkdir -p /opt  \
	&& tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C /opt  \
	&& rm -rf /tmp/dependencies

# plugins

RUN wget -q http://central.maven.org/maven2/kg/apc/cmdrunner/2.2.1/cmdrunner-2.2.1.jar -O ${JMETER_HOME}/lib/cmdrunner-2.2.jar && \
 wget -q https://jmeter-plugins.org/get/ -O ${JMETER_HOME}/lib/ext/jmeter-plugins-manager.jar && \
 cd ${JMETER_HOME}/lib/ext/ && java -cp jmeter-plugins-manager.jar org.jmeterplugins.repository.PluginManagerCMDInstaller && \
 cd ${JMETER_HOME}/bin && ./PluginsManagerCMD.sh install jpgc-mergeresults && \
 cd ${JMETER_HOME}/bin && ./PluginsManagerCMD.sh install jpgc-synthesis && \
 cd ${JMETER_HOME}/bin && ./PluginsManagerCMD.sh install jpgc-cmd && \
 cd ${JMETER_HOME}/bin && ./PluginsManagerCMD.sh install jpgc-casutg && \
 cd ${JMETER_HOME}/bin && ./PluginsManagerCMD.sh install jpgc-json && \
 cd ${JMETER_HOME}/bin && ./PluginsManagerCMD.sh status


# && unzip -oq "/tmp/dependencies/JMeterPlugins-*.zip" -d $JMETER_HOME

# Set global PATH such that "jmeter" command is found
ENV PATH $PATH:$JMETER_BIN

# Entrypoint has same signature as "jmeter" command
COPY entrypoint.sh /

WORKDIR	${JMETER_HOME}

ENTRYPOINT ["/entrypoint.sh"]
RUN ["chmod", "+x", "/entrypoint.sh"]

FROM maven:3.5-jdk-8

# copy the project files
COPY ./pom.xml ./pom.xml

# copy your other files
COPY ./src ./src

# build for release
RUN mvn clean install -DskipTests

EXPOSE 8080

# set the startup command to run your binary
CMD ["java", "-jar", "./target/performance-service-0.0.1-SNAPSHOT.jar"]
