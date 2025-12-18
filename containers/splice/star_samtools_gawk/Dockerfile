FROM mambaorg/micromamba:1.5.8

COPY env.yml /tmp/env.yml

RUN micromamba create -y -n star_env -f /tmp/env.yml && \
    micromamba run -n star_env which STAR samtools gawk && \
    micromamba clean --all --yes

ENV PATH=/opt/conda/envs/star_env/bin:$PATH
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

ENTRYPOINT ["/usr/bin/env"]
CMD ["bash"]
