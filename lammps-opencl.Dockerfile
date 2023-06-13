FROM gentoocuda

RUN emerge-webrsync \
  && emerge dev-vcs/git \
  && echo -e '[gentoo-repo]\n\
location = /var/db/repos/gentoo-repo\n\
sync-type = git\n\
sync-uri = https://github.com/denisstrizhkin/gentoo-repo.git' > /etc/portage/repos.conf \
  && emerge --sync gentoo-repo \
  && echo -e 'sci-physics/lammps gzip mpi opencl\n\
virtual/mpi romio\nsci-libs/hdf5 mpi\nsci-libs/netcdf mpi' >> /etc/portage/package.use \
  && emerge =sci-physics/lammps-20230328 \
  && rm -rf /var/cache/distfiles/* \
  && rm -rf /var/db/repos/*

WORKDIR /var/workdir

CMD [ "/bin/bash", "--login" ]
ENTRYPOINT [ "/bin/bash", "--login", "-c" ]
