# !/bin/bash

# verificar si se proporcionaron los argumentos indicados
if [ $# -ne 2 ]; then
        echo "Uso: $0 <nombre_del_proceso> <comando_para_iniciar>"
        exit 1
fi



# obtener el nombre del proceso y el comando para iniciar
process_name=$1
star_command=$2



# verificar si el proceso esta o no en ejecucion
if  pgrep -x "$process_name" > /dev/null ; then
        echo "El proceso $process_name ya esta en ejecucion."
else
        # si el proceso no esta en ejecucion, reiniciarlo
        $start_command &
        echo "Iniciando el proceso $process_name con el comando: '$2' "
fi



# funcion para verificar y ver si reinicia el proceso
check_and_restart()
{
        if  ! pgrep -x "$process_name" > /dev/null ; then
                echo "El proceso $process_name no esta en ejecucion. Reiniciando..."
                $start_command &
        fi
}

# intervalo de tiempo para verificar el estado (si esta aun en ejecucion o no)
interval=10     # tiempo ajustable


# estara en bucle infinito para monitorear y reiniciar el proceso
while true; do
        check_and_restart
        sleep $interval
done
