#!/bin/bash

RC="rows"
doE="on"
doD="on"

importancesFile=""
outFile="myNN.html"

numVPs="0"
variationalDist="normal"
hasBias="on"
allowNegativeWs="on"
sparseWs="off"

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

USAGE="usage: bash cdeeply_encoder [-rows -columns -uniform-dist -normal-dist -no-bias -no-negative-weights -sparse-weights] [-no-encoder | -no-decoder] \
[-max-weights {N} -max-neurons {N} -max-layers {N} -max-weight-depth {N} -max-activation-rate {N}] \
[-max-weights-soft-limit -max-neurons-soft-limit -max-activations-soft-limit] \
[-no-step-AF -no-ReLU-AF -no-ReLU1-AF -no-sigmoid-AF -no-tanh-AF] ['-quantize-weights {N N N} -quantize-activations {N N N} \
[-I {importances_table_file} -o {output_file}] table_file num_features [num_variational_features]"

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
        -no-negative-weights)
            allowNegativeWs="off"
            ;;
        -sparse-weights)
            sparseWs="on"
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

curl -X POST -L "https://cdeeply.com/myNN.php" -F samples="@$1" -F importances="$importancesFile" -F rowscols="$RC" \
        -F numFeatures="$2" -F doEncoder="$doE" -F doDecoder="$doD" -F numVPs="$numVPs" -F variationalDist="$variationalDist" \
        -F maxWeights="$Wmax" -F maxNeurons="$Nmax" -F maxLayers="$Lmax" -F maxWeightDepth="$Dmax" -F maxActivationRate="$Ymax" \
        -F maxWeightsHardLimit="$wHardLimit" -F maxNeuronsHardLimit="$nHardLimit" -F maxActivationsHardLimit="$yHardLimit" \
        -F hasBias="$hasBias" -F allowNegativeWeights="$allowNegativeWs" -F sparseWeights="$sparseWs" \
        -F step="$stepAF" -F ReLU="$ReLUAF" -F ReLU1="$ReLU1AF" -F sigmoid="$sigmoidAF" -F tanh="$tanhAF" \
        -F quantizeWeights="$quantizeW" -F wQuantBits="$wQuantBits" -F wQuantZero="$wQuantZero" -F wQuantRange="$wQuantRange" \
        -F quantizeActivations="$quantizeY" -F yQuantBits="$yQuantBits" -F yQuantZero="$yQuantZero" -F yQuantRange="$yQuantRange" \
        -F submitStatus="Submit" -F NNtype="autoencoder" -F formSource="Bash_API" -o $outFile
