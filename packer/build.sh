#!/bin/bash

# build the image
set -e
# if [ -z "${AWS_ACCESS_KEY+xxx}" ]; then echo AWS_ACCESS_KEY is not set at all;exit 1; fi
# if [ -z "$AWS_ACCESS_KEY" -a "${AWS_ACCESS_KEY+xxx}" = "xxx" ]; then echo AWS_ACCESS_KEY is set but empty; exit 1; fi
# if [ -z "${AWS_SECRET_KEY+xxx}" ]; then echo AWS_SECRET_KEY is not set at all; exit 1;fi 
# if [ -z "$AWS_SECRET_KEY" -a "${AWS_SECRET_KEY+xxx}" = "xxx" ]; then echo AWS_SECRET_KEY is set but empty;exit 1; fi

tar --exclude "./.git*" --exclude "./packer" --exclude "./Gemfile.lock" --exclude "./translates.tar.gz" -zcf translates.tar.gz .
mv translates.tar.gz packer/files/opt/translates.tar.gz

export creator=$(git --no-pager show -s --format='%ae' ${TRAVIS_COMMIT})
export creation_time=`date +"%Y%m%d%H%M%S"`
export appversion="0.0.${TRAVIS_BUILD_ID}"
packer -machine-readable build packer/build.json