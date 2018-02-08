## Lab 3 - Distance analysis with PAUP, PHYLIP, and FastME 

In this lab we will learn about three phylogenetic programs that can be used for distance analysis

## Prerequisites:

### Update your EEOB563-Spring2018 git repository
- Go to the repository and issue the following command: `git pull origin master`

### Make sure you have access to the programs
- You should already know how to use/install PAUP;  
- Use `module load phylip` to load Phylip on HPC-Class.  You can also install from its website ([see links]())
- FastME is already installed on HPC-Class. [Online version](http://www.atgc-montpellier.fr/fastme/)
is also available, but you should avoid it to practice your command line skills.  

## Lab tutorial

Lab 3: [PAUP, PHYLIP, and FastME](lab3)

## Additional tutorials

[Git/GitHub](https://isu-molphyl.github.io/EEOB563-Spring2018/computer_labs/lab1/git.pdf)  
[VI](https://isu-molphyl.github.io/EEOB563-Spring2018/computer_labs/lab1/vi_tutorial.pdf)  

## Jennifer Chang Notes

Some Paup review: 

```
$ paup            # start PAUP
paup> q           # quit PAUP
```

### Align and load the data (cob_nt.fa)

We already know how to align sequeces and import them in PAUP so this part should be easy :).

```
$ mafft --auto ../data/cob_nt.fasta > cob_nt_aln.fa
$ paup
paup> ToN format=fasta fromF = cob_nt_aln.fa toF=cob_nt.nxs
paup>  exe cob_nt.nxs
```

### Select a model for distance calculation

Specify a distance correction we want to use by using the dset command. We will be using uncorrected (“p”), Jukes-Cantor, Kimura 2-parameter, HKY85, and GTR distances.

```
paup> help dset          # help statement and show current settings
paup> dset distance=JC
```

#### Show the distance matrix

```
paup> showdist

Jukes-Cantor distance matrix
  1149 characters are included

                     1        2        3        4        5        6        7        8        9       10       11       12       13       14       15       16       17
 1 Platypus          -
 2 Echidna     0.21488        -
 3 Opossum     0.34326  0.32001        -
 4 Wallaby     0.30776  0.29213  0.25284        -
 5 Bandicoot   0.31163  0.32626  0.24508  0.23396        -
 6 Elephant    0.35273  0.37555  0.34024  0.33823  0.31665        -
 7 Aardvark    0.31470  0.30278  0.28338  0.28693  0.26997  0.30095        -
 8 Tenrec      0.36150  0.35584  0.31871  0.31304  0.30872  0.33726  0.29106        -
 9 Sloth       0.39342  0.37151  0.35583  0.31191  0.34852  0.31555  0.29885  0.35725        -
10 Armadillo   0.34326  0.33774  0.31612  0.28805  0.25863  0.31699  0.25569  0.29365  0.26313        -
11 Human       0.39128  0.36939  0.36345  0.31507  0.32678  0.36504  0.29774  0.37199  0.31914  0.30317        -
12 Tree shrew  0.34389  0.32335  0.30609  0.30955  0.31197  0.35000  0.26607  0.34802  0.31545  0.27492  0.33145        -
13 Rabbit      0.33668  0.32847  0.31908  0.28992  0.31196  0.32231  0.25229  0.31903  0.31244  0.26845  0.30822  0.29932        -
14 Mouse       0.29895  0.30417  0.28454  0.27946  0.25775  0.33351  0.27706  0.30690  0.31331  0.25453  0.30593  0.27008  0.27224        -
15 Hedgehog    0.37295  0.38752  0.33512  0.35676  0.31720  0.36815  0.32410  0.33636  0.39194  0.30542  0.37903  0.35921  0.33397  0.31224        -
16 Flying fox  0.32952  0.32275  0.29887  0.28821  0.29290  0.32097  0.27951  0.30806  0.29885  0.27317  0.30851  0.27221  0.26835  0.25452  0.33089        -
17 Cat         0.35023  0.30938  0.31072  0.29600  0.29419  0.31026  0.26563  0.30147  0.29235  0.27570  0.27728  0.28510  0.25352  0.25328  0.33089  0.23501        -
18 Dog         0.36293  0.34465  0.29887  0.31568  0.32350  0.32097  0.26065  0.30542  0.33089  0.27191  0.31104  0.27619  0.26717  0.27581  0.32275  0.26813  0.24711
19 Pig         0.30674  0.27696  0.29891  0.28809  0.28274  0.32507  0.24711  0.29885  0.29625  0.24589  0.30846  0.26109  0.28113  0.24356  0.32681  0.21840  0.23742
20 Whale       0.34049  0.31737  0.31605  0.29084  0.29551  0.31164  0.29365  0.31871  0.30806  0.25569  0.33137  0.31261  0.28623  0.28855  0.36435  0.25569  0.26813

Jukes-Cantor distance matrix (continued)

                    18       19       20
18 Dog               -
19 Pig         0.22904        -
20 Whale       0.27317  0.21255        -
```

#### Other distances

uncorrected (“p”), Jukes-Cantor, Kimura 2-parameter, HKY85, and GTR distances

```
paup> dset distance=P           # uncorrected
paup> dset distance=JC          # Jukes-Cantor
paup> dset distance=K2P         # Kimura 2-parameter
paup> dset distance=HKY85       # HKY85
paup> dset distance=GTR         # GTR
```

### Use distances as an optimality criterion

```
paup> set criterion=distance;

Optimality criterion set to distance.

paup> dset objective=me dist=jc;
paup> hsearch;

Heuristic search settings:
  Optimality criterion = distance (minimum evolution)
    Negative branch lengths allowed, but set to zero for tree-score calculation
    Distance measure = Jukes-Cantor
    1149 characters are included
  Starting tree(s) obtained via neighbor-joining
  Branch-swapping algorithm: tree-bisection-reconnection (TBR) with reconnection limit = 8
    Steepest descent option not in effect
  Initial 'Maxtrees' setting = 100
  Zero-length branches not collapsed
  'MulTrees' option in effect
  No topological constraints in effect
  Trees are unrooted

Heuristic search completed
  Total number of rearrangements tried = 2472
  Score of best tree(s) found = 2.79577
  Number of trees retained = 1
  Time used = 0.01 sec (CPU time = 0.01 sec)
```

* What distance and what optimality criterion did we use? (Jukes-Cantor, distance)
* Now evaluate the tree using the Fitch-Margoliash weighted least-squares criterion (inverse squared weighting) and GTR distances.

```
paup> dset objective=lsFit
paup> dset distance=GTR
paup> hsearch
paup> ShowTree;
paup> savetree file=lsFit_GTR.tre format=nexus
```

### Run the neighbor-joining algorithm with the selected distance

Can you figure out what is the command name for the neighbor-joining analysis? `NJ` How about UPGMA? `UPGMA`

Run neighbor-joining search with 5 distances listed above.

```
paup> set criterion=distance;
paup> dset distance=P           # uncorrected
paup> NJ; savetree file=nj_P.tre format=nexus;
paup> dset distance=JC          # Jukes-Cantor
paup> NJ; savetree file=nj_JC.tre format=nexus;
paup> dset distance=K2P         # Kimura 2-parameter
paup> NJ; savetree file=nj_K2P.tre format=nexus;
paup> dset distance=HKY85       # HKY85
paup> NJ; savetree file=nj_HKY85.tre format=nexus;
paup> dset distance=GTR         # GTR
paup> NJ; savetree file=nj_GTR.tre format=nexus;
```

* How does the distance model chosen affect the tree found by NJ for this data set? `open tre files in FastTree and compare`
* Can you figure out how to perform bootstrap analysis (100 replicates, heuristic search using least squares) under the HKY85 model?

```

```

* Write a PAUP block that will do several distance analyses automatically for you.

```
begin PAUP;
set criterion=distance;
dset objective=lsFit
dset distance=P
NJ; savetree file=nj_P.tre format=nexus;
dset distance=JC 
NJ; savetree file=nj_JC.tre format=nexus;
dset distance=K2P 
NJ; savetree file=nj_K2P.tre format=nexus;
dset distance=HKY85 
NJ; savetree file=nj_HKY85.tre format=nexus;
dset distance=GTR
NJ; savetree file=nj_GTR.tre format=nexus;
end PAUP;
```

## Part 2: PHYLIP

[PHYLIP](http://evolution.genetics.washington.edu/phylip/getme-new1.html)

PHYLIP is a package of phylogenetic programs written by Joe Felsenstein group and first released in 1980. The programs can infer phylogenies by parsimony, compatibility, distance matrix methods, and likelihood. You probably won’t use PHYLIP for conventional phylogenetic analysis as newer programs are much faster and often incorporate additional models of sequence evolution. However, some types of analyses available in PHYLIP are difficult to impossible to find in other programs. An additional advantage of this package is its thorough, well organized, and up to date documentation.

Unlike PAUP, which installs as a single program, PHYLIP is a collection of 35+ programs that are intended to be used sequentially. You start a program by typing its name at the unix prompt.

Here is outline of the exercise (from a nice chapter in Current Protocols in Bioinformatics ) with the name of the programs listed in ALLCAPs.

### Install phylip

#### Install and compile (not working yet)

```
$ wget http://evolution.gs.washington.edu/phylip/download/phylip-3.697.tar.gz
$ tar -xvzf phylip-3.697.tar.gz
$ cd phylip-3.697/src
$ make install -f Makefile.osx
```

#### Executable

Fetch executable

```
wget http://evolution.gs.washington.edu/phylip/download/phylip-3.695-osx.dmg
open .
```

Double click on the dmg to mount it

```
$ mkdir phylip
$ cp /Volumes/phylip-3.695-vol/phylip-3.695/exe/*.app/Contents/MacOS/* phylip/.
$ cd phylip
$ ls
$ rm *.command
```
