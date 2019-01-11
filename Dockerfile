ARG TAG="20181204"
ARG DESTDIR="/epanet2"

FROM huggla/alpine-official:$TAG as alpine

ARG BUILDDEPS="build-base wget"
ARG DOWNLOAD="https://www.epa.gov/sites/production/files/2018-10/en2source.zip"
ARG DESTDIR

RUN apk add $BUILDDEPS \
 && downloadDir="$(mktemp -d)" \
 && cd $downloadDir \
 && wget "$DOWNLOAD" \
 && unzip $(basename "$DOWNLOAD") \
 && unzip -o makefiles.ZIP \
 && buildDir="$(mktemp -d)" \
 && cd $buildDir \
 && unzip -o "$downloadDir/epanet2.zip" \
 && unzip -o "$downloadDir/GNU_EXE.ZIP" \
 && rm -rf $downloadDir \
 && sed -i 's|//#define CLE|#define CLE|g' epanet.c \
 && sed -i 's|#define DLL|//#define DLL|g' epanet.c \
 && make

FROM huggla/busybox:$TAG as image

ARG DESTDIR

COPY --from=alpine $DESTDIR $DESTDIR
