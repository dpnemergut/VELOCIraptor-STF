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

# SLURM JOB details (Glamdring)
queue=berg
nmpi=28
memory=3

echo $isnap,$fsnap,$nsnaps

for ((j=$isnap; j<=$fsnap; j++))
do
    jj=`printf "%05d" $j`
    cp $paramfile $outdir/$simname.sn$jj.param;
    sed -i .old 's/Output=OUTNAME/Output='"$outdir"'/'"$simname"'.c'"$i"'.sn'"$jj"'/g' $outdir/$simname.sn$jj.param;
    sed -i .old 's/Snapshot_value=SNVALUE/Snapshot_value='"$j"'/g' $outdir/$simname.sn$jj.param;
    ifile=`printf "%s/output_%05d" $indir $j`
    # WARNING: this is just for Glamdring
    addqueue -c $jj -q $queue -n $nmpi -m $memory $stfexe -I 4 -i $ifile -t $jj -C $outdir/$simname.sn$jj.param > $outdir/$simname.sn$jj.log;
done

#######################################################################################
echo
echo "                       Finished, now closing script"
echo "############################################################################## "
echo "############################################################################## "
echo "############################################################################## "
echo
#######################################################################################