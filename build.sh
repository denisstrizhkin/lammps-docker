#!/usr/bin/env bash

build() {
  docker build -t "$1" -f "$2" .
}

build_gentoocuda() {
  docker build -t gentoocuda https://github.com/denisstrizhkin/gentoo-cuda.git#main
}

case "$1" in
  mpi)
  build lammpsmpi ./lammps-mpi.Dockerfile
  ;;
  opencl)
  build_gentoocuda
  build lammpsopencl ./lammps-opencl.Dockerfile
  ;;
  *)
  echo "wrong option: $1"
  ;;
esac