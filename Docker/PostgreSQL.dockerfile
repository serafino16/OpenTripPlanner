
FROM postgis/postgis:latest


ENV POSTGRES_DB=opentripplanner
ENV POSTGRES_USER=otp_user
ENV POSTGRES_PASSWORD=otp_password


WORKDIR /var/lib/postgresql/data


EXPOSE 5432

CMD ["postgres"]
