# Imagen base
FROM php:7.4-apache

# Paquetes
RUN apt-get update && apt-get install -y libmcrypt-dev git
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli 