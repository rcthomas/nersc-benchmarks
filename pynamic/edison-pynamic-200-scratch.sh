#!/bin/bash 
#SBATCH --account=mpccc
#SBATCH --job-name=edison-pynamic-200-scratch
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=rcthomas@lbl.gov
#SBATCH --nodes=200
#SBATCH --ntasks-per-node=24
#SBATCH --output=slurm-edison-pynamic-200-scratch-%j.out
#SBATCH --partition=regular
#SBATCH --qos=normal
#SBATCH --time=45

# Load modules.

module unload python
module unload altd
module swap PrgEnv-intel PrgEnv-gnu
module load python
module list

# Verbose debugging output.

set -x

# Stage Pynamic.

benchmark_src=/usr/common/usg/pynamic/pynamic-pyMPI-2.6a1
benchmark_dest=$SCRATCH/staged-pynamic
benchmark_path=$benchmark_dest/pynamic-pyMPI-2.6a1

mkdir -p $benchmark_dest
time rsync -az $benchmark_src $benchmark_dest
export LD_LIBRARY_PATH=$benchmark_path:$LD_LIBRARY_PATH

# Run benchmark.

time srun $benchmark_path/pynamic-pyMPI $benchmark_path/pynamic_driver.py $(date +%s)

# Debug run.

export LD_DEBUG=libs
time srun -n 1 $benchmark_path/pynamic-pyMPI $benchmark_path/pynamic_driver.py $(date +%s)

# For usgweb.

if [ "$USER" == "fbench" ]; then
    touch $SCRATCH/Edison_Perf/Pynamic/$SLURM_JOB_ID
fi
