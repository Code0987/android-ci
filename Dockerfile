FROM ubuntu:24.04

LABEL maintainer="code0987"
LABEL description="Android CI image with JDK 17 and modern Android SDK"

ARG CMDTOOLS_VERSION=14742923
ARG JDK_VERSION=17

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    ANDROID_HOME=/sdk \
    ANDROID_SDK_ROOT=/sdk

ENV PATH="${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/build-tools/36.0.0"

# System packages + JDK 17
RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        locales \
        openjdk-${JDK_VERSION}-jdk-headless \
        unzip \
        wget \
        zip \
    && locale-gen en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Android command-line tools -> $ANDROID_HOME/cmdline-tools/latest
RUN mkdir -p ${ANDROID_HOME}/cmdline-tools \
    && curl -fsSL "https://dl.google.com/android/repository/commandlinetools-linux-${CMDTOOLS_VERSION}_latest.zip" -o /tmp/cmdline-tools.zip \
    && unzip -q /tmp/cmdline-tools.zip -d /tmp/cmdline-tools \
    && mv /tmp/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest \
    && rm -rf /tmp/cmdline-tools /tmp/cmdline-tools.zip

# Accept licenses and install SDK packages listed in packages.txt
COPY packages.txt /sdk/packages.txt
RUN mkdir -p /root/.android \
    && touch /root/.android/repositories.cfg \
    && yes | sdkmanager --licenses >/dev/null || true \
    && PACKAGES="" \
    && while IFS= read -r package || [ -n "$package" ]; do \
         case "$package" in ''|\#*) continue ;; esac; \
         PACKAGES="${PACKAGES}${package} "; \
       done < /sdk/packages.txt \
    && echo "Installing: ${PACKAGES}" \
    && sdkmanager --install ${PACKAGES} \
    && rm -rf /tmp/* /var/tmp/* \
    && sdkmanager --list_installed

# GitHub Action entrypoint (action.yml overrides entrypoint; default CMD stays a shell)
COPY entrypoint.sh /android-ci-entrypoint
RUN chmod +x /android-ci-entrypoint

WORKDIR /project
