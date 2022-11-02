ARG POSTGRES_VERSION=14
FROM postgres:${POSTGRES_VERSION} as build
ARG POSTGRES_VERSION

WORKDIR /build 

USER root

RUN apt-get update && apt-get install -qq -y \
    git \
    pkgconf \
    build-essential \
    postgresql-server-dev-${POSTGRES_VERSION} \
    libhealpix-cxx-dev \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/postgrespro/pgsphere.git \
    && cd pgsphere \
    && gmake USE_PGXS=1 PG_CONFIG=/usr/bin/pg_config CPPFLAGS+=-I/usr/include/healpix_cxx \
    && gmake USE_PGXS=1 PG_CONFIG=/usr/bin/pg_config install

FROM ghcr.io/cloudnative-pg/postgresql:${POSTGRES_VERSION}
ARG POSTGRES_VERSION

USER root

RUN apt-get update && apt-get install -qq -y \
    libhealpix-cxx2 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=build /usr/lib/postgresql/${POSTGRES_VERSION}/lib/bitcode/pg_sphere/ /usr/lib/postgresql/${POSTGRES_VERSION}/lib/bitcode/pg_sphere/
COPY --from=build /usr/lib/postgresql/${POSTGRES_VERSION}/lib/pg_sphere.so /usr/lib/postgresql/${POSTGRES_VERSION}/lib/pg_sphere.so
COPY --from=build /usr/share/postgresql/${POSTGRES_VERSION}/extension/pg_sphere* /usr/share/postgresql/${POSTGRES_VERSION}/extension/

USER postgres