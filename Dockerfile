FROM maven:3.6.1-jdk-11 AS builder

COPY ./src/ /root/src
COPY ./pom.xml /root/

WORKDIR /root

RUN mvn package
RUN java -Djarmode=layertools -jar /root/target/ProiectDistributedSystems-0.0.1-SNAPSHOT.jar list
RUN java -Djarmode=layertools -jar /root/target/ProiectDistributedSystems-0.0.1-SNAPSHOT.jar extract
RUN ls -l /root

FROM openjdk:11.0.6-jre


#ENV TZ=UTC
#ENV DB_IP=ec2-52-48-65-240.eu-west-1.compute.amazonaws.com
#ENV DB_PORT=5432
#ENV DB_USER=wlryktxyqpyomt
#ENV DB_PASSWORD=bee98a2afc7f0c3bcdd7df60ee7278ec5fa5cb4fb06a4039b1ffb1107d5851fd
#ENV DB_DBNAME=devidei2vqv0v4

ENV TZ=UTC
ENV DB_IP=ec2-34-247-151-118.eu-west-1.compute.amazonaws.com
ENV DB_PORT=5432
ENV DB_USER=eqceahufsiwrru
ENV DB_PASSWORD=ad363233b1a151d31ed9b5b4dcb4ce45fe0713c9dbaba3b07aab0724345d4f8b
ENV DB_DBNAME=ddihg054hubctq


COPY --from=builder /root/dependencies/ ./
COPY --from=builder /root/snapshot-dependencies/ ./

RUN sleep 10

COPY --from=builder /root/spring-boot-loader/ ./
COPY --from=builder /root/application/ ./

ENTRYPOINT ["java", "org.springframework.boot.loader.JarLauncher","-XX:+UseContainerSupport -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -XX:MaxRAMFraction=1 -Xms512m -Xmx512m -XX:+UseG1GC -XX:+UseSerialGC -Xss512k -XX:MaxRAM=72m"]






