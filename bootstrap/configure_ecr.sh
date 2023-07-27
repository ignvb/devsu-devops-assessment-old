#!/bin/bash

# Definición de variables
name_repo=""

# Menu de ayuda
Help()
{
    echo "Script para crear repositorio en AWS ECR."
    echo
    echo "Syntax: configure_ecr [-n|h]"
    echo "opciones:"
    echo "  -h     Imprime la ayuda."
    echo "  -n     Nombre del repositorio a crear en AWS ECR"
    echo
}

# Recibir como argumento nombre del repositorio
while getopts ":n:h" arg;
do
    case $arg in
        n) # Recibe nombre de repositorio
            name_repo=${OPTARG};;
        h) # Retorna el menu de ayuda
            Help
            exit;;
        *) # Error por falta de parametro
            echo "Error: Argumento de parametro \"-$OPTARG\" no puede estar vacio"
            exit;;
        \?) # Opción invalida
            echo "Error: opción invalida"
            exit;;
    esac
done

# Revisar que name_repo tenga un nombre valido
if [[ -z "${name_repo}" ]]; then
    echo "Error: Parametro -n es obligatorio"
    exit
fi

# Crear repositorio en ECR y guardar el Arn

# Crear policy para el user con permisos restringidos

# Crear user y retornar el access_id y access_key para almacenarlos en Github
