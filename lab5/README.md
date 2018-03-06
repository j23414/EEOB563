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

#### Data
The data for this exercise is in the directory data on GitHub repository.


### Tutorial
Now go to the tutorial [website](https://sites.google.com/site/eeob563/computer-labs/lab-5).  There are three different exercises there.
