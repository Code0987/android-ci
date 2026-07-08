# Android CI

[![Android CI on Docker Hub](https://img.shields.io/docker/cloud/build/code0987/android-ci.svg)](https://hub.docker.com/r/code0987/android-ci)

Docker image for building Android apps in CI. Includes **JDK 17**, Android SDK command-line tools, platform-tools, build-tools, and platforms **API 34–36**.

## Image contents

| Component | Version |
|-----------|---------|
| Base OS | Ubuntu 24.04 LTS |
| JDK | OpenJDK 17 |
| Android cmdline-tools | latest (pinned by build ARG) |
| Build-tools | 36.0.0 |
| Platforms | android-34, 35, 36 |
| Platform-tools | latest |

Environment:

- `ANDROID_HOME` / `ANDROID_SDK_ROOT` = `/sdk`
- `sdkmanager` and `adb` on `PATH`

## Breaking changes (v2 / 2026 refresh)

Compared to the previous image (Ubuntu 18.04 / JDK 8 / API 25–30):

- **JDK 8 → 17** — required for Android Gradle Plugin 8.x and 9.x
- **Legacy `tools/` package replaced** by `cmdline-tools/latest`
- **Platforms 25–30 removed**; only 34–36 are preinstalled
- **Node, Yarn, git-secret removed** — install in your job if needed
- Obsolete SDK “extras” (m2repository, constraint-layout packages) removed; use Maven

If you still need the old stack, pin a historical image digest or keep a `legacy` tag from the previous Dockerfile.

## Sample usages

### GitLab CI/CD

*.gitlab-ci.yml*

```yml
image: code0987/android-ci:latest

before_script:
  - export GRADLE_USER_HOME="$CI_PROJECT_DIR/.gradle"
  - chmod +x ./gradlew

cache:
  key: "$CI_COMMIT_REF_SLUG"
  paths:
    - .gradle/

stages:
  - build

build:
  stage: build
  script:
    - ./gradlew assembleDebug --no-daemon
  artifacts:
    paths:
      - app/build/outputs/apk/
```

### GitHub Actions

*.github/workflows/android-ci.yml*

```yml
name: Android CI

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    container: code0987/android-ci:latest

    steps:
      - uses: actions/checkout@v4

      - name: Build
        run: |
          export GRADLE_USER_HOME="$GITHUB_WORKSPACE/.gradle"
          chmod +x ./gradlew
          ./gradlew assembleDebug --no-daemon
```

### Local build

```bash
docker run --rm -v "$PWD":/project -w /project code0987/android-ci:latest \
  ./gradlew assembleDebug --no-daemon
```

### Extra SDK packages

Install at job time if you need older platforms or the NDK:

```bash
sdkmanager "platforms;android-33" "ndk;28.0.13004108"
```

## Build this image

```bash
docker build -t android-ci:local .
# optional pins:
docker build --build-arg CMDTOOLS_VERSION=14742923 --build-arg JDK_VERSION=17 -t android-ci:local .
```

## Smoke test

```bash
docker run --rm android-ci:local java -version
docker run --rm android-ci:local sdkmanager --version
docker run --rm android-ci:local sdkmanager --list_installed
```
