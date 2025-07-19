#!/bin/bash

RC="columns"

importancesFile=""
outFile="myNN.html"

hasBias="on"
allowNegativeWs="on"
sparseWs="off"
allowIO="on"

Wmax=""
Nmax=""
Lmax=""
Dmax=""
Ymax="1"

wHardLimit="on"
nHardLimit="on"
yHardLimit="on"

stepAF="on"
ReLUAF="on"
ReLU1AF="on"
sigmoidAF="on"
tanhAF="on"

quantizeW="off"
wQuantBits=""
wQuantZero=""
wQuantRange=""

quantizeY="off"
yQuantBits=""
yQuantZero=""
yQuantRange=""

USAGE="usage: bash cdeeply_regressor [-rows -columns -no-bias -no-negative-weights -sparse-weights -disallow-IO-connections] \
[-max-weights {N} -max-neurons {N} -max-layers {N} -max-weight-depth {N} -max-activation-rate {N}] \
[-max-weights-soft-limit -max-neurons-soft-limit -max-activations-soft-limit] \
[-no-step-AF -no-ReLU-AF -no-ReLU1-AF -no-sigmoid-AF -no-tanh-AF] [-quantize-weights {N N N} -quantize-activations {N N N} \
[-I {importances_table_file} -o {output_file}] table_file output_rows/cols\ne.g. cdeeply_autoencoder myFile.txt 5,7"

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
        -no-negative-weights)
            allowNegativeWs="off"
            ;;
        -sparse-weights)
            sparseWs="on"
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
        -max-weight-depth)
            Dmax=$2
            shift
            ;;
        -max-activation-rate)
            Ymax=$2
            shift
            ;;
        -max-weights-soft-limit)
            wHardLimit='off'
            ;;
        -max-neurons-soft-limit)
            nHardLimit='off'
            ;;
        -max-activations-soft-limit)
            yHardLimit='off'
            ;;
        -no-step-AF)
            stepAF='off'
            ;;
        -no-ReLU-AF)
            ReLUAF='off'
            ;;
        -no-ReLU1-AF)
            ReLU1AF='off'
            ;;
        -no-sigmoid-AF)
            sigmoidAF='off'
            ;;
        -no-tanh-AF)
            tanhAF='off'
            ;;
        -quantize-weights)
            quantizeW='on'
            wQuantBits=$2
            wQuantZero=$3
            wQuantRange=$4
            shift
            shift
            shift
            ;;
        -quantize-activations)
            quantizeY='on'
            yQuantBits=$2
            yQuantZero=$3
            yQuantRange=$4
            shift
            shift
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

curl -X POST -L "https://cdeeply.com/myNN.php" -F samples="@$1" -F importances="$importancesFile" -F rowscols="$RC" -F rowcolRange="$2" \
        -F maxWeights="$Wmax" -F maxNeurons="$Nmax" -F maxLayers="$Lmax" -F maxWeightDepth="$Dmax" -F maxActivationRate="$Ymax" \
        -F maxWeightsHardLimit="$wHardLimit" -F maxNeuronsHardLimit="$nHardLimit" -F maxActivationsHardLimit="$yHardLimit" \
        -F allowIO="$allowIO" -F hasBias="$hasBias" -F allowNegativeWeights="$allowNegativeWs" -F sparseWeights="$sparseWs" \
        -F step="$stepAF" -F ReLU="$ReLUAF" -F ReLU1="$ReLU1AF" -F sigmoid="$sigmoidAF" -F tanh="$tanhAF" \
        -F quantizeWeights="$quantizeW" -F wQuantBits="$wQuantBits" -F wQuantZero="$wQuantZero" -F wQuantRange="$wQuantRange" \
        -F quantizeActivations="$quantizeY" -F yQuantBits="$yQuantBits" -F yQuantZero="$yQuantZero" -F yQuantRange="$yQuantRange" \
        -F submitStatus="Submit" -F NNtype="regressor" -F formSource="Bash_API" -o $outFile
