FROM openjdk:8-jdk-alpine
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring
<<<<<<< HEAD
ARG JAR_FILE=target/*.jar
#COPY ${JAR_FILE} app.jar
=======
# ARG JAR_FILE=target/*.jar
# COPY ${JAR_FILE} app.jar
>>>>>>> 8a7373ec47c05bda90b8f7de2c2a1542996027f7
ENTRYPOINT ["java","-jar","/app.jar"]
