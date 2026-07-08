# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.1.0] - 2026-07-08

### Added

- GitHub Action in this repository (`action.yml`) to run build commands in the GHCR image
- `/android-ci-entrypoint` in the image for the action runtime

### Changed

- Consumers can use `uses: Code0987/android-ci@v2.1.0` with an `args` input, or keep using `container:` / `docker pull`

### Migration from code0987/android-ci-github-action

Replace the deprecated wrapper repo with this action:

```yml
- uses: Code0987/android-ci@v2.1.0
  with:
    args: |
      chmod +x ./gradlew
      ./gradlew assembleDebug --no-daemon
```

[2.1.0]: https://github.com/Code0987/android-ci/releases/tag/v2.1.0

## [2.0.0] - 2026-07-08

### Changed

- Base OS: Ubuntu 18.04 → **Ubuntu 24.04 LTS**
- JDK: OpenJDK 8 → **OpenJDK 17** (required for AGP 8.x / 9.x)
- Android SDK bootstrap: legacy `tools/` → **cmdline-tools** (`CMDTOOLS_VERSION` build ARG)
- Preinstalled platforms: API 25–30 → **API 34–36**
- Build-tools: 29.0.2 → **36.0.0**
- Publish target: Docker Hub → **GitHub Container Registry** (`ghcr.io/code0987/android-ci`)

### Removed

- Node.js, Yarn, git-secret, html2text, and obsolete SDK extras (m2repository / constraint-layout packages)
- Docker Hub publish path and related secrets

### Added

- GitHub Actions build/smoke-test and GHCR release workflows (SBOM + provenance)
- `VERSION` file and this changelog

### Migration

- Use `ghcr.io/code0987/android-ci:2.0.0` (or `:latest`) instead of `code0987/android-ci` on Docker Hub
- Install extra platforms/NDK in the job via `sdkmanager` when needed
- Legacy JDK 8 consumers must pin an older image digest or rebuild from pre-2.0.0 history

[2.0.0]: https://github.com/Code0987/android-ci/releases/tag/v2.0.0
