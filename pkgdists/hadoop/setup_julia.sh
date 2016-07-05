#!/bin/bash

echo ""
echo "Updating METADATA..."
julia -e "Pkg.update()"

DEFAULT_PACKAGES="HDFS Logging StatsBase DistributedArrays Blocks Elly"

for pkg in ${DEFAULT_PACKAGES}
do
    echo ""
    echo "Adding default package $pkg"
    julia -e "Pkg.add(\"$pkg\")"
done

INTERNAL_PACKAGES="https://github.com/danielsuo/Crypto.jl.git \
https://github.com/tanmaykm/HadoopBlocks.jl.git"

for pkg in ${INTERNAL_PACKAGES}
do
    echo ""
    echo "Adding internal package $pkg"
    julia -e "Pkg.clone(\"$pkg\")"
done

REBUILD_PACKAGES="Crypto Elly"

for pkg in ${REBUILD_PACKAGES}
do
    echo ""
    echo "Building package $pkg"
    julia -e "Pkg.build(\"$pkg\")"
done
