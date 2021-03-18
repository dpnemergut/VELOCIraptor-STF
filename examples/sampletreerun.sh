#!/bin/bash
##################################################################################
# VELOCIRAPTOR STRUCTURE FINDER FOR RAMSES COSMOLOGICAL HYDRO SIMULATION         #
#                                                                                #
# This is a sample script to show you how you could run structure search on      #
# multiple.                                                                      #
# WARNING: This has only being prepared for Glamdring!                           #
# By: F. Rodriguez Montero 16/03/2021                                            #
##################################################################################

echo "###########################################################################"
echo
echo "  VELOCIRAPTOR STRUCTURE FINDER FOR RAMSES COSMOLOGICAL HYDRO SIMULATION"
echo "                                                                      v0.1 "
echo "###########################################################################"

# Initial and final snapshot numbers
isnap=0
fsnap=100
nsnaps=`echo $isnap" "$fsnap|awk '{print $2-$1+1}'`

# Base config parameter file to use
paramfile=stf.base.param

# Model or simulation name
simname=lcdm

# Directory where simulation outputs are stored
indir=./

# Directory where VELOCIRAPTOR files will be saved
outdir=./

# Where the stf (VELOCIRAPTOR) executable is held
stfexe=${vrdir}/bin/stf

# Where the tree (TREEfrog) executable is held
treefrogexe=${treefrogdir}/bin/treefrog

# SLURM JOB details (Glamdring)
queue=berg
nmpi=28
memory=3

echo $isnap,$fsnap,$nsnaps

#treefrog commands

#largest particle ID value
Neff=1024
Nid=`echo $Neff | awk '{print $1^3.0}'`
#number of steps used when linking
numsteps=4
siglimit=0.1
#to make sure halo ids temporally unique, use this value times snapshot,
halotemporalidval=10000000000
#specify format, 0 ascii, 1 binary, 2 hdf5
ibinary=0
#specify no separate field and subhalo files
ifield=0
#number of input velociraptor files (set by number of mpi threads) per snapshot
numfiles=1

rm $outdir/halolist.txt
for ((j=$isnap; j<=$fsnap; j++))
do
    jj=`printf "%03d" $j`
    echo $outdir/$simname.sn$jj >> $outdir/halolist.txt
done
$treefrogexe -i $outdir/halolist.txt -s $nsnaps -N $numfiles -n $Nid -t $numsteps -h $halotemporalidval -B $ibinary -F $ifield -o $outdir/$simname.tree $outdir/tree.log

#######################################################################################
echo
echo "                       Finished, now closing script"
echo "############################################################################## "
echo "############################################################################## "
echo "############################################################################## "
echo
#######################################################################################