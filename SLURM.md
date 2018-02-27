# SLURM or working with hpc machines

Log in with username and password. You will not see anything happen as you type your password (does not indicate how many letters you've typed in). 

```
$ # 
$ ssh username@scinet-login.
$ ssh username@whereever.place
```

Copy a file to server. You will need to have either the origin server or the destination server. Might be easier to use the destination servier

```
$ scp sendingfile.txt uesrname@scinet-login:folder/.
```

SLURM Job

```
#!/bin/bash
#SBATCH --job-name=raxml_cob
#SBATCH -p medium
#SBATCH -N 1
#SBATCH -n 40
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --mail-user=jennifer.chang@ars.usda.gov
#SBATCH -t 168:00:00
#SBATCH -o "stdout.%j.%N"
#SBATCH -e "stderr.%j.%N"

#module load iq_tree
module load raxml
alias raxmlHPC='raxmlHPC-PTHREADS-SSE3 -T2'

date
#iqtree-omp -nt 40 -s $INPUT -m TEST -bb 1000 -alrt 1000 > ${INPUT}.log1.txt
mafft --auto --phylipout data/cob_nt.fasta
raxmlHPC -m GTRGAMMA -p 12345 -s cob_nt_aln.phy -# 100 -n nt
date
# End of file
```

Submit a job

```
$ sbatch slurm_script.sh
```

Check your jobs

```
$ squeue -u username     # your jobs
$ squeue |less           # all jobs
$ squeue -t RUNNING      # Running jobs
$ squeue -t PENDING      # Pending jobs
$ scancel jobid          # Cancel your job
```