FROM alpine:edge

ENV SHELL=/bin/sh \
    CC="/usr/bin/ccache /usr/bin/clang" \
    CXX="/usr/bin/ccache /usr/bin/clang++" \
    LANG=C.UTF-8

WORKDIR /tmp
COPY . /tmp

RUN --mount=type=cache,target=/root/.cache/ccache --mount=type=tmpfs,target=/tmp \
    cd /tmp \
    && ls /tmp \
    && apk update \
    && apk upgrade \
# Install libraries
# Install development tools
    && apk add --no-cache --virtual .dev-deps \
        ccache clang gcc cmake ninja musl-dev \
    && ccache -s \
# Build Python
    && cd /tmp \
    && cmake -G"Ninja" -DCMAKE_C_FLAGS="-O3" -DCMAKE_CXX_FLAGS="-O3" -DCMAKE_BUILD_TYPE=Release . \
    && cmake --build . --config Release --parallel 4 \
# Build Panda3D
    && ccache -s