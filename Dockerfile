FROM alpine:3.7

RUN apk --no-cache add --virtual .build-dependencies build-base \
 && wget https://www.epa.gov/sites/production/files/2014-06/en2source.zip \
 && unzip en2source.zip \
 && unzip -o makefiles.ZIP \
 && mkdir epa \
 && cd epa \
 && unzip -o ../epanet2.zip \
 && unzip -o ../GNU_EXE.ZIP \
 && sed -i 's|//#define CLE|#define CLE|g' epanet.c \
 && sed -i 's|#define DLL|//#define DLL|g' epanet.c \
 && make
