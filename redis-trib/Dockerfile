#FROM redis-mgmt:latest
FROM ubuntu:latest

MAINTAINER Francesco Pantano <fmount@inventati.org>

ENV DEBIAN_FRONTEND noninteractive

RUN apt -y update \
  && apt -y upgrade \
  && apt -y install wget git curl ruby redis-server jq\
  && gem install redis \
  && apt -y autoremove \
  && apt -y clean

RUN wget -O /usr/local/bin/redis-trib http://download.redis.io/redis-stable/src/redis-trib.rb

#ADD redis-trib.rb /usr/local/bin/redis-trib.rb
ADD scripts/make_cluster.sh /tmp/make_cluster.sh

RUN chmod 755 /tmp/make_cluster.sh

RUN chmod 755 /usr/local/bin/redis-trib

#ENTRYPOINT ["/usr/local/bin/redis-trib.rb"]
#CMD ["redis-server"]
ENTRYPOINT ["sh -c"]
