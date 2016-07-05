#!/bin/bash

echo ""
echo "Updating METADATA..."
julia -e "Pkg.update()"

DEFAULT_PACKAGES="HDFS Logging StatsBase DistributedArrays Elly"

for pkg in ${DEFAULT_PACKAGES}
do
    echo ""
    echo "Adding default package $pkg"
    julia -e "Pkg.add(\"$pkg\")"
done
