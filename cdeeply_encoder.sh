#!/bin/bash

RC="rows"
doE="on"
doD="on"

importancesFile=""
outFile="myNN.html"

numVPs="0"
variationalDist="normal"
hasBias="on"

Wmax=""
Nmax=""
Lmax=""
LSmax=""

USAGE="usage: bash cdeeply_encoder [-rows -columns -uniform-dist -normal-dist -no-bias] [-no-encoder | -no-decoder] [-max-weights {N} -max-neurons {N} -max-layers {N} -max-layer-skips {N}] [-I {importances_table_file} -o {output_file}] table_file num_features [num_variational_features]"

if [ $# -lt 2 ];  then
    echo $USAGE
    exit 1
fi

while [ ${1:0:1} = "-" ]; do
    case "$1" in
        -I)
            importancesFile="@$2"
            shift
            ;;
        -rows)
            RC="rows"
            ;;
        -columns)
            RC="columns"
            ;;
        -no-encoder)
            doE='off'
            ;;
        -no-decoder)
            doD='off'
            ;;
        -normal-dist)
            variationalDist="normal"
            ;;
        -uniform-dist)
            variationalDist="uniform"
            ;;
        -no-bias)
            hasBias="off"
            ;;
        -max-weights)
            Wmax=$2
            shift
            ;;
        -max-neurons)
            Nmax=$2
            shift
            ;;
        -max-layers)
            Lmax=$2
            shift
            ;;
        -max-layer-skips)
            LSmax=$2
            shift
            ;;
        -o)
            outFile=$2
            shift
            ;;
        *)
            echo $USAGE
            exit 1
            ;;
    esac
    shift
    
    if [ $# -lt 2 ];  then
        echo $USAGE
        exit 1
    fi
done

if [ $doE = "off" -a $doD = "off" ];  then
    echo "Error:  must generate at least an encoder or a decoder"
    exit 1
fi

if [ $# -eq 3 ];  then
    numVPs=$3
else
    if  [ $# -ne 2 ];  then
        echo $USAGE
        exit 1
    fi
fi

curl -X POST -L "https://cdeeply.com/myNN.php" -F csvOpen="@$1" -F importancesOpen="$importancesFile" -F rowscols="$RC" -F numFeatures="$2" -F doEncoder="$doE" -F doDecoder="$doD" -F numVPs="$numVPs" -F variationalDist="$variationalDist" -F maxWeights="$Wmax" -F maxNeurons="$Nmax" -F maxLayers="$Lmax" -F maxSkips="$NSmax" -F hasBias="$hasBias" -F submitStatus="Submit" -F NNtype="autoencoder" -F formSource="Bash_API" -o $outFile
