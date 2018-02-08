# EEOB 563 Molecular Phylogenetics - Spring 2018


# Course Materials and Lab Data

```
$ git clone https://github.com/ISU-MolPhyl/EEOB563-Spring2018.git
$ ls
EEOB563-Spring2018
```

At the beginning of each lab session, fetch the new data files and lab descriptions

```
$ cd EEOB563-Spring2018
$ git pull
```

Create a copy of the data files and lab description into your personal github repo.

```
$ cd EE0B563
$ cp -r ~/github/EEOB563-Spring2018/computer_labs/data .
$ cp -r ~/github/EEOB563-Spring2018/computer_labs/lab3 .
```

And commit them to your git repo.

```
$ git add data
$ git add lab3
$ git commit -m "Add lab 3" data lab3
$ git push origin master
```

## Install Dependencies
List software and how to install in this section.