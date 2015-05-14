#!/bin/bash

DEFAULT_PACKAGES="RDatasets Distributions SVM Clustering GLM \
Optim JuMP GLPKMathProgInterface Clp NLopt Ipopt \
ODE Sundials LinearLeastSquares \
BayesNets PGFPlots GraphLayout \
Stan Patchwork Quandl Lazy QuantEcon"

for pkg in ${DEFAULT_PACKAGES}
do
    echo ""
    echo "Adding default package $pkg"
    julia -e "Pkg.add(\"$pkg\")"
done

INTERNAL_PACKAGES="https://github.com/shashi/Homework.jl.git \
https://github.com/tanmaykm/JuliaWebAPI.jl"

for pkg in ${INTERNAL_PACKAGES}
do
    echo ""
    echo "Adding internal package $pkg"
    julia -e "Pkg.clone(\"$pkg\")"
done

julia -e "Pkg.checkout(\"Interact\")"

echo ""
echo "Creating package list..."
julia -e "Pkg.status()" > /.juliabox/packages.txt
