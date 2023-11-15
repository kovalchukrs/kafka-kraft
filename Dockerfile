FROM openjdk:22-slim-bookworm

ENV KAFKA_VERSION 3.6.0
ENV SCALA_VERSION 2.13

# Установка Kafka
RUN apt update; apt install -y wget htop && \
    wget https://downloads.apache.org/kafka/$KAFKA_VERSION/kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz -O /tmp/kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz && \
    tar -xzf /tmp/kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz -C /opt && \
    rm /tmp/kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz

# Настройка переменных среды
ENV KAFKA_HOME /opt/kafka_$SCALA_VERSION-$KAFKA_VERSION
ENV KAFKA_CLUSTER_ID=NSWKMk6uSzuIGjwmaBGNew
ENV PATH $PATH:$KAFKA_HOME/bin

# Generate a Cluster UUID 
# RUN export KAFKA_CLUSTER_ID="$($KAFKA_HOME/bin/kafka-storage.sh random-uuid)"
### Создание темы Kafka (по желанию)
### RUN bin/kafka-topics.sh --create --replication-factor 1 --partitions 1 --topic my-topic

WORKDIR $KAFKA_HOME
RUN $KAFKA_HOME/bin/kafka-storage.sh format -t $KAFKA_CLUSTER_ID -c $KAFKA_HOME/config/kraft/server.properties && \
    sed -i 's/tmp/opt/' config/kraft/server.properties && \
    $KAFKA_HOME/bin/kafka-storage.sh format --cluster-id $KAFKA_CLUSTER_ID --config $KAFKA_HOME/config/kraft/server.properties

# Change log.dirs to
#### RUN sed -i 's/tmp/opt/' config/kraft/server.properties

#### RUN $KAFKA_HOME/bin/kafka-storage.sh format --cluster-id $KAFKA_CLUSTER_ID --config $KAFKA_HOME/config/kraft/server.properties

### Run in compose command 
# bin/kafka-server-start.sh -daemon config/kraft/server.properties
# RUN bin/kafka-server-start.sh config/kraft/server.properties
# ENTRYPOINT ["bin/kafka-server-start.sh config/kraft/server.properties"]
# ENTRYPOINT ["kafka-server-start.sh", "config/kraft/server.properties"]