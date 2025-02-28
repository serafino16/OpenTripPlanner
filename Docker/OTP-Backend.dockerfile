
FROM openjdk:17-jdk-slim

ENV JAVA_OPTS="-Xmx4G"
ENV OTP_DATA_DIR="/var/otp"

WORKDIR /var/otp

EXPOSE 8080

CMD ["java",  "-jar", "/otp.jar"]
