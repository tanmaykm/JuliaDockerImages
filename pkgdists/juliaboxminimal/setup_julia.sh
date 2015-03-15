#!/bin/bash

DEFAULT_PACKAGES="IJulia PyPlot SIUnits Gadfly DataStructures HDF5 MAT \
Iterators NumericExtensions SymPy Interact Roots \
Cairo GraphViz DataFrames Images ImageView WAV"

for pkg in ${DEFAULT_PACKAGES}
do
    echo ""
    echo "Adding default package $pkg"
    julia -e "Pkg.add(\"$pkg\")"
done

echo ""
echo "Creating package list..."
julia -e "Pkg.status()" > /.juliabox/packages.txt
