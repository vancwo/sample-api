FROM python:3.12

ENV FLYWAY_DEFAULT_SCHEMA housing
ENV POSTGRES_HOST sampledb
ENV POSTGRES_USER postgres
ENV POSTGRES_PASSWORD default
ENV POSTGRES_DATABASE postgres
ENV PIP_NO_CACHE_DIR false
ENV PIP_DISABLE_PIP_VERSION_CHECK true
ENV PIP_DEFAULT_TIMEOUT 100
ENV POETRY_VERSION 1.8.3
ENV POETRY_HOME /opt/poetry
ENV POETRY_VIRTUALENVS_IN_PROJECT true
ENV POETRY_NO_INTERACTION 1
ENV PYSETUP_PATH /application
ENV VENV_PATH /application/.venv
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONPATH /application/app/src

COPY . /application
WORKDIR /application

RUN curl -sSL https://install.python-poetry.org | python3 -

ENV PATH $POETRY_HOME/bin:$VENV_PATH/bin:$PATH
RUN poetry install --no-root -vvv --sync
RUN . $(poetry env info --path)/bin/activate

EXPOSE 3000
CMD poetry run fastapi run --host 0.0.0.0 --port 3000 src/sample_api/main.py