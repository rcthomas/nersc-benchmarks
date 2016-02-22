#!/bin/bash 
#SBATCH --account=mpccc
#SBATCH --job-name=cori-pynamic-150-datawarp
#SBATCH --nodes=150
#SBATCH --ntasks-per-node=32
#SBATCH --output=slurm-cori-pynamic-150-datawarp-%j.out
#SBATCH --partition=regular
#SBATCH --qos=premium
#SBATCH --time=00:30:00
#DW jobdw capacity=800GB access_mode=striped type=scratch

# Load modules.

module swap PrgEnv-intel PrgEnv-gnu
module load python
module list

# Verbose debugging output.

set -x

# Stage Pynamic to target filesystem.

PYNAMIC_SRC=/usr/common/software/pynamic/pynamic/pynamic-pyMPI-2.6a1
PYNAMIC_DIR=$DW_JOB_STRIPED
cp -r $PYNAMIC_SRC/* $PYNAMIC_DIR/.

# Main benchmark run.

export LD_LIBRARY_PATH="$PYNAMIC_DIR:$LD_LIBRARY_PATH"
time srun $PYNAMIC_DIR/pynamic-pyMPI $PYNAMIC_DIR/pynamic_driver.py `date +"%s"`

# Debug run.

export LD_DEBUG=libs
time srun -n 1 $PYNAMIC_DIR/pynamic-pyMPI $PYNAMIC_DIR/pynamic_driver.py `date +"%s"`

# For usgweb.

if [ "$USER" == "fbench" ]; then
    touch $SCRATCH/Cori_Perf/Pynamic/$SLURM_JOB_ID
fi
