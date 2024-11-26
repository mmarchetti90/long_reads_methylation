#!/bin/bash

dockerfile=$1
name=$2
tag=$3

mkdir -p sif_images
mkdir -p tar_images
rm sif_images/${name}.sif
rm ${name}.sif
docker build -t ${name}:${tag} -f ${dockerfile} .
docker save -o ${name}.tar localhost/${name}:${tag}
singularity build ${name}.sif docker-archive://${name}.tar
mv ${name}.tar tar_images/
mv ${name}.sif sif_images/
