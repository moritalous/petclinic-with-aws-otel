FROM bitnami/git:latest as git

WORKDIR /work

RUN git clone --depth 1 https://github.com/spring-projects/spring-petclinic.git

FROM amazoncorretto:11-alpine

RUN adduser -D amazoncorretto

USER amazoncorretto

COPY --from=git --chown=amazoncorretto /work/spring-petclinic /app/spring-petclinic

WORKDIR /app/spring-petclinic

RUN ./mvnw package

ADD --chown=amazoncorretto https://github.com/aws-observability/aws-otel-java-instrumentation/releases/download/v1.17.0/aws-opentelemetry-agent.jar /app/aws-opentelemetry-agent.jar

ENV JAVA_TOOL_OPTIONS ""

ENV OTEL_TRACES_SAMPLER ""
ENV OTEL_PROPAGATORS ""
ENV OTEL_RESOURCE_ATTRIBUTES ""
ENV OTEL_IMR_EXPORT_INTERVAL ""
ENV OTEL_EXPORTER_OTLP_ENDPOINT ""

EXPOSE 8080

CMD ["./mvnw", "spring-boot:run"]
