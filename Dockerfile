FROM ghcr.io/engineer-man/piston:latest

USER root

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    unzip \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Copy our new loader script and the modified entrypoint
COPY api/src/loader.js /piston_api/src/loader.js
COPY api/src/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Set the package details
ARG PKG_LANG=codeforces
ARG PKG_VER=1.0.0

# Create the package directory
RUN mkdir -p /piston/packages/${PKG_LANG}/${PKG_VER}

# Copy the build script and the metadata file (renaming it)
COPY packages/codeforces/1.0.0/* /piston/packages/${PKG_LANG}/${PKG_VER}/
COPY packages/codeforces/1.0.0/metadata.json /piston/packages/${PKG_LANG}/${PKG_VER}/pkg-info.json
RUN chmod +x /piston/packages/${PKG_LANG}/${PKG_VER}/build.sh

# Change to the package directory and execute the build script
WORKDIR /piston/packages/${PKG_LANG}/${PKG_VER}
RUN bash -x ./build.sh

# Perform the final registration steps
RUN \
    echo "PATH=/piston/packages/${PKG_LANG}/${PKG_VER}/bin:/usr/bin:/bin:\$PATH" > .env && \
    touch .piston_package_installed && \
    chown -R piston:piston /piston/packages/${PKG_LANG}/${PKG_VER}

# Set the working directory back to the application root
WORKDIR /piston
