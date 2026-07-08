# android-ci sample app

Minimal Android app used as an **integration test** for the `android-ci` image and GitHub Action.

- `compileSdk` / `targetSdk`: 35
- `minSdk`: 24
- AGP 8.7.3, Kotlin 2.0.21, Gradle 8.11.1
- JDK 17

## Build with the published image

```bash
docker run --rm -v "$PWD":/project -w /project \
  ghcr.io/code0987/android-ci:2.1.0 \
  ./gradlew assembleDebug --no-daemon
```

## Build with the GitHub Action

```yml
- uses: Code0987/android-ci@v2.1.0
  with:
    args: |
      cd sample
      chmod +x ./gradlew
      ./gradlew assembleDebug --no-daemon
```

CI builds this project after constructing the local image in `.github/workflows/build.yml`.
