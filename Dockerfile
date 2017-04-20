FROM nginx:1.7

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update -qq && \
    apt-get -y install curl erubis runit unzip && \
    rm -rf /var/lib/apt/lists/*

ENV CONSUL_TEMPLATE_VERSION=0.14.0

ADD https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_SHA256SUMS /tmp/
ADD https://releases.hashicorp.com/consul-template/${CONSUL_TEMPLATE_VERSION}/consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip /tmp/

RUN cd /tmp && \
    sha256sum -c consul-template_${CONSUL_TEMPLATE_VERSION}_SHA256SUMS 2>&1 | grep OK && \
    unzip consul-template_${CONSUL_TEMPLATE_VERSION}_linux_amd64.zip && \
    mv consul-template /bin/consul-template && \
    rm -rf /tmp

ADD services/nginx.service /etc/service/nginx/run
ADD services/consul-template.service /etc/service/consul-template/run
RUN chmod -R +x /etc/service

RUN rm -v /etc/nginx/conf.d/*
ADD nginx/templates/* /etc/nginx/conf.d/
ADD nginx/nginx.conf /etc/nginx/nginx.conf
RUN mkdir -p /var/www/default/
ADD ssl/* /etc/nginx/ssl/
ADD start_nginx.sh /start_nginx.sh
RUN chmod a+x /start_nginx.sh

ENV LB_SSL=false LB_SSL_KEY_FILE=tugboat.zone-self.key LB_SSL_CRT_FILE=tugboat.zone-self.crt

CMD "/start_nginx.sh"
