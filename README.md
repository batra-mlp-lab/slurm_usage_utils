# slurm_usage_utils
Helpful functions for tracking GPU/CPU usage in SLURM managed clusters.

## Installation

Clone the repository to your home directory or otherwise.

Add the following lines to your `.bashrc`, change the location of the `.gpus_users.bashrc` file based on where you cloned the repository. The paths to each `.awk` file in `gpus_users.bashrc` will also have to be modified if a different clone directory is chosen.

```
if [ -f ~/slurm_usage_utils/gpus_users.bashrc ]; then
    . ~/slurm_usage_utils/gpus_users.bashrc
fi
```

Reload your `.bashrc` with `source ~/.bashrc`.

## Usage

The following commands are currently supported
```
# Summary of GPU/CPU usage
gpus_users
gpus_users -q
gpus_users -v

# Summary of node usage
node_usage
```
