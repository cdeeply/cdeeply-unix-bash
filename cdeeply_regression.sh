#!/bin/bash

RC="columns"

importancesFile=""
outFile="myNN.html"

hasBias="on"
allowIO="on"

Wmax=""
Nmax=""
Lmax=""
LSmax=""

USAGE="usage: cdeeply_autoencoder [-rows -columns -no-bias -disallow-IO-connections] [-max-weights {N} -max-neurons {N} -max-layers {N} -max-layer-skips {N}] [-I {importances_table_file} -o {output_file}] table_file output_rows/cols\ne.g. cdeeply_autoencoder myFile.txt 5,7"

if [ $# -lt 2 ];  then
    echo -e $USAGE
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
        -no-bias)
            hasBias="off"
            ;;
        -disallow-IO-connections)
            allowIO="off"
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
            echo -e $USAGE
            exit 1
            ;;
    esac
    shift
    
    if [ $# -lt 2 ];  then
        echo -e $USAGE
        exit 1
    fi
done

if  [ $# -ne 2 ];  then
    echo -e $USAGE
    exit 1
fi

curl -X POST -L "https://cdeeply.com/myNN.php" -F csvOpen="@$1" -F importancesOpen="$importancesFile" -F rowscols="$RC" -F rowcolRange="$2" -F maxWeights="$Wmax" -F maxNeurons="$Nmax" -F maxLayers="$Lmax" -F maxSkips="$NSmax" -F hasBias="$hasBias" -F allowIO="$allowIO" -F submitStatus="Submit" -F NNtype="regressor" -o $outFile
