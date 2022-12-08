FROM python:3.11.1-alpine3.17 AS builder

RUN apk add --no-cache build-base dbus dbus-glib-dev

RUN python -m venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

COPY . .

RUN pip install \
    --use-pep517 \
    dbus-python \
    .

FROM python:3.11.1-alpine3.17

RUN apk add --no-cache dbus-glib-dev

COPY --from=builder /opt/venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"
ENV CNAMEs="mdns-cname-publisher.local"

USER nobody
ENTRYPOINT exec mdns-publish-cname $CNAMEs
