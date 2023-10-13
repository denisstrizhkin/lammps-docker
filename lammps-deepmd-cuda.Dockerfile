FROM gentootensorflow

RUN  echo 'virtual/mpi romio' >> /etc/portage/package.use \
  && echo 'sci-libs/hdf5 mpi' >> /etc/portage/package.use \
  && emerge -q virtual/mpi voro++ sci-libs/hdf5

RUN emerge -1q dev-vcs/git
RUN emerge -q dev-python/virtualenv

RUN useradd -ms /bin/bash lammps
USER lammps

ENV HOME=/home/lammps
ENV VIRTUAL_ENV="$HOME/.local"
RUN virtualenv "$VIRTUAL_ENV"

ENV DEEPMD_SRC="$HOME/deepmd"
ENV LAMMPS_SRC="$HOME/lammps"

RUN  git clone --recursive https://github.com/deepmodeling/deepmd-kit.git "$DEEPMD_SRC" \
  && git clone -b release https://github.com/lammps/lammps.git "$LAMMPS_SRC"

RUN  cd "$DEEPMD_SRC"/source && mkdir build && cd build \
  && cmake -D CUDAToolkit_ROOT=/opt/cuda -D USE_CUDA_TOOLKIT=true -D TENSORFLOW_ROOT=/usr/include/tensorflow \
       -D ENABLE_NATIVE_OPTIMIZATION=true -D LAMMPS_SOURCE_ROOT="$LAMMPS_SRC" -D CMAKE_INSTALL_PREFIX="$VIRTUAL_ENV" .. \
  && make -j$(nproc) && make install

RUN  . "$VIRTUAL_ENV/bin/activate" && cd "$LAMMPS_SRC" && mkdir build && cd build \
  && cmake -D PKG_PLUGIN=ON -D PKG_KSPACE=ON -D LAMMPS_INSTALL_RPATH=ON -D BUILD_SHARED_LIBS=yes \
       -D PKG_OPENMP=on -D BUILD_MPI=yes \
       -D PKG_GPU=yes -D GPU_API=cuda -D GPU_ARCH=sm_80 -D BIN2C=/opt/cuda/bin/bin2c \ 
       -D LAMMPS_EXCEPTIONS=yes -D PKG_PYTHON=yes \
       -D PKG_MANYBODY=on -D PKG_VORONOI=on -D PKG_EXTRA-FIX=on \ 
       -D CMAKE_INSTALL_PREFIX="$VIRTUAL_ENV" -D CMAKE_INSTALL_LIBDIR=lib -D CMAKE_INSTALL_FULL_LIBDIR="$VIRTUAL_ENV/lib" ../cmake \
  && make -j$(nproc) && make install && make install-python

RUN echo "PATH=\"$VIRTUAL_ENV/bin:\$PATH\"" >> ~/.bash_profile

USER root

RUN  emerge -c \
  && rm -rf /var/cache/distfiles/* \
  && rm -rf "$LAMMPS_SRC" && rm -rf "$DEEPMD_SRC"

USER lammps
