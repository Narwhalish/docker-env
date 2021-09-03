FROM ubuntu:20.04

# Remove diverted man binary to prevent man-pages being replaced with "minimized" message.
# https://github.com/CIS380/docker-env/wiki/Install-man-page
RUN if  [ "$(dpkg-divert --truename /usr/bin/man)" = "/usr/bin/man.REAL" ]; then \
        rm -f /usr/bin/man; \
        dpkg-divert --quiet --remove --rename /usr/bin/man; \
    fi

RUN sed -i 's,^path-exclude=/usr/share/man/,#path-exclude=/usr/share/man/,' /etc/dpkg/dpkg.cfg.d/excludes

COPY docker-setup.sh .
RUN chmod +x docker-setup.sh
RUN ./docker-setup.sh

# Setting up cis380 as the user 
ARG GID=1000
ARG UID=1000
RUN addgroup --gid $GID cis380
RUN useradd --system --create-home --shell /bin/bash --groups sudo -p "$(openssl passwd -1 cis)" --uid $UID --gid $GID cis380
RUN wget -O /root/.vimrc https://gist.githubusercontent.com/Narwhalish/8262fb92f002530244a20edb6af7b190/raw/abc8cb703c782dc461d2add5930bfe66ff82da96/project-env-setup.sh
RUN cp /root/.vimrc /home/cis380/.vimrc
RUN chown cis380:cis380 /home/cis380/.vimrc
USER cis380
WORKDIR /home/cis380/
