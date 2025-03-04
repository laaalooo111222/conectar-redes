#!/bin/bash

#para mostrar las interfaces
echo "interfaces de red"
ip a

#para activar/desactivar interfaces
echo "pon el nombre de la interfaz a editar"
read interfaz
echo "activar (up) o desactivar (down)?"
read estado
sudo ip link set $interfaz $estado
echo "la interfaz" $interfaz "ahora esta" $estado

#para conectarse
echo "conectarse de manera inalambrica (w) o cableada (c)?"
read eleccion
if [ $eleccion = "w" ]; then
	echo "redes wifi"
	sudo iwlist $interfaz scan | grep 'ESSID'
	echo "pon el nombre de la red"
	read nombre
	echo "pon la contraseña de la red"
	read contrasena
	wpa_passphrase "$nombre" "$contrasena" | sudo tee /etc/wpa_supplicant.conf
	sudo wpa_supplicant -B -i $interfaz -c /etc/wpa_supplicant.conf
else
	sudo ip link set $interfaz up
	echo "conexion hecha"
fi

#configuracion ip
echo "configurar con dhcp (d) o ip fija (f)?"
read eleccion2
if [ $eleccion2 = "d" ]; then
	sudo dhclient $interfaz
else
	echo "pon la ip"
	read direccion
	echo "pon la mascara"
	read mascara
	echo "pon la puerta de enlace"
	read puerta
	sudo ip addr add $direccion/$mascara dev $interfaz
	sudo ip route add default via $puerta
fi
