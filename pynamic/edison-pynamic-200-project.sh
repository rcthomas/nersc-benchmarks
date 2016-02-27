#!/bin/bash 
#SBATCH --account=mpccc
#SBATCH --job-name=edison-pynamic-200-project
#SBATCH --nodes=200
#SBATCH --ntasks-per-node=24
#SBATCH --output=slurm-edison-pynamic-200-project-%j.out
#SBATCH --partition=regular
#SBATCH --qos=premium
#SBATCH --time=00:30:00

# Load modules.

module swap PrgEnv-intel PrgEnv-gnu
module load python
module list

# Verbose debugging output.

set -x

# Path to Pynamic installation.

PYNAMIC_DIR=/project/projectdirs/mpccc/pynamic-workdir/edison

# Stage Pynamic to target filesystem.
# 
# PYNAMIC_SRC=/usr/common/usg/pynamic/pynamic-pyMPI-2.6a1
# mkdir -p $PYNAMIC_DIR
# cp -r $PYNAMIC_SRC/* $PYNAMIC_DIR/.

# Main benchmark run.

export LD_LIBRARY_PATH="$PYNAMIC_DIR:$LD_LIBRARY_PATH"
time srun $PYNAMIC_DIR/pynamic-pyMPI $PYNAMIC_DIR/pynamic_driver.py `date +"%s"`

# Debug run.

export LD_DEBUG=libs
time srun -n 1 $PYNAMIC_DIR/pynamic-pyMPI $PYNAMIC_DIR/pynamic_driver.py `date +"%s"`

# For usgweb.

if [ "$USER" == "fbench" ]; then
    touch $SCRATCH/Edison_Perf/Pynamic/$SLURM_JOB_ID
fi
