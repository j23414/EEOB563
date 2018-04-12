# Lab #8: BayesTraits  

## Installation (MacOS)
* [BayesTraits](http://www.evolution.rdg.ac.uk/BayesTraitsV3.0.1/BayesTraitsV3.0.1.html) 

```
$ cd bin
$ wget http://www.evolution.rdg.ac.uk/BayesTraitsV3.0.1/Files/BayesTraitsV3.0.1-OSX.tar.gz
$ tar -xvf BayesTraitsV3.0.1-OSX.tar.gz
$ ln -s BayesTraitsV3.0.1-OSX/BayesTraitsV3 .
```

On the HPC-class (there is no module). You have to request resource allocation (_e.g.,_ `salloc -N 1 -n 4 -t 2:00:00`) before you use the program.

## Data

* `Primates.trees`: sampled topologies from a Bayesian analysis, where all but the first 20 trees have been removed;  
* `MatingSystems.txt`: a file with a list of primate species and their mating systems. For purposes of this example primate mating systems were classified as "1": multimale (females mate with more than one male) or "0": unimale/monogamous.
* `Primates.txt`: same as `MatingSystems.txt`, except an additional column with presence/ absence of oestrous advertisement (sexual swellings) in female primates is added. 

## Tutorial

Do exercises #1 and #2 from the [tutorial](https://sites.google.com/site/eeob563/computer-labs/lab-8).

## My notes

BayesTraits can be used interactively from the commandline.

```
$ ~/bin/BayesTraitsV3 data/Primates.trees data/Primates.txt 
BayesTraits V3.0.1 (Nov 23 2017)
Mark Pagel and Andrew Meade
www.evolution.reading.ac.uk

Please select the model of evolution to use.
1)	MultiState
2)	Discrete: Independent
3)	Discrete: Dependant
4)	Continuous: Random Walk (Model A)
5)	Continuous: Directional (Model B)
6)	Continuous: Regression
7)	Independent Contrast
8)	Independent Contrast: Correlation
9)	Independent Contrast: Regression
10)	Discrete: Covarion
13)	Geo

1

Please select the analysis method to use.
1)	Maximum Likelihood.
2)	MCMC

1
run

```

Alternatively, can save the results to a file

```
$ ~/bin/BayesTraitsV3 data/Primates.trees data/Primates.txt > output.txt
1
1
run
```

Interactive

```
$ ~/bin/BayesTraitsV3 data/Primates.trees data/Primates.txt 
BayesTraits V3.0.1 (Nov 23 2017)
Mark Pagel and Andrew Meade
www.evolution.reading.ac.uk

Please select the model of evolution to use.
1)	MultiState
2)	Discrete: Independent
3)	Discrete: Dependant
4)	Continuous: Random Walk (Model A)
5)	Continuous: Directional (Model B)
6)	Continuous: Regression
7)	Independent Contrast
8)	Independent Contrast: Correlation
9)	Independent Contrast: Regression
10)	Discrete: Covarion
13)	Geo

1

Please select the analysis method to use.
1)	Maximum Likelihood.
2)	MCMC

1

Options:
Model:                           MultiState
Tree File Name:                  data/Primates.trees
Data File Name:                  data/Primates.txt
Log File Name:                   data/Primates.txt.Log.txt
Save Initial Trees:              False
Save Trees:                      False
Summary:                         False
Seed:                            2179165071
Analsis Type:                    Maximum Likelihood
ML Attempt Per Tree:             10
ML Max Evaluations:              20000
ML Tolerance:                    0.000001
ML Algorithm:                    BOBYQA
Rate Range:                      0.000000 - 100.000000
Precision:                       64 bits
Cores:                           1
No of Rates:                     2
Base frequency (PI's):           None
Character Symbols:               0,1
Using a covarion model:          False
Normalise Q Matrix:              False
Restrictions:
    q01                          None
    q10                          None
Tree Information
     Trees:                      20
     Taxa:                       60
     Sites:                      2
     States:                     2

run

Options:
Model:                           MultiState
Tree File Name:                  data/Primates.trees
Data File Name:                  data/Primates.txt
Log File Name:                   data/Primates.txt.Log.txt
Save Initial Trees:              False
Save Trees:                      False
Summary:                         False
Seed:                            2179165071
Analsis Type:                    Maximum Likelihood
ML Attempt Per Tree:             10
ML Max Evaluations:              20000
ML Tolerance:                    0.000001
ML Algorithm:                    BOBYQA
Rate Range:                      0.000000 - 100.000000
Precision:                       64 bits
Cores:                           1
No of Rates:                     2
Base frequency (PI's):           None
Character Symbols:               0,1
Using a covarion model:          False
Normalise Q Matrix:              False
Restrictions:
    q01                          None
    q10                          None
Tree Information
     Trees:                      20
     Taxa:                       60
     Sites:                      2
     States:                     2
Tree No	Lh	q01	q10	Root - S(0) - P(0)	Root - S(0) - P(1)	Root - S(1) - P(0)	Root - S(1) - P(1)	
1	-43.236636	1.641848	2.339384	0.844050	0.155950	0.686565	0.313435	
2	-43.993122	1.885029	2.319409	0.837697	0.162303	0.726275	0.273725	
3	-44.091294	1.745015	1.096317	0.982673	0.017327	0.976003	0.023997	
4	-43.626486	1.721562	2.498842	0.808346	0.191654	0.717216	0.282784	
5	-45.010988	1.653529	2.665989	0.842530	0.157470	0.727844	0.272156	
6	-42.677411	1.339289	2.749906	0.789501	0.210499	0.556967	0.443033	
7	-41.729270	1.602410	2.467771	0.784364	0.215636	0.594305	0.405695	
8	-44.094078	1.704791	2.646905	0.818525	0.181475	0.719101	0.280899	
9	-43.550302	1.345158	3.186314	0.601385	0.398615	0.369928	0.630072	
10	-44.905713	1.366481	2.645921	0.794539	0.205461	0.524041	0.475959	
11	-45.536326	1.355984	2.642256	0.716821	0.283179	0.507175	0.492825	
12	-42.399301	1.496603	2.664246	0.806053	0.193947	0.640665	0.359335	
13	-41.679803	1.649065	1.386137	0.953793	0.046207	0.922116	0.077884	
14	-44.656106	1.875171	1.877846	0.903570	0.096430	0.859384	0.140616	
15	-45.400703	1.709784	2.860644	0.686773	0.313227	0.616108	0.383892	
16	-43.694940	1.540576	2.969188	0.795244	0.204756	0.431321	0.568679	
17	-42.784208	1.480932	3.198660	0.758760	0.241240	0.598118	0.401882	
18	-45.096954	1.608028	3.094550	0.648533	0.351467	0.587623	0.412377	
19	-45.738633	1.991976	1.972248	0.942656	0.057344	0.915790	0.084210	
20	-44.422399	1.623306	2.957604	0.726030	0.273970	0.603287	0.396713	
Sec:	0.000000

```

* 1st column: log likelihood
* q01: rate at which state changes from 0 to 1
* q10: rate at which state changes from 1 to 0
* p(0): probability that the root is at state 0
* p(1): probability that the root is at state 1

So notice that the rate from 0 (single male) to 1 (multimale) is greater than the converse. It is also more likely that the root had a 0 (single male) state.

```
AddTag Tag01 Pan_paniscus Pan_troglodytes Homo_sapiens Gorilla_gorilla Pongo_pygmaeus Pongo_pygmaeus_abelii
AddNode Node01 Tag01
AddMRCA Node02 Tag01

info

Options:
Model:                           MultiState
Tree File Name:                  data/Primates.trees
Data File Name:                  data/MatingSystems.txt
Log File Name:                   data/MatingSystems.txt.Log.txt
Save Initial Trees:              False
Save Trees:                      False
Summary:                         False
Seed:                            1550021098
Analsis Type:                    Maximum Likelihood
ML Attempt Per Tree:             10
ML Max Evaluations:              20000
ML Tolerance:                    0.000001
ML Algorithm:                    BOBYQA
Rate Range:                      0.000000 - 100.000000
Precision:                       64 bits
Cores:                           1
No of Rates:                     2
Base frequency (PI's):           None
Character Symbols:               0,1
Using a covarion model:          False
Normalise Q Matrix:              False
Tags:	1
	Tag01	6	Pan_paniscus Pan_troglodytes Homo_sapiens Gorilla_gorilla Pongo_pygmaeus Pongo_pygmaeus_abelii 
Restrictions:
    q01                          None
    q10                          None
Node reconstruction / fossilisation:
	Node Node01 Tag01
	MRCA Node2 Tag01
Tree Information
     Trees:                      20
     Taxa:                       60
     Sites:                      1
     States:                     2

run

Options:
Model:                           MultiState
Tree File Name:                  data/Primates.trees
Data File Name:                  data/MatingSystems.txt
Log File Name:                   data/MatingSystems.txt.Log.txt
Save Initial Trees:              False
Save Trees:                      False
Summary:                         False
Seed:                            1550021098
Analsis Type:                    Maximum Likelihood
ML Attempt Per Tree:             10
ML Max Evaluations:              20000
ML Tolerance:                    0.000001
ML Algorithm:                    BOBYQA
Rate Range:                      0.000000 - 100.000000
Precision:                       64 bits
Cores:                           1
No of Rates:                     2
Base frequency (PI's):           None
Character Symbols:               0,1
Using a covarion model:          False
Normalise Q Matrix:              False
Tags:	1
	Tag01	6	Pan_paniscus Pan_troglodytes Homo_sapiens Gorilla_gorilla Pongo_pygmaeus Pongo_pygmaeus_abelii 
Restrictions:
    q01                          None
    q10                          None
Node reconstruction / fossilisation:
	Node Node01 Tag01
	MRCA Node2 Tag01
Tree Information
     Trees:                      20
     Taxa:                       60
     Sites:                      1
     States:                     2
Tree No	Lh	q01	q10	Root P(0)	Root P(1)	Node01 P(0)	Node01 P(1)	Node2 P(0)	Node2 P(1)	
1	-26.128542	3.025912	1.855426	0.851787	0.148213	0.926693	0.073307	0.926693	0.073307	
2	-25.680979	3.297483	2.040189	0.824616	0.175384	0.926260	0.073740	0.926260	0.073740	
3	-25.423403	2.723676	0.370298	0.997926	0.002074	0.997766	0.002234	0.997766	0.002234	
4	-23.943186	2.540747	1.358796	0.914664	0.085336	0.942308	0.057692	0.942308	0.057692	
5	-25.266580	2.693711	1.121502	0.970575	0.029425	0.962753	0.037247	0.962753	0.037247	
6	-25.132260	2.366743	2.641577	0.704291	0.295709	0.696813	0.303187	0.696813	0.303187	
7	-24.694278	2.885220	2.132934	0.780474	0.219526	0.906045	0.093955	0.906045	0.093955	
8	-25.725982	3.114022	2.247482	0.848629	0.151371	0.826409	0.173591	0.826409	0.173591	
9	-26.071698	2.667691	2.854394	0.607014	0.392986	0.782306	0.217694	0.782306	0.217694	
10	-27.581348	2.566995	2.770696	0.658500	0.341500	0.778269	0.221731	0.778269	0.221731	
11	-28.519134	2.682646	2.624153	0.648157	0.351843	0.779776	0.220224	0.779776	0.220224	
12	-25.169791	2.775757	2.516614	0.769022	0.230978	0.814635	0.185365	0.814635	0.185365	
13	-24.263356	2.673318	0.867231	0.975213	0.024787	0.992561	0.007439	0.992561	0.007439	
14	-26.872402	3.071315	1.538855	0.913724	0.086276	0.936499	0.063501	0.936499	0.063501	
15	-27.706916	3.216947	2.371269	0.767664	0.232336	0.775460	0.224540	0.775460	0.224540	
16	-26.417347	2.911515	2.535293	0.740760	0.259240	0.814951	0.185049	0.814951	0.185049	
17	-23.839123	2.557607	2.311569	0.828083	0.171917	0.914312	0.085688	0.914312	0.085688	
18	-24.144044	2.604452	2.198764	0.768181	0.231819	0.836530	0.163470	0.836530	0.163470	
19	-23.183893	3.032056	0.683112	0.993110	0.006890	0.994228	0.005772	0.994228	0.005772	
20	-24.955408	2.805874	1.919861	0.836420	0.163580	0.886137	0.113863	0.886137	0.113863	
Sec:	0.000000

```

Notice how 4 columns were added to the output: Node1 p(0), Node1 p(1), Node2 p(0), Node2 p(1)

* Node1 is probably 0
* Node2 is probably 0


```
1
1
AddTag Tag01 Pan_paniscus Pan_troglodytes Homo_sapiens Gorilla_gorilla Pongo_pygmaeus Pongo_pygmaeus_abelii
AddTag Tag02 Pan_paniscus Pan_troglodytes
AddNode Node01 Tag01
AddMRCA Node02 Tag02
fossil Node03 Tag01 0
```

```
$ $ ~/bin/BayesTraitsV3 data/Primates.trees data/Primates.txt > harmonicmean.txt
1
2
it 1000000
hpall exp 0 30
run
```

```
$ $ ~/bin/BayesTraitsV3 data/Primates.trees data/Primates.txt > reversejhp.txt
1
2
it 1000000
rjhp exp 0 30
run
```

