FROM gcr.io/oss-fuzz-base/base-builder@sha256:1b6a6993690fa947df74ceabbf6a1f89a46d7e4277492addcd45a8525e34be5a

COPY build.sh $SRC
COPY benchmark/ $SRC/deep_nest
ADD seeds /opt/seeds