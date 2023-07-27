#!/bin/bash

# Definición de variables
name_repo="" 
aws_region="us-east-1" #Virginia por defecto
ecrRepoArn=""
ecrRepoUri=""

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
rawECRcreate=$(aws ecr create-repository --region ${aws_region} --repository-name ${name_repo} --no-cli-pager)
ecrRepoArn=$(jq '.repository.repositoryArn' <<< ${rawECRcreate}) # Parseando Arn
ecrRepoUri=$(jq '.repository.repositoryUri' <<< ${rawECRcreate}) # Parseando Uri

# Valida que ecrRepoArn y ecrRepoUri existan para continuar
if [[ -z "${ecrRepoArn}" ]]; then
    echo "Error aws ecr create-repository: No se obtuvo el valor repositoryArn"
    exit
elif [[ -z "${ecrRepoUri}" ]]; then
    echo "Error aws ecr create-repository: No se obtuvo el valor repositoryUri"
    exit
fi

# Crear policy para el user con permisos restringidos

# Crear user y retornar el access_id y access_key para almacenarlos en Github
