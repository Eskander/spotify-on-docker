FROM ubuntu:20.04
LABEL maintainer="Eskander Bejaoui"

# Download packages
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt update \
    && apt install --yes --no-install-recommends \
    add-apt-key \
    curl \
    novnc \
    pulseaudio \
    sudo \
    x11vnc \
    xvfb

# Download Spotify client
RUN curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | apt-key add - \
    && echo "deb http://repository.spotify.com stable non-free" | tee /etc/apt/sources.list.d/spotify.list \
    && apt update \
    && apt install --yes spotify-client \
    && rm -rf /var/lib/apt/lists/*

# Create user:user
RUN useradd -u 1000 -m -d /home/user -s /bin/bash user \
    && usermod -aG audio user \
    && echo "user ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user \
    && chmod 0440 /etc/sudoers.d/user \
    && mkdir -p /home/user/.config/pulse \
    && mkdir -p /home/user/.config/spotify \
    && chown -R user:user /home/user

# Configure container
COPY pulse-client.conf /etc/pulse/client.conf
COPY init.sh /init.sh
ENTRYPOINT ["/init.sh"]
RUN chmod +x /init.sh

EXPOSE 8080
VOLUME /run/user/1000/pulse /home/user/.config/spotify
