# lammps-docker

build image
```console
$  docker build -t lammpsmpi -f ./lammps-mpi.Dockerfile .
```

run container
```console
 docker run --rm -it lammpsmpi "lmp -h"
```
