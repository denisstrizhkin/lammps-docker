# lammps-docker

## Build image

manual
```console
$  docker build -t lammpsmpi -f ./lammps-mpi.Dockerfile .
```

script mpi
```console
$ ./build.sh mpi
```

script opencl
```console
$ ./build.sh opencl
```

## Run container

display lmp info
```console
$ docker run --rm -it lammpsmpi "lmp -h"
```
