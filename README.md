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
$ docker run --rm lammpsmpi "lmp -h"
```

run simulation in current dir
```console
$ docker run --rm -v "$(pwd)":/var/workdir --user $(id -u):$(id -g) lammpsmpi "lmp -h"
```
