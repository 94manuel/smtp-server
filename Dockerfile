# Usamos una imagen base de Ubuntu
FROM ubuntu:20.04

# Evitamos que se nos pregunte durante la instalación de paquetes
ENV DEBIAN_FRONTEND=noninteractive

# Actualizamos los paquetes e instalamos Postfix y rsyslog (para el registro de logs)
RUN apt-get update && apt-get install -y postfix rsyslog

# Configuramos Postfix
RUN postconf -e 'myhostname = mail.example.com' \
    && postconf -e 'mydomain = example.com' \
    && postconf -e 'myorigin = $mydomain' \
    && postconf -e 'inet_interfaces = all' \
    && postconf -e 'mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain'

# Exponemos el puerto SMTP
EXPOSE 25

# Comando para iniciar Postfix y rsyslog
CMD service rsyslog start && service postfix start && tail -F /var/log/mail.log
