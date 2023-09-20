# !/bin/bash

# se verifica primero si el argumento recibido es un ejecutable
if [ $# -ne 1 ]; then
        echo "Por favor ingrese un ejecutable: $0 <ejecutable>"
        exit 1
fi


# nombre del ejecutable
executable=$1

# archivo creado en donde se va a escribir el registro de consumo del CPU y memoria
register_file="registro_consumo.txt"

# intervalo de tiempo en la que se va a registrar los datos
interval=1      # se modifica a su necesidad (en segundos)

# iniciar el proceso y obtener su PID
$executable &
pid=$!



# se crea un archivo de registro vacio para guardar los datos en formato tabla, para despues plotearlo
echo "Tiempo (s)  CPU (%)  Memoria (KB)" > $register_file

# funcion para registrar el consumo de CPU y memoria
register_consume() {
        while ps -p $pid &>/dev/null; do
                tiempo=$(date +%s)              # se guarda los valores de los segundos en ejecucion
                cpu=$(ps -p $pid -o %cpu=)      # se guarda los valores del porcentaje de CPU usado
                memoria=$(ps -p $pid -o rss=)   # se guarda los valores de memoria utilizada
                echo "$tiempo $cpu $memoria" >> $register_file
                                                # se escribe continuando el archivo con datos
                sleep $interval
        done
}

# se ejecuta la funcion de registrar el consumo
$register_consume &

# esperar a que el proceso termine de registrar
wait $pid


# generar un grafico con GNUplot
gnuplot << EOL
set xlabel "Tiempo (s)"
set ylabel "Consumo"
set title "Consumo de CPU y Memoria"
set terminal png
set output "grafico_consumo.png"
plot "$register_file" using 1:2 with lines title "CPU", "$register_file" using 1:3 with lines title "Memoria"
EOL

echo "Proceso terminado. EL grafico se encuentra disponible en grafico_consumo.png."
