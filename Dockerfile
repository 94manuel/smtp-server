# Usamos una imagen base de Ubuntu
FROM ubuntu:20.04

# Evitamos que se nos pregunte durante la instalación de paquetes
ENV DEBIAN_FRONTEND=noninteractive

# Actualizamos los paquetes e instalamos Postfix y rsyslog (para el registro de logs)
RUN apt-get update && apt-get install -y postfix rsyslog

# Creamos el usuario admin
RUN useradd -m admin -p $(openssl passwd -1 adminpassword)

# Configuramos Postfix
RUN postconf -e 'myhostname = 51.79.69.232' \
    && postconf -e 'mydomain = 51.79.69.232' \
    && postconf -e 'myorigin = $mydomain' \
    && postconf -e 'inet_interfaces = all' \
    && postconf -e 'mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain'

# Exponemos el puerto SMTP
EXPOSE 25

# Comando para iniciar Postfix y rsyslog
CMD service rsyslog start && service postfix start && tail -F /var/log/mail.log
