FROM gentoocuda

RUN emerge-webrsync \
  && emerge -q1 dev-vcs/git \
  && echo 'virtual/mpi romio' >> /etc/portage/package.use \
  && echo 'sci-libs/hdf5 mpi' >> /etc/portage/package.use \ 
  && emerge -q virtual/mpi voro++ sci-libs/hdf5 \
  && cd /var && git clone -b release https://github.com/lammps/lammps.git \
  && cd lammps && mkdir build && cd build \
  && cmake -D PKG_OPENMP=on -D PKG_MANYBODY=on -D PKG_VORONOI=on -D BUILD_MPI=yes \
    -D PKG_GPU=yes -D GPU_API=cuda -D GPU_ARCH=sm_80 -DBIN2C=/opt/cuda/bin/bin2c \
    -D PKG_EXTRA-FIX=on -D CMAKE_INSTALL_PREFIX=/usr ../cmake \
  && make -j$(nproc) && make install \
  && emerge -c \
  && rm -rf /var/cache/distfiles/* /var/db/repos/* /var/lammps
