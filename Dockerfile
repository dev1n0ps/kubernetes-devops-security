FROM amazoncorretto:17.0.7-alpine

EXPOSE 8080
RUN mkdir -p /usr/app
COPY ./target/numeric-*.jar /usr/app
WORKDIR /usr/app

CMD java -jar numeric-*.jar