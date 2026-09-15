FROM ghcr.io/linuxserver/baseimage-selkies:debiantrixie

ENV TITLE="Mp3tag"
ENV PIXELFLUX_WAYLAND=true
ENV WINEARCH=win64
ENV WINEDEBUG=-all
ENV WINEPREFIX=/config/.wine
ENV RESTART_APP=true

# ---------------------------------------------------------
# System packages + Wine
# ---------------------------------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget \
        gnupg \
        ca-certificates \
        cabextract \
        winbind \
        7zip && \
    dpkg --add-architecture i386 && \
    mkdir -pm755 /etc/apt/keyrings && \
    wget -O /etc/apt/keyrings/winehq-archive.key \
        https://dl.winehq.org/wine-builds/winehq.key && \
    wget -NP /etc/apt/sources.list.d/ \
        https://dl.winehq.org/wine-builds/debian/dists/trixie/winehq-trixie.sources && \
    apt-get update && \
    apt-get install -y --install-recommends winehq-stable && \
    rm -rf /var/lib/apt/lists/*

# ---------------------------------------------------------
# Mp3tag — портативная распаковка NSIS-установщика (без запуска Wine на сборке)
# ---------------------------------------------------------
RUN mkdir -p /opt/mp3tag /tmp/mp3tag-extracted && \
    wget -O /tmp/mp3tag-setup.exe \
        "https://download.mp3tag.de/mp3tag-v3.36.1-x64-setup.exe" && \
    7z x /tmp/mp3tag-setup.exe \
        -o/tmp/mp3tag-extracted \
        -y && \
    MP3TAG_EXE="$(find /tmp/mp3tag-extracted \
        -type f \
        -iname 'Mp3tag.exe' \
        -print -quit)" && \
    test -n "$MP3TAG_EXE" && \
    echo "Found Mp3tag: $MP3TAG_EXE" && \
    cp -a "$(dirname "$MP3TAG_EXE")"/. /opt/mp3tag/ && \
    test -f /opt/mp3tag/Mp3tag.exe && \
    ls -lh /opt/mp3tag/Mp3tag.exe && \
    rm -rf /tmp/mp3tag-extracted /tmp/mp3tag-setup.exe

# ---------------------------------------------------------
# Selkies / labwc configuration
# ---------------------------------------------------------
COPY root /

RUN chmod +x /defaults/autostart /defaults/autostart_wayland


EXPOSE 3001
VOLUME /config
