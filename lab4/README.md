# Lab #4: Maximum Likelihood

## Install RAxML

Fetch the latest RAxML codebase from github and make the executable. There are many parallel versions of RAxML

```
$ git clone https://github.com/stamatak/standard-RAxML.git
$ cd standard-RAxML
$ make -f Makefile.PTHREADS.gcc
$ ls -ltr
...
-rw-r--r--   1 jenchang  staff   2.1K Feb 20 09:11 mem_alloc.o
-rw-r--r--   1 jenchang  staff   4.8K Feb 20 09:11 eigen.o
-rwxr-xr-x   1 jenchang  staff   928K Feb 20 09:11 raxmlHPC-PTHREADS
```

## Likelihood analysis using RAxML



## Part1: Using RAxML on a local computer (or on the HPC-class in an interactive mode)

Fetch our dataset.

```
$ wget http://sco.h-its.org/exelixis/resource/download/hands-on/Hands-On.tar.bz2
$ tar -xjvf Hands-On.tar.bz2
```

RAxML versions installed on HPC but with long and ugly names (raxmlHPC-MPI-AVX, raxmlHPC-PTHREADS-AVX, raxmlHPC-PTHREADS-SSE3). To make our life easier, we'll create an alias for one of them: 

```
$ alias raxmlHPC='raxmlHPC-PTHREADS-SSE3 -T2'
$ raxmlHPC -h
```

In general, four arguments are required: 

-s your input sequence file  
-n your output file name  
-m the substitution model  
-p random number  

Now go to the [tutorial](https://sco.h-its.org/exelixis/web/software/raxml/hands_on.html) webpage and complete steps 3-10 (but skip step #8).

Getting started by running a RAxML command...

Binary data, gamma model. The -n T1 is arbitrary so the different runs do not overwrite each other.

```
$ ./raxmlHPC -T2 -m BINGAMMA -p 12345 -s Hands-On/binary.phy -n T1
```

CAT = memory and time efficient approximation for the standard GAMMA

``` 
$ ./raxmlHPC -m BINCAT -p 12345 -s Hands-On/binary.phy -n T2
```

`-p 12345` provides a set random seed so you'll get the same tree each time.

```
$ ./raxmlHPC -m BINGAMMA -p 12345 -s Hands-On/binary.phy -n T3  
```

Can also pass a starting tree. (the starting tree is not in H

```
./raxmlHPC -m BINGAMMA -t startingTree.txt -s binary.phy -n T4
```




## Part 2: ML analysis using RaxML on the hpc-class cluster
We have already used [hpc-class](https://www.hpc.iastate.edu/guides/classroom-hpc-cluster) cluster interactively in previous labs. Here we will learn how to submit and mange jobs using **Slurm Workload manager**. The two advantages of using this manager is that you can run your program for a longer time (up to several days) and can use multiple processors.

### 1) Steps in Slurm job creation, submittal, monitoring, and job deletion if necessary.
#### Access and Login
You should already know how to access the cluster and how to transfer files to/from it. Here is a [reminder](https://www.hpc.iastate.edu/guides/classroom-hpc-cluster/access-and-login).

#### Managing jobs using Slurm Workload manager
On HPC clusters computations should be performed on the compute nodes. Special programs called resource managers, workload managers or job schedulers are used to allocate processors and memory on compute nodes to users’ jobs.  On hpc-class the Slurm Workload Manager is used for this purpose.  Jobs can be run in interactive and batch modes.  When executing/debugging short-running jobs using small numbers of MPI processes, interactive execution instead of batch execution may speed up the program development.  

To start an **interactive** session, issue: `salloc`.  
Your environment, such as loaded environment modules, will be copied to the interactive session.

When running longer jobs, the batch mode should be used instead.  In this case a job script should be created and submitted into queue by issuing: `sbatch <job_script>`. We will create a job script in the next section.
 
In Slurm queues are called partitions. Only partitions for [accelerator nodes](https://www.hpc.iastate.edu/guides/classroom-hpc-cluster/accelerator-nodes) need to be specified when submitting jobs. Otherwise Slurm will submit job into a partition based on the number of nodes and time requested.

* To see the list of available partitions, issue: `sinfo`
* For more details on partitions limits, issue: `scontrol show partitions`
* To see the job queue, issue: `squeue`
* To cancel job <job_id>, issue: `scancel <job_id>`

#### Slurm Job Script Generator
The easiest way to create an Slurm job script is to use the [Slurm job script generator](https://www.hpc.iastate.edu/guides/classroom-hpc-cluster/slurm-job-script-generator). 
Choose the number of compute nodes, number of processor cores per node, maximum time the job may run. **Read instructions in red while choosing these numbers**. After your are done with the settings, copy the job script from the gray area and paste it in a local file.  Add commands for loading modules and running the programs at the bottom of the script.

#### Submitting your job
To submit the PBS script in the file myjob use the `sbatch <job_script>` command.  You may submit several jobs in succession if they use different output files. Jobs will be scheduled for queues based on the resources requested. There are limits on each queue regarding the maximum number of simultaneous jobs and maximum number of processors that may be used by one user or class. 

### 2) Running RaxML using the PBS
> Create a Slurm script to re-run several commands you used in Part 1 of this tutorial. Do not forget to include the command for loading the RaxML module and the alias we created if you want to use the shorter name of the program.  Submit the script to the Slurm Workload manager and check the status of your job.  If you checked the appropriate boxes in the Sript writer, you'll get an email when the job starts/finishes.  


### 3) Running a parallelized version of RaxML
One reason RAxML is so popular is that it offers different levels of parallelization (a fine-grain parallelization of the likelihood function for multi-core systems via the PThreads-based version and a coarse-grain parallelization of independent tree searches via MPI (Message Passing Interface)). It also uses optimized SSE3 and AVX vector intrinsics to accelerate calculations. Hence, different flavors of the compiled program: raxmlHPC-MPI-AVX, raxmlHPC-PTHREADS-AVX, raxmlHPC-PTHREADS-SSE3.

> Try raxmlHPC-PTHREADS-AVX and raxmlHPC-PTHREADS-SSE3 versions of the program on the cob_nt.fasta dataset we used last time.  Which one was faster?  
> Try using the MPI version of the program to do a bootstrap analysis. The raxmlHPC-MPI-AVX program that comes with the module did not work for me. So I recompiled the program without vector acceleration. You have to use `mpirun -np 16 <your_program>` to run an MPI program.  In our case, `mpirun -np 16 /shared/class/eeob563/raxml/standard-RAxML/raxmlHPC-MPI ...`
