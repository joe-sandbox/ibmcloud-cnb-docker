FROM ubuntu:21.10
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 
ENV LANG en_US.utf8
ENV TZ=America/Mexico_City
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezon
RUN apt-get update && apt-get -y install curl && apt-get -y install git
RUN curl -fsSL https://clis.cloud.ibm.com/install/linux > ibmcloudcli.sh && chmod +x ibmcloudcli.sh && ./ibmcloudcli.sh
RUN echo 'alias ic="ibmcloud"' >> .bashrc
RUN apt-get update && apt-get -y install vim
RUN apt-get update && apt-get -y install openjdk-8-jdk && echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64" >> .bashrc && echo "export PATH=$PATH:$JAVA_HOME/bin" >> .bashrc
RUN . ~/.bashrc
WORKDIR /home
RUN git clone https://github.com/IBM/container-service-getting-started-wt.git && \
    git clone https://github.com/ibm-cloud-academy/LightBlueCompute && \
    curl https://bootcamp-gradle-build.mybluemix.net/ms/catalog --output catalog.jar && \
    curl https://bootcamp-gradle-build.mybluemix.net/ms/customer --output customer.jar
CMD ["bash"]
VOLUME [ "/home" ]