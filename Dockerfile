FROM amazoncorretto:17.0.7-alpine
EXPOSE 8080
ARG JAR_FILE=target/*.jar
# -S	Ensures minimal, system-level user or group creation.
RUN addgroup -S pipeline && adduser -S k8s-pipeline -G pipeline
COPY ${JAR_FILE} /home/k8s-pipeline/app.jar
USER k8s-pipeline
ENTRYPOINT ["java", "-jar", "/home/k8s-pipeline/app.jar"]

# root@devsecops-cloud:~# k exec -it devsecops-7bdc56d956-vdqqd -- id
# uid=100(k8s-pipeline) gid=101(pipeline) groups=101(pipeline)