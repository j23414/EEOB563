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

### Step 3: Getting started

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

Can also pass a starting tree. (the starting tree is not in Hands-On folder, do not run).

```
$ cp RAxML_bestTree.T2 staringTree.txt
$ ./raxmlHPC -m BINGAMMA -t startingTree.txt -s Hands-On/binary.phy -n T4
```

Conduct multiple searches for the best tree. (20 ML searches on 20 randomized stepwise addition parsimony tree.)

```
$ ./raxmlHPC -m BINGAMMA -p 12345 -s Hands-On/binary.phy -# 20 -n T5 
```

DNA and protein data.

```
$ ./raxmlHPC -m GTRGAMMA -p 12345 -s Hands-On/dna.phy -# 20 -n T6 
$ ./raxmlHPC -m PROTGAMMAWAG -p 12345 -s Hands-On/protein.phy -# 20 -n T7
```

Standard models for protein data.

```
DAYHOFF, DCMUT, JTT, MTREV, WAG, RTREV, CPREV, VT, BLOSUM62, MTMAM, LG
```

```
$ ./raxmlHPC -m PROTGAMMAJTTF -p 12345 -s Hands-On/protein.phy -n T8
$ ./raxmlHPC -m PROTCATJTTF -p 12345 -s Hands-On/protein.phy -n T9
```

Note that, in more recent RAxML versions the best protein model with respect to the likelihood on a fixed, reasonable tree can also be automatically determined directly by RAxML using the following commad: 

```
$ ./raxmlHPC -p 12345 -m PROTGAMMAAUTO -s Hands-On/protein.phy -n AUTO
```

It is also possible to estimate a GTR model for protein data, but this should not really be used on small datasets because there is not enough data to estimate all 189 rates in the matrix: 

```
$ ./raxmlHPC -p 12345 -m PROTGAMMAGTR -s Hands-On/protein.phy -n GTR
```

Here is the command to conduct a ML search on multi-state morphological datasets: 

```
$ ./raxmlHPC -p 12345 -m MULTIGAMMA -s  Hands-On/multiState.phy -n T10 
```

There are different models available for multi-state characters that can be specified via -K ORDERED|MK|GTR, the default is GTR so we just executed a multi-state inference under the GTR model, for MK we can execute 

```
$ ./raxmlHPC -p 12345 -m MULTIGAMMA -s  Hands-On/multiState.phy -K MK -n T11 
```

and for ordered states 

```
$ ./raxmlHPC -p 12345 -m MULTIGAMMA -s  Hands-On/multiState.phy -K ORDERED -n T12
```

### Step 4: Bootstrap

Let's find the best-scoring ML tree for a DNA alignment. 

```
$ ./raxmlHPC -m GTRGAMMA -p 12345 -# 20 -s Hands-On/dna.phy -n T13 
```

This command will generate 20 ML trees on distinct starting trees and also print the tree with the best likelihood to a file called RAxML_bestTree.T13. 

Now we will want to get support values for this tree, so let's conduct a bootstrap search (number of bootstrap replicates=100). 

```
$ ./raxmlHPC -m GTRGAMMA -p 12345 -b 12345 -# 100 -s Hands-On/dna.phy -n T14 
```
Note that, RAxML also allows for automatically determining a sufficient number of bootstrap replicates, in this case you would replace `-# 100` by one of the bootstrap convergence criteria `-# autoFC`, `-# autoMRE`, `-# autoMR`, `-# autoMRE_IGN`.

Having computed the bootstrap replicate trees that will be printed to a file called RAxML_bootstrap.T14 we can now use them to draw bipartitions on the best ML tree as follows: 

```
$ ./raxmlHPC -m GTRCAT -p 12345 -f b -t RAxML_bestTree.T13 -z RAxML_bootstrap.T14 -n T15
```
 
This call will produce to output files that can be visualized with Dendroscope:  

* RAxML_bipartitions.T15--- support values assigned to nodes
* RAxML_bipartitionsBranchLabels.T15---support values assigned to branches of the tree

Note that, for unrooted trees the correct representation is actually the one with support values assigned to branches and not nodes of the tree!

We can also use the Bootstrap replicates to build consensus trees, RAxML supports strict, majority rule, and extended majority rule consenus trees:
strict consensus:            

```
$ # Strict Consensus
$ ./raxmlHPC -m GTRCAT -J STRICT -z RAxML_bootstrap.T14 -n T16
$
$ # Majority Rule
$ ./raxmlHPC -m GTRCAT -J MR -z RAxML_bootstrap.T14 -n T17
$ 
$ # Extended majority rule
$ ./raxmlHPC -m GTRCAT -J MRE -z RAxML_bootstrap.T14 -n T18
```

### Step 5: 

Because bootstrapping is very compute intensive, RAxML also offers a rapid bootstrapping algorithm that is one order of magnitude faster than the standard algorithm discussed above. To invoke it type, e.g.,: 

```
$ ./raxmlHPC -m GTRGAMMA -p 12345 -x 12345 -# 100 -s Hands-On/dna.phy -n T19 
```

so the only difference here is that you use `-x` instead of `-b` to provide a bootstrap random number seed. Otherwise you can also chose different models of substitution and also use the bootstrap convergence criteria with rapid bootstrapping as well. 

The nice thing about rapid bootstrapping is that it allows you to do a complete analysis (ML search + Bootstrapping) in one single step by typing

```
$ ./raxmlHPC -f a -m GTRGAMMA -p 12345 -x 12345 -# 100 -s Hands-On/dna.phy -n T20 
```

If called like this RAxML will do 100 rapid Bootstrap searches, 20 ML searches and return the best ML tree with support values to you via one single program call.

### Step 6: Partitioned Analysis

A common task is to conduct partitioned analyses. We need to pass the information about partitions to RAxML via a simple plain text file that is passed via the -q parameter. For a simple partitioning of our DNA dataset we can type: 

```
$ ./raxmlHPC -m GTRGAMMA -p 12345 -q Hands-On/simpleDNApartition.txt -s Hands-On/dna.phy -n T21 
```

The file simpleDNApartition partitions the alignment into two regions as follows:

```
DNA, p1=1-30
DNA, p2=31-60
```

p1 and p2 are just arbitrarly chosen names for the partition. We also need to tell RAxML what kind of data the partition contains (see below). If we partition the dataset like this the alpha shape parameter of the Gamma model of rate heterogeneity, the empirical base frequencies, and the evolutionary rates in the GTR matrix will be estimated independently for every partition. If we type: 

```
$ ./raxmlHPC -M -m GTRGAMMA -p 12345 -q Hands-On/simpleDNApartition.txt -s Hands-On/dna.phy -n T22 
```

RAxML will also estimate a separate set of branch lengths for every partition. If we want to do a more elaborate partitioning by, 1st, 2nd and third codon position we can execute: 

```
$ ./raxmlHPC -m GTRGAMMA -p 12345 -q Hands-On/dna12_3.partition.txt -s Hands-On/dna.phy -n T23 
```

The partition file now looks like this:

```
DNA, p1=1-60\3,2-60\3
DNA, p2=3-60\3
```

Here, we infer distinct model parameters jointly for all 1st and 2nd positions in the alignment and separately for the third  position in the alignment. We can of course also use partitioned datasets that contain both, DNA and protein data, e.g.: 

```
$ ./raxmlHPC -m GTRGAMMA -p 12345 -q Hands-On/dna_protein_partitions.txt -s Hands-On/dna_protein.phy -n T24 
```

the partition file looks as follows:

```
DNA, p1 = 1-50
WAG, p2 = 51-110
```

Here we are telling RAxML that partition p1 is a DNA partition (for which GTR+GAMMA will be used) and that partition p2 is a protein partition for which WAG+GAMMA will be used. Note that, the parameter -m is now only used to extract the desired model of rate heterogeneity which will be used for all partitions, i.e., we could also type: 

```
$ ./raxmlHPC -m PROTGAMMAWAG -p 12345 -q Hands-On/dna_protein_partitions.txt -s Hands-On/dna_protein.phy -n T25 
```

which will be exactly equivalent. If we want to use a different protein substitution model for p2 we may edit a partition file that looks like this:

```
DNA, p1 = 1-50
JTTF, p2 = 51-110
```

Now JTT with empirical base frequencies will be used. The format is analogous for binary partitions, e.g., assuming that p1 is a binary partition we would write

```
BIN, p1 = 1-50 
```

and for multi-state partitions, e.g., 

```
MULTI, p1 = 1-50
```

Don't forget to specify your substitution model for multi-state regions via -K (the chosen model will then be applied to all multi-state partitions).

# Step 7: Secondary Structure Models

Specifying secondary structure models for an RNA alignment works slightly differntly because we read in a plain RNA alignment and then need to tell RAxML by an additional text file that is passed via -S which RNA alignment sites need to be grouped together. We do this in a standard bracket notation written into a plain text file, e.g., our DNA test alignment has 60 sites, thus our secondary structure file needs to contain a string of 60 characters like this one:

..................((.......))............(.........)........

The '.' symbol indicates that this is just a normal RNA site while the brackets indicate stems. Evidently, the number of opening and closing brackets mus match. In addition, it is also possible to specify pseudo knots with additional symbols: <>[]{} for instance:

```
..................((.......)).......{....(....}....)........
```

In terms of models there are 6-state, 7-state and 16-state models for accommodating secondary structure that are specified via  -A. Available models are: S6A, S6B, S6C, S6D, S6E, S7A, S7B, S7C, S7D, S7E, S7F, S16, S16A, S16B. The default is the GTR 16-state model (-A S16). In RAxML the same nomenclature as in PHASE is used, so please consult the phase manual for a nice and detailed description of these models.

For our small example datasets we would run a secondary structure analysis like this: 

```
$ ./raxmlHPC -m GTRGAMMA -p 12345 -S Hands-On/secondaryStructure.txt -s Hands-On/dna.phy -n T26 
```

A common question is whether secondary structure models can also be partitioned. This is presently not possible. However, you can partition the underlying RNA data, e.g., use two partitions for our DNA dataset as before. What RAxML will do internally though is to generate a third partition for secondary structure that does not take into account that distinct secondary structure site pairs may stem from different partitions of the alignment.

### Step 9: Contstraint Trees

When you are passing trees to RAxML it usually expects them to be bifurcating. The rationale for this is that a multifurcating tree actually represents a set of bifurcating trees and it is unclear how to properly resolve the multifurcations in general. Also, for computing the likelihood of a tree we need a bifurcating tree, therefore resolving multi-furcations, either at random or in some more clever way is a necessary prerequisite for computing likelihood scores.
I personally have s strong dislike for constraint trees because the bias the analysis a prior using some biological knwoledge that may not necesssarily represent the signal coming from the data one is analyzing. The only purpose for which they may be useful is to assess various hypotheses of monophyly by imposing constraint trees and then conducting likelihood-based significance tests to compare the trees that were generated by the various constraints. 
Overall RAxML offers to types of constraint trees binary backbone constraints and multifurcating constraint trees.
In a backbone constraint we pass a bifurcating tree to RAxML whose structure will not be changed at all and just add those taxa in the alignment that are not contained in the binary backbone constraint to the tree via an ML estimate (see below). 

For our DNA dataset we may specify a backbone constraint like this: "(Mouse, Rat, (Human, Whale));" and type:

```
$ ./raxmlHPC -p12345 -r Hands-On/backboneConstraint.txt -m GTRGAMMA -s Hands-On/dna.phy -n T28
```

Multi-furcating constraints are slightly different in that they maintain the monophyletic structure of the backbone, but evidently taxa within a monopyhletic clade may be moved around. Also taxa that are not contained in the multi-furcating constrain tree which need not be comprehensive may be placed into any branch of the tree via ML. 

For our DNA dataset we can specify a multi-furcating constraint tree like this: "(Mouse, Rat, Frog, Loach, (Human, Whale,Carp));" and type:

```
$ ./raxmlHPC -p 12345 -g Hands-On/multiConstraint.txt -m GTRGAMMA -s Hands-On/dna.phy -n T29
```

Evidently, it doesn't make sense to specify a binary backbone constraint that contains all taxa (given that the backbone will remain fixed there is nothing to rearrange), while for multifurcating constraints it makes sense, for instance to resolve the multi-furcations.

A Frequent misconception about how constraint trees work in RAxML. One frequent problem users encounter is RAxML behavior when they use incomplete constraint trees, i.e., when the constraint does not contain all taxa in the alignment. Consider an alignment with 25 taxa in which you want to have enfore two phylogenetic groups for taxa A1, A2,...,A5 and B1, B2. Let's assume that the other taxa (not contained in the constraint) are called X1, X2, .... X17.
Now if you specify a constraint like this: "((A1,A2,A3,A4,A5),B1,B2);" it is not clear how the remaining taxa (X1,...,X17) shall behave. In RAxMl I have decided that they can be inserted anywhere in the tree and potentially within the monophyletic groups A and B. The property that is maintained (or shall be maintained if the implementation is correct) is that, in every tree using the above constraint, you will always find a branch that will split the taxon set such that taxa A1,...,A5 are on one side of that branch and taxa B1, B2 are on the other side of that branch. The positions of the taxa X1,...,X17 are completely irrelevant in this case, since your constraint only says something about A and B. If you don't want the X-taxa to appear within the groups A and B you will need to specify a comprehensive constraint (including all taxa) like this: "((A1,A2,A3,A4,A5),(B1,B2),(X1,X2,...,X17);". 
Please have a look at the tree below that has been built with the constraint "((A1,A2,A3,A4,A5),B1,B2);" and convince yourself that it actually respects the constraint according to the definition used in RAxML:

### Step 9.1: Constraining Sister Taxa

Now, if you want to constrain potential sister taxa to strict monophyly, e.g., mouse and rat, while other taxa will be allowed to freely move around the tree during ML topology optimization, you could do the following: Assume Mouse and Rat shall be forced to be monophyletic, you can specify a multi-furcating backbone constraint (containing, e.g., all taxa in dna.phy as follows: "(Cow, Carp, Chicken, Human, Loach, Seal, Whale, Frog, (Rat, Mouse));" and store this in a file monophylyConstraint.txt. Then you can call:

```
$ ./raxmlHPC -p 12345 -g monophylyConstraint.txt -m GTRGAMMA -s Hands-On/dna.phy -n T29monophyly
```

Assume that now you would like to force the Frog and the Mouse to be monophyletic, here you'd write: "(Cow, Carp, Chicken, Human, Loach, Seal, Whale, Rat, (Frog, Mouse));" and store this in a file called, e.g., weirdMonophyly.txt and execute:

```
$ ./raxmlHPC -p 12345 -g \weirdMonophyly.txt -m GTRGAMMA -s Hands-On/dna.phy -n T29weird_monophyly
```

If the constraint doesn't make much sense (e.g., Frog sister to Mouse) you will get a worse likelihood score for this and then use likelihood tests to determine wether the two alternative hypotheses yield trees with significantly differnt LnL scores.

### Step 10: Outgroups

An outgroup is essentially just a tree drawing option that allows you to root the tree at the branch leading to that outgroup. If your outgroup contains more than one taxon it may occur that the outgroups cease to be monophyletic, in this case RAxML will print out a respective warning. For our DNA dataset we can specify a single outgroup like this:

```
$ ./raxmlHPC -p 12345 -o Mouse -m GTRGAMMA -s Hands-On/dna.phy -n T30
```

If we want Mouse and Rat to be our ougroups we just type:

```
$ ./raxmlHPC -p 12345 -o Mouse,Rat -m GTRGAMMA -s Hands-On/dna.phy -n T31
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

