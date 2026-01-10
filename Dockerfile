FROM debian:13


ENV DEBIAN_FRONTEND=noninteractive


# Basic utilities
RUN apt-get update && apt-get install -y \
sudo \
wget \
curl \
git \
ca-certificates \
gnupg \
lsb-release \
software-properties-common \
x11-apps \
libgtk-3-0 \
libnotify4 \
libnss3 \
libxss1 \
libxtst6 \
xdg-utils \
fuse \
&& rm -rf /var/lib/apt/lists/*


# -----------------------------
# Install KiCad
# -----------------------------
RUN add-apt-repository --yes ppa:kicad/kicad-9.0-releases && \
apt-get update && \
apt-get install -y kicad && \
rm -rf /var/lib/apt/lists/*

# -----------------------------
# Install Yosys FPGA toolchain
# -----------------------------
RUN apt-get update && apt-get install -y \
yosys \
nextpnr-ice40 \
icepack \
iverilog \
&& rm -rf /var/lib/apt/lists/*

# -----------------------------
# Install Icestudio
# -----------------------------
# Icestudio is distributed as an AppImage
RUN wget -O /usr/local/bin/icestudio.AppImage \
https://github.com/FPGAwars/icestudio/releases/latest/download/icestudio-x86_64.AppImage && \
chmod +x /usr/local/bin/icestudio.AppImage


# Convenience wrapper
RUN echo '#!/bin/sh\n/usr/local/bin/icestudio.AppImage --no-sandbox' > /usr/local/bin/icestudio && \
chmod +x /usr/local/bin/icestudio


# Create a non-root user
RUN useradd -m dev && \
echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers


USER dev
WORKDIR /home/dev


CMD ["bash"]

