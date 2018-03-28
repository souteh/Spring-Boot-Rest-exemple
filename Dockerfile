FROM java:openjdk-8-jdk-alpine
ADD target/spring-boot-rest-example-0.5.0.war spring-boot-rest-example-0.5.0.war
ENTRYPOINT ["java","-jar","/spring-boot-rest-example-0.5.0.war"]
EXPOSE 8090 8091