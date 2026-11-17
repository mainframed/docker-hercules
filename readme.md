# Hercules docker

Docker images of [SDL Hercules Hyperion](https://github.com/SDL-Hercules-390/hyperion), built from source with [hercules-helper](https://github.com/wrljet/hercules-helper) for `linux/amd64`, `linux/arm64`, `linux/s390x` and `linux/riscv64`.

:warning: to run this container you must use `docker run --cap-add=sys_nice`

## Tags

| Tag | What it is | How it's built |
|-----|------------|----------------|
| `latest` | The newest Hercules release | Same image as the newest version tag |
| `4.9.1`, `4.9`, ... | A specific release (the upstream `Release_x.y.z` tag without the `Release_` prefix) | Automatically, by [release.yml](.github/workflows/release.yml) |
| `develop` | HEAD of the upstream `develop` branch | On demand, by [develop.yml](.github/workflows/develop.yml) |

Older version tags remain on Docker Hub; only the newest release is rebuilt.

## Automation

### Releases ([release.yml](.github/workflows/release.yml))

- Runs daily, on every push to `main`, and manually from the Actions tab.
- Lists the `Release_*` tags in the upstream repo, takes the newest by version sort, and builds it with `--build-arg HERCULES_REF=Release_x.y.z`.
- Pushes `mainframed767/hercules:x.y.z` and `mainframed767/hercules:latest`.
- The daily run skips the build if `x.y.z` is already on Docker Hub, so a new upstream release is picked up within a day.
- To rebuild an existing version (for example, after a base image update), run it manually with **force** checked. A push to `main` always rebuilds.
- Pull requests build `linux/amd64` only and don't push.

### Develop ([develop.yml](.github/workflows/develop.yml))

Run it manually from **Actions → Hercules Develop Build → Run workflow**, or with:

```sh
gh workflow run develop.yml
```

It builds the current `develop` branch and pushes `mainframed767/hercules:develop`.

Both workflows need the `DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN` repository secrets.

## Building locally

```sh
# a specific release
docker build --build-arg HERCULES_REF=Release_4.9.1 -t mainframed767/hercules:4.9.1 .

# develop branch
docker build --build-arg HERCULES_BRANCH=develop -t mainframed767/hercules:develop .

# no args: upstream default branch HEAD
docker build -t mainframed767/hercules:local .
```
