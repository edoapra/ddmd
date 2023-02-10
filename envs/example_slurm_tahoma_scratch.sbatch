#!/bin/bash
#SBATCH -t 47:49:00
#SBATCH -N 1
#SBATCH -A emsla60288
#SBATCH -p analysis 
#SBATCH -o ddmd.output.%j
#SBATCH -e ddmd.output.%j
#SBATCH -J  ddmd
source /etc/profile.d/modules.sh
module purge
module load gcc
export DDMD_HOME=/big_scratch/ddmd
export https_proxy=http://proxy.emsl.pnl.gov:3128
export http_proxy=http://proxy.emsl.pnl.gov:3128
export INPUT=mytest.yml
export ORGDIR=`pwd`
export OUTDIR=`pwd`/out.$SLURM_JOBID
mkdir -p $OUTDIR
cd /big_scratch
wget -q  https://github.com/edoapra/ddmd/tarball/tahoma-changes -O - | tar -xz
mv *-ddmd-* ddmd
cd ddmd
#rm -f ddmd.sif || true
#singularity pull -F --name ddmd.sif oras://ghcr.io/edoapra/ddmd/ddmd:latest
cp $ORGDIR/mytest.yml examples/input.yml
singularity exec --nv  \
--bind /big_scratch:/big_scratch \
--bind $DDMD_HOME:/mnt \
oras://ghcr.io/edoapra/ddmd/ddmd:latest ddmd run_ddmd -c examples/input.yml &
pid=$!
echo pid is $pid
while :
do
    if [ `ps -ef | grep "$oldpid" | grep -v "grep" | wc -l` == 0 ]; then  break; fi
    sleep 5m
    rsync -aq  test  $OUTDIR/.
done
ls -lart
rsync -av  test  $OUTDIR/.


# ./ddmd.sif ddmd run_ddmd -c /mnt/examples/simple.yml
