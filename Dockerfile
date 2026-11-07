
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Actualizar paquetes e instalar SSH, sudo y Python
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    python3 \
    python3-apt \
    && apt-get clean

# Crear directorio necesario para SSH
RUN mkdir -p /run/sshd

# Crear usuario ansible y asignar contraseña
RUN useradd -m -s /bin/bash ansible && \
    echo 'ansible:ansible' | chpasswd

# Permitir sudo sin contraseña
RUN echo 'ansible ALL=(ALL) NOPASSWD:ALL' \
    > /etc/sudoers.d/ansible && \
    chmod 0440 /etc/sudoers.d/ansible

# Permitir autenticación SSH mediante contraseña
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' \
    /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' \
    /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
