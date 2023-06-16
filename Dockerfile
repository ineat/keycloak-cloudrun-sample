# You can easily repackage Keycloak with a latest version by using this arg during the docker build
ARG KEYCLOAK_VERSION=21.1.1

# See https://www.keycloak.org/server/containers
FROM quay.io/keycloak/keycloak:${KEYCLOAK_VERSION} as builder

# Install custom providers if you have some one
# ADD kc-extensions/ineat-kc-theme/target/ineat-kc-theme.jar /opt/keycloak/providers

# add required provider libs
# ADD kc-extensions/**/target/lib/*.jar /opt/keycloak/providers/

# here is the workaround to enable json logs on Cloud Logging
ADD server/conf/quarkus.properties /opt/keycloak/conf

# quarkus needs build with custom extensions
RUN /opt/keycloak/bin/kc.sh build --db=postgres

FROM quay.io/keycloak/keycloak:${KEYCLOAK_VERSION}
COPY --from=builder /opt/keycloak/ /opt/keycloak/
WORKDIR /opt/keycloak

ENTRYPOINT ["/opt/keycloak/bin/kc.sh"]
