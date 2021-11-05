#!/bin/bash

# sysinfo - Un script que informa del estado del sistema

##### Constantes

TITLE="Información del sistema para $HOSTNAME"
RIGHT_NOW=$(date +"%x %r%Z")
TIME_STAMP="Actualizada el $RIGHT_NOW por $USER"

##### Estilos

TEXT_BOLD=$(tput bold)
TEXT_GREEN=$(tput setaf 2)
TEXT_RESET=$(tput sgr0)
TEXT_ULINE=$(tput sgr 0 1)

#### Opciones por defecto

interactive=
filename=sysinfo.txt

##### Funciones

system_info(){
    echo -n "Función system_info: "
    echo "${TEXT_ULINE}Versión del sistema${TEXT_RESET}"
    echo
    uname -a
}

show_uptime(){
    echo -n "Función show_uptime: "
    echo "${TEXT_ULINE}Tiempo de encendido del sistema$TEXT_RESET"
    echo
    uptime
}

### Actividad 1
drive_space(){
    echo -n "Función drive_space: "
    df -h --output=used,target
}


#### Actividad 2
home_space(){
    echo -n "Funcion home_space: "
    if [ "$USER" == root ]; then
        du -s /home/*
    else
        du -s /home
    fi
}

usage(){
    echo "usage: sysinfo [-f filename] [-i] [-h]"
}

#### Un segundo usage por comodidad
helpmessage(){
    echo -n "Sysinfo parameters: "
    echo -n "-f: guardar informe en archivo de salida "
    echo -n "uso: sysinfo [-f filename] -> si no se declara un filename, se coge de forma predeterminada el fichero sysinfo.txt "
    echo -n "-i:   -> uso: sysinfo [-i] "
}

#### Programa princpal

write_page(){
    # El script-here se puede indentar dentro de la función si
    # se usan tabuladores y "<<-EOF" en lugar de "<<".
    cat << _EOF_
$TEXT_BOLD$TITLE$TEXT_RESET

$(system_info)
$(show_uptime)
$(drive_space)
$(home_space)

$TEXT_GREEN$TIME_STAMP$TEXT_RESET

_EOF_
}

# Procesar la línea de comandos del script para leer las opciones
while [ "$1" != "" ]; do
   case $1 in
        -f | --file )
            if [[ $2 =~ .*\.txt ]]; then
                shift
                filename=$1
            else 
                usage
                exit
            fi 
            ;;
        -i | --interactive )
            interactive=1
            ;;
        -h | --help )
            helpmessage
            usage
            exit
            ;;
        * )
            usage
            exit 1
    esac
    shift
done

if [ "$interactive" == 1 ]; then
    echo -n "Mostrar el informe del sistema en pantalla (S/N): "
    read alternative
    if [ "$alternative" == N ]; then 
        echo -n "Nombre del archivo? [~/sysinfo.txt]: "
        read namefile
        if [[ "$namefile" =~ .*\.txt ]]; then
            filename=$namefile
        fi
    elif [ "$alternative" == S ]; then
        write_page
    fi
    if test -e ~/$filename; then 
        echo -n "Existe el fichero de destino."
        echo -n "¿Sobreescribirlo? (S/N): "
        read SobreescribirYesOrNo
        if test "$SobreescribirYesOrNo" == S; then
            write_page > ~/filename
            exit
        elif test "$SobreescribirYesOrNo" == N; then
            exit
        fi
    fi
    touch ~/$filename
    write_page > ~/$filename    
else
write_page > $filename
fi

