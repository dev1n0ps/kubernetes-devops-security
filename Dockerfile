FROM amazoncorretto:17.0.7-alpine

EXPOSE 8080

COPY ./target/numeric-*.jar /usr/app
WORKDIR /usr/app

CMD java -jar numeric-*.jar