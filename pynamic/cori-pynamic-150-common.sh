#!/bin/bash 
#SBATCH --account=mpccc
#SBATCH --job-name=cori-pynamic-150-common
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=rcthomas@lbl.gov
#SBATCH --nodes=150
#SBATCH --ntasks-per-node=32
#SBATCH --output=slurm-cori-pynamic-150-common-%j.out
#SBATCH --partition=regular
#SBATCH --qos=normal
#SBATCH --time=25

# Load modules.

module unload python
module unload altd
module swap PrgEnv-intel PrgEnv-gnu
module load python
module list

# Verbose debugging output.

set -x

# Stage Pynamic.

benchmark_path=/usr/common/software/pynamic/pynamic/pynamic-pyMPI-2.6a1
export LD_LIBRARY_PATH=$benchmark_path:$LD_LIBRARY_PATH

# Run benchmark.

time srun $benchmark_path/pynamic-pyMPI $benchmark_path/pynamic_driver.py $(date +%s)

# Debug run.

export LD_DEBUG=libs
time srun -n 1 $benchmark_path/pynamic-pyMPI $benchmark_path/pynamic_driver.py $(date +%s)

# For usgweb.

if [ "$USER" == "fbench" ]; then
    touch $SCRATCH/Cori_Perf/Pynamic/$SLURM_JOB_ID
fi
