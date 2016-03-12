#! /bin/bash
#	Práctica 1 ASR: Agenda
#	Author: Sebastián Águila saguila@ucm.es

: '
		#----- NOTAS SOBRE ARRAYS -----#
	${array[*]} devuelve los elementos de un array
	${!array[*]} devuelve los indices del array
	${#array[*]}  devuelve el numero de items del array
	${#array[0]} devuelve la longitud del elemento 0
	se puede usar @ en lugar de @.
	  
	   #----- NOTAS SOBRE BUCLES FOR -----#
	for i in 1 2 3 4 5 | seq(...) | ${array[*]}
	for ((i=1;i < 4;i++))
	for {inicio..final..incrento}
		do
			command | command on $VARIABLE | on $OUTPUT
		done
	   
	   #----- NOTAS SOBRE COMPARADORES -----#
 Numeros: -eq = , -ne != , -gt > , -ge >= , -lt < , -le >= .
 String =  == igual , != no igual -z logitud mayor que 0(!= null) -n no nulo
'

#Funcion que muestra todos los registros formateados
function _listar(){
	#wc cuenta en numero de lineas que contiene el fichero.
	numEntradas=$(wc -l .bd | cut -d' ' -f1) # igualamos el resultado generado.
	echo -e '\t\tLISTADO ('$numEntradas' entradas)'
	
: '
	registros=$(cat .bd | cut  -d':' -f1,2,3 --output-delimiter=$' ')
	echo $registros
	
	#------------------------------------------------------------------#
		Ir metiendo en un array cada elemento que termine con :
			Cuando este creado mostrar esos elementos
	#------------------------------------------------------------------#

		for linea in $(cat .bd | cut  -d':' -f1,2,3 --output-delimiter=$' ');
				do
					array=(${linea})
					i=$i+1
			done
'
			
	# Guardamos en la variable resltado el resultado del comando.
	resultado=$(cat .bd | cut  -d':' -f1,2,3 --output-delimiter=$' ')
	
	j=0 # Contador de control.
	
		for i in $resultado; # Parecido a un for each
			do
				if [ $j -eq 0 ]; then
					echo -e 'Nombre: '$i
					j=1
					elif [ $j -eq 1 ]; then
					echo -e 'Telefono: '$i
					j=2
					elif [ $j -eq 2 ]; then
					echo -e 'Email:' $i'\n'
					j=0
				fi
			done
	
	: '
	# Ejemplo que hace lo mismo pero usando array explicitamente
	array=(${resultado}) #Convertimos el resultado en un array.
	for i in ${array[*]}; 
		do
			if [ $j -eq 0 ]; then
				echo -e 'Nombre: '$i
				j=1
				elif [ $j -eq 1 ]; then
				echo -e 'Telefono: '$i
				j=2
				elif [ $j -eq 2 ]; then
				echo -e 'Email:' $i '\n'
				j=0
			fi
		done
	'
}

#Funcion que busca un regisro por un patron aplicado a cualquier campo.
function _buscar(){
	echo -e '\t\tBUSQUEDA'
	read -p 'Nombre a buscar:' nombre
	registro=$(cat .bd  | grep ^$nombre | cut  -d':' -f1,2,3 --output-delimiter=$' ')
	# ${#registro} -- numero de caracteres que hemos recogido en la variable
	if [ ${#registro} -gt 0 ]; then
	j=0
	
		for i in $registro; # Parecido a un for each
			do
				if [ $j -eq 0 ]; then
					echo -e 'Nombre: '$i
					j=1
					elif [ $j -eq 1 ]; then
					echo -e 'Telefono: '$i
					j=2
					elif [ $j -eq 2 ]; then
					echo -e 'Email:' $i'\n'
					j=0
				fi
			done
	else
		echo -e 'nombre inexistente en agenda'
	fi
}


#Funcion que borrar un registro identificandolo por el nombre.
function _borrar(){
	echo -e '\t\tBORRAR\nNombre a borrar: \c'
	read nombre
	cat .bd | sed '/^[$nombre]/d' > aux #Guardamos el resultado en un fichero.
	mv aux .bd #Renombramos nuestra fichero actual como .bd.
}

#Añade un registro
function _añadir(){
	echo -e '\t\tAÑADIR'
	echo -e 'Nombre: \c' # Con \c evitamos que haga el salto de linea -
	read nombre			# antes del salto de linea que provoca echo.
	# Comprobar nombre duplicado
	resultado=$(cat .bd | grep ^$nombre)
	if [ ${#resultado} -eq 0 ]; then
		echo -e '\nTeléfono: \c'
		read telefono
		echo -e '\nMail: \c'
		read email
		echo -e $nombre:$telefono:$email >> .bd # .bd es un fichero que per-
											# manece oculto con los datos
	else
	echo -e 'Nombre de usuario ya existente'
	fi
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
				clear
				_$opc
				_mostrarMenu;;
			"buscar")
				clear
				_$opc
				_mostrarMenu;;
			"borrar")
				clear
				_$opc
				_mostrarMenu;;
			"añadir")
				clear
				_$opc
				_mostrarMenu;;
			"salir")
				exit 0 ;;
			*) # Cualquier otra cosa.
				echo -e 'opcion no valida';;
			esac
	done
}

# Ejecucion
_principal
