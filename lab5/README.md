# Lab #5: Bayesian analysis

## Software Installation (with a focus on MacOS)

* First install [Beagle library](https://www.dropbox.com/s/11kgt2jlq3lzln3/BEAGLE-2.1.2.pkg)
* Then install [MrBayes](https://sourceforge.net/projects/mrbayes/?source=typ_redirect)
* or [MrBayes GitHub](https://github.com/NBISweden/MrBayes)

```
$ git clone https://github.com/beagle-dev/beagle-lib.git
$ git clone https://github.com/NBISweden/MrBayes
```

Other programs to install

* [Tracer](http://tree.bio.ed.ac.uk/software/tracer/) useful for examining output of bayesian analysis programs
* [FigTree](http://tree.bio.ed.ac.uk/software/figtree/)

## HPC Specific Instructions

```
$ module load mrbayes;          # load the mrbayes
$ salloc -N 1 -n 4 -t 2:00:00;  # run in interactive mode
$ mpirun -np 4 mb               # multiple processer (4) run of mrbayes
```

## Bayesian phylogenetics with MrBayes

The data for this exercise is in the directory data on GitHub repository.

```
EEOB563/lab5/data
```
Now go to the tutorial [website](https://sites.google.com/site/eeob563/computer-labs/lab-5).  There are three different exercises there.

```
$ mb # Start MrBayes
MrBayes > help    # look at the help
MrBayes > help log # look up a particular command
```

Save all the screen output from our analysis to a file called conifer-partn-log.txt

```
MrBayes > log start filename=conifer-partn-log.txt
```

Descriptions listed beside the commands in bash comments. Make sure you don't copy the bash comment into MrBayes! :P 

```
MrBayes > execute data/conifer_dna.nex.     # load input
MrBayes > outgroup Ginkgo_biloba            # define outgroup
```

### Choose a model

Perform an analysis on the unpartitioned alignment using the GTR+gamma model. This assumes that the process that generated our data was homogeneous accross all sites of the alignment. The 'lset' command specifies the details of our sequence model.

```
MrBayes > lset nst=6 rates=gamma 
```

* 6 relative substitution rates
* gamma-distributed rate variation accross sites
* Setting `nst` affects which DNA models are available
  * `nst=1` JC69 or F81 models
  * `nst=2` K2P or HKY models
  * `nst=6` GTR model

In Bayesian analysis we treat parameters as random variables, which requires prior probability density. 

```
MrBayes > help prset          # see help manual for setting priors
MrBayes > prset shapepr=exponential(0.05)   # example setting a prior
MrBayes > showmodel           # Show the model
```

There are multiple prior distribution; here are some main ones.

* `revmatpr=dirichlet(1,1,1,1,1,1)` Dirichlet prior on 6 exchangeability parameters
* `statefreqpr=dirichlet(1,1,1,1)` Dirichlet prior on the 4 base frequencies
* `prset shapepr=exponential(0.05` Change from the default (`Uniform(0.0,2000.0)` to an exponential distribution iwth a rate parameter lambda=0.05.


### Run the MCMC

```
MrBayes > help mcmc
MrBayes > mcmcp nruns=2 nchains=4 savebrlens=yes         # default parameter values
MrBayes > mcmcp ngen=300000 printfreq=100 samplefreq=100 # change the defaults
MrBayes > mcmcp diagnfreq=1000 diagnstat=maxstddev
MrBayes > mcmcp filename=conifer-uniform
MrBayes > mcmc
```

### Run the Stepping Stone Analysis

In the Bayesian framework, model selection is typically performed through the evaluation of a Bayes factor, the ratio of marginal likelihoods for the two models. Commonly, marginal likelihood was calculated by harmonic mean estimator. New techniques to estimate (log) marginal likelihoods, such as path sampling and stepping-stone sampling, offer increased accuracy over the traditional method. In this part of the exercise, we will estimate marginal likelihood of the unpartitioned model using stepping- stone sampling. 

```
MrBayes > ssp ngen=100000 diagnfreq=1000 filename=conifer-uniform-ss # set parameters
MrBayes > ss # run stepping stone analysis
```

### Partition by gene region

The dataset we use in this exercise contains two distinct gene regions—atpB and rbcL—so we may wish to explore the possibility that the substitution process differs between these two gene regions. This requires that we first specify the data partitions corresponding to these two genes, then define an independent substitution model for each data partition.

First, use the charset command to define the subset of sites belonging to each of the gene regions (in our case sites 1–1,394 belong to the atpB gene and sites 1,395–2,659 are from rbcL):

```
MrBayes > charset atpB = 1-1394
MrBayes > charset rbcL = 1395-2659
MrBayes > partition partition-by-gene = 2: atpB, rbcL
MrBayes > set partition=partition-by-gene
MrBayes > lset applyto=(all) nst=6 rates=gamma
MrBayes > unlink revmat=(all) statefreq=(all) shape = (all) # unlink the params for each gene, so estimated independently
MrBayes > prset applyto=(all) ratepr=variable
# Set up  mcmc
MrBayes > mcmcp ng=300000 printf=100 samp=100 diagnf=1000 diagnst=maxstddev
MrBayes > mcmcp nch=4 savebr=yes filename=conifer-partn
MrBayes > mcmc
```

Stepping stone analysis

```
MrBayes > ss ng=100000 diagnfr=1000 filename=conifer-partn-ss
MrBayes > ss
```

### Partition by codon position

It is common to partition coding sequences by codon position in addition to the gene region. For this exercise, we will do such partitioning for the rbcL gene. When partitioning by codon position we can use specific notation to indicate that every third base-pair belongs to a given charset:

```
MrBayes > charset rbcL1stpos = 1395-2659\3 
MrBayes > charset rbcL2ndpos = 1396-2659\3
MrBayes > charset rbcL3rdpos = 1397-2659\3
```

Notice that each charset begins with a different character position in our alignment but ends with the same!
Now we will specify four different subsets of the alignment: the entire atpB gene, rbcL 1st positions, rbcL 2nd positions, and rbcL 3rd positions:

```
MrBayes > partition sat-partition = 4: atpB, rbcL1stpos, rbcL2ndpos, rbcL3rdpos
MrBayes > set partition=sat-partition
```

We will again assume a GTR+Γ model for every character set, but unlink the parameters across our subsets.

```
MrBayes > lset applyto=(all) nst=6 rates=gamma
MrBayes > prset revm=dir(1,1,1,1,1,1) statef=dir(1,1,1,1) shape=expon(0.05)
MrBayes > unlink revmat=(all) statef=(all) shape=(all)
MrBayes > prset applyto=(all) ratepr=variable
```

Setting and running the MCMC

```
MrBayes > mcmcp ng=300000 printf=100 samp=100 diagnf=1000 diagnst=maxstddev
MrBayes > mcmcp nch=4 savebr=yes filename=conifer-sat-partn
MrBayes > mcmc
```

Stepping stone analysis

```
MrBayes > ss ng=100000 diagnfr=1000 filename=conifer-sat-partn-ss
```
