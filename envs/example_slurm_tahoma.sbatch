#!/bin/bash
#SBATCH -t 2:49:00
#SBATCH -N 1
#SBATCH -A emsla60288
#SBATCH -p analysis 
#SBATCH -o ddmd.output.%j
#SBATCH -e ddmd.output.%j
#SBATCH -J  ddmd
source /etc/profile.d/modules.sh
module purge
module load gcc
export https_proxy=http://proxy.emsl.pnl.gov:3128
export http_proxy=http://proxy.emsl.pnl.gov:3128
export DDMD_HOME=/tahoma/emsla60288/edo/ddmd-tahoma-changes
#cd /tahoma/emsla60288/edo/ddmd-tahoma-changes/examples
export LD_LIBRARY_PATH=/tahoma/emsla60288/edo/cuda-11.3/lib64:$LD_LIBRARY_PATH
rm -f /tmp/ddmd.sif
singularity pull -F --name /tmp/ddmd.sif oras://ghcr.io/edoapra/ddmd/ddmd_tahoma-changes:latest
singularity exec --nv --bind $DDMD_HOME:/mnt /tmp/ddmd.sif ddmd run_ddmd -c /mnt/examples/simple.yml
