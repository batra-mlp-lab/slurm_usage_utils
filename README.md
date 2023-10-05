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

In the following files, change the `@include mycolors.awk` line so that it has the absolute path of your `mycolors.awk` file from this repository:
```
lab_usage.awk
lab_usage_qos.awk
lab_usage_verbose.awk
node_usage.awk
gpu_types_usage.awk
gpu_types_usage_verbose.awk
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

Any of the gpu_users command can be followed up with a lab (e.g. cvmlp, rehg, hoffman, etc.) to filter for the usage only in that lab, i.e.

```
gpus_users --cvmlp
gpus_users -q --cvmlp
gpus_users -v --cvmlp
```
