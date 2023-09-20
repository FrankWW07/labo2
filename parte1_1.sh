# !/bin/bash

# este script se encarga de recibir como argumento un ID
# de un proceso, posterior se imprime los siguientes requisitos:
# a-) nombre del proceso
# b-) ID del proceso
# c-) parent process ID
# d-) usuario propietario
# e-) porcentaje de uso de CPU al momento de correr el script
# f-) consumo de memoria
# g-) estado
# h-) path del ejecutable


pid=$1

# se quiere primero verificar si el PID ingresado existe o no
if [ ! ps -p $pid &>/dev/null ]; then
        echo "El proceso con PID $pid digitado no existe."
        exit 1
fi



# por consiguiente obtener el nombre del PID
process_name=$(ps -o comm= -p $pid)


# imprimir el nombre del proceso
echo "Nombre del proceso: $process_name"

# imprimir el ID del proceso
echo "ID del proceso: $pid"



# se obtiene el PPID (PID del proceso padre)
ppid_ID=$(ps -o ppid= -p $pid)


# imprimir el PPID
echo "Parent process ID: $ppid_ID"



# se obtiene el nombre de usuario propietario del PID
user_name=$(ps -o user= -p $pid)


# imprimir el nombre de usuario propietario
echo "Usuario propietario: $user_name"



# se obtiene el porcentaje de uso de CPU del PID
cpu_percent=$(ps -o %cpu= -p $pid)

# imprimir el porcentaje de uso de CPU
echo "Porcentaje de uso (%CPU): $cpu_percent"



# se obtiene el consumo de memoria del PID
memory_usage=$(ps -o rss= -p $pid)

# imprimir el consumo de memoria
echo "Consumo de memoria: $memory_usage kilobytes."



# se obtiene el estado del proceso PID
process_state=$(ps -o state= -p $pid)


# imprimir el estado del proceso
case "$process_state" in

        R)
                echo "Estado del proceso: $process_state 'Running' (en ejecucion)."
                ;;
        S)
                echo "Estado del proceso: $process_state 'Sleeping' (suenio interrumpible)."
                ;;
        D)
                echo "Estado del proceso: $process_state 'Uninterruptible Sleep' (suenio ininterrumpible)."
                ;;
        Z)
                echo "Estado del proceso: $process_state 'Zombie' (modo zombie)."
                ;;
        T)
                echo "Estado del proceso: $process_state 'Stopped' (detenido o suspendido)."
                ;;
        *)
                ;;
esac


# se obtiene la ruta del ejecutable del proceso
executable_path=$(readlink /proc/$pid/exe)

# imprimir la ruta del ejecutable
echo "Ruta del ejecutabke: $executable_path"
