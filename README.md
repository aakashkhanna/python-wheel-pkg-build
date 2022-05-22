# python-wheel-pkg-build

# What is Poetry
Poetry helps you declare, manage and install dependencies of Python projects, ensuring you have the right stack everywhere.

* [Poetry Project homepage](https://github.com/python-poetry/poetry)


# How to use this image as a part of multi stage docker build
It expects the code and pyproject.toml to be bound at /src
It expects the gitversion to be extracted by aakashkhanna/dockerized-gitversion:latest 

## Step 1
Add the following as the first stage in your multistage docker file

```dockerfile
FROM aakashkhanna/dockerized-gitversion:latest as gitversion

```

## Step 2
Add the following in the second stage of your multistage docker file

```dockerfile
FROM aakashkhanna/python-wheel-pkg-build:latest

```

# Sample DockerFile

```dockerfile
FROM aakashkhanna/dockerized-gitversion:latest as gitversion
FROM aakashkhanna/python-wheel-pkg-build:latest
```

## How to build and publish wheel package
```sh
docker build \
-t weather-cli:test \
--progress=plain \
--build-arg POETRY_PYPI_TOKEN_PYPI="pypi-token-from-pypi"\
--build-arg PUBLISH=y .
```

# Configurations

## Auth to pypi repo

### Token Auth

Set POETRY_PYPI_TOKEN_PYPI with the token you get from pypi to perform Token Auth while publishing the package.

Example:
```sh
docker build \
-t weather-cli:test \
--progress=plain \
--build-arg POETRY_PYPI_TOKEN_PYPI="pypi-token-from-pypi"\
--build-arg PUBLISH=y .
```


### Username Password Auth

Set POETRY_HTTP_BASIC_PYPI_USERNAME and POETRY_HTTP_BASIC_PYPI_PASSWORD to perform Username Password Auth while publishing the package.

Example:
```sh
docker build \
-t weather-cli:test \
--progress=plain \
--build-arg POETRY_HTTP_BASIC_PYPI_USERNAME="pypi-username"\
--build-arg POETRY_HTTP_BASIC_PYPI_PASSWORD="pypi-password"\
--build-arg PUBLISH=y .
```

### Run only build not publish

Do not set PUBLISH while running the docker build to perform just build and not publish.

Example:
```sh
docker build \
-t weather-cli:test \
--progress=plain
```