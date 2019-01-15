ARG TAG="20190115"
ARG DESTDIR="/epanet"

FROM huggla/alpine-official as alpine

ARG BUILDDEPS="build-base wget"
ARG DOWNLOAD="https://www.epa.gov/sites/production/files/2018-10/en2source.zip"
ARG DESTDIR

RUN apk add $BUILDDEPS \
 && downloadDir="$(mktemp -d)" \
 && cd $downloadDir \
 && wget --no-check-certificate "$DOWNLOAD" \
 && unzip $(basename "$DOWNLOAD") \
 && unzip -o makefiles.ZIP \
 && buildDir="$(mktemp -d)" \
 && cd $buildDir \
 && unzip -o "$downloadDir/epanet2.zip" \
 && unzip -o "$downloadDir/GNU_EXE.ZIP" \
 && rm -rf $downloadDir \
 && sed -i 's|//#define CLE|#define CLE|g' epanet.c \
 && sed -i 's|#define DLL|//#define DLL|g' epanet.c \
 && make \
 && mkdir -p "$DESTDIR/usr/local/bin" \
 && cp -a epanet2 "$DESTDIR/usr/local/bin/"

FROM huggla/busybox:$TAG as image

ARG DESTDIR

COPY --from=alpine $DESTDIR $DESTDIR
