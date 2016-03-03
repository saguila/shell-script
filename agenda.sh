#! /bin/bash
#	Práctica 1 ASR: Agenda
#	Author: Sebastián Águila ·saguila@ucm.es

#Funcion que muestra todos los registros formateados
function _listar(){
	echo -e 'listando'
}

#Funcion que busca un regisro por un patron aplicado a cualquier campo
function _buscar(){
	echo -e 'buscando'
}

#Funcion que borrar un registro identificandolo por el nombre
function _borrar(){
	echo -e 'borrar'
}

#Añade un registro
function _añadir(){
	echo -n 'Nombre: '
	read nombre
	echo -n '\nTeléfono: '
	read telefono
	echo -n '\nMail: '
	read email
	echo -e $nombre:$telefono:$email >> registros.bd
}

#Muestra por pantalla el menu
function _mostrarMenu(){
	echo -e '1) listar\n2) buscar\n3) borrar\n4) añadir\n5) salir'
#	echo -n '#? '
#	read opcion
#	return $opcion
}

# Funcion principal del script que hace usp de select y case para crear un menu.
function _principal(){
	opcion=("listar" "buscar" "borrar" "añadir" "salir") # Datos contenidos en la variable opcion.
	select opc in ${opcion[@]} # En opc se guarda lo que esta en la posicion del numero que introducimos
		do		# en el array opcion.
		case $opc in #opc llevara el valor contenido en la posicion del vector del numero introducido.
			"listar")
				_$opc
				clear
				_mostrarMenu;;
			"buscar")
				_$opc
				clear
				_mostrarMenu;;
			"borrar")
				_$opc
				clear
				_mostrarMenu;;
			"añadir")
				_$opc
				clear
				_mostrarMenu;;
			"salir")
				exit 0 ;;
			*) # Cualquier otra cosa.
				echo -e 'opcion no valida';;
			esac
	done
}

#Esquema de un for
#for i in $(seq 1 $1); 
	#do
	#done

_principal
