#!/usr/bin/env bash

# update
sudo apt-get update

# Se genera una partición swap. Previene errores de falta de memoria
if [ ! -f "/swapdir/swapfile" ]; then
	sudo mkdir /swapdir
	cd /swapdir
	sudo dd if=/dev/zero of=/swapdir/swapfile bs=1024 count=2000000
	sudo mkswap -f  /swapdir/swapfile
	sudo chmod 600 /swapdir/swapfile
	sudo swapon swapfile
	echo "/swapdir/swapfile       none    swap    sw      0       0" | sudo tee -a /etc/fstab /etc/fstab
	sudo sysctl vm.swappiness=10
	echo vm.swappiness = 10 | sudo tee -a /etc/sysctl.conf
fi

# ruta raíz del servidor web
WEB_ROOT="/var/www"
# ruta de la aplicación
APP_PATH="$WEB_ROOT/devops-app"

# Se crea el directorio del sitio
sudo mkdir $WEB_ROOT
sudo mkdir $APP_PATH

# Se clona la aplicación del repo
cd $WEB_ROOT
sudo git clone https://github.com/sayale/devops-app-example.git devops-app
cd $APP_PATH
sudo git checkout run-docker

# Se instala docker 
if [ ! -x "$(command -v docker)" ]; then
	sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

	# Se configura el repositorio
	curl -fsSL "https://download.docker.com/linux/ubuntu/gpg" > /tmp/docker_gpg
	sudo apt-key add < /tmp/docker_gpg && sudo rm -f /tmp/docker_gpg
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

	# Se actualizan los paquetes con los nuevos repositorios
	sudo apt-get update -y

	# Se instala docker desde el repositorio oficial
	sudo apt-get install -y docker-ce docker-compose

	# Se configura el inicio de docker
	sudo systemctl enable docker
fi

# Se frenan y eliminan todos los containers, se eliminan las imagenes
sudo docker stop $(sudo docker ps -a -q)
sudo docker rm $(sudo docker ps -a -q)
sudo docker rmi $(sudo docker images -q)

# Se inicializan los contenedores
cd /vagrant/docker
sudo docker-compose up --build -d



