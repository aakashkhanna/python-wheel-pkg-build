FROM python:3.8

COPY ./build.sh /build/

WORKDIR  /build

RUN chmod +x build.sh \
    && pip install poetry \
    && pip install pytest \
    && pip install pytest-html-reporter \
    && pip install pytest-cov


ONBUILD ARG SOURCE_DIR="src"
ONBUILD ARG GIT_DIR=".git"
ONBUILD ARG CONFIG_FILE_PATH="pyproject.toml"
ONBUILD ARG POETRY_PYPI_TOKEN_PYPI
ONBUILD ARG POETRY_HTTP_BASIC_PYPI_USERNAME
ONBUILD ARG POETRY_HTTP_BASIC_PYPI_PASSWORD
ONBUILD ARG PUBLISH

ONBUILD COPY --from=gitversion /repo/version.txt /project/
ONBUILD COPY ${SOURCE_DIR} /project
ONBUILD COPY ${GIT_DIR} /project/.git

ONBUILD RUN mkdir /project/output

ONBUILD RUN bash ./build.sh