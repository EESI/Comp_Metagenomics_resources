# About 

This repo presents some of the basic functionality for using `Proteus` on [Drexel University's Research Computing Facility (UCRF)](http://www.drexel.edu/research/urcf/). Proteus uses the [Univa Grid Engine](http://www.univa.com/products/grid-engine) as the batch queuing system to submit and handle jobs. Before getting started, read through the [Proteus wiki](https://proteusmaster.urcf.drexel.edu/urcfwiki) for more information on using the batch queuing system. 

# SSHing into Proteus

Proteus has two head nodes that you can use for compting. Think of the nodes as being a computer or server. The two head nodes either use: (a) AMD, or (b) Intel processors. To connect to one of the head nodes, run the follwing commands in the shell. 

```bash
  # sshing into AMD servers 
  ssh USERNAME@proteusa01.urcf.drexel.edu
  # sshing into Intel servers 
  ssh USERNAME@proteusi01.urcf.drexel.edu
```
where `USERNAME` is your username for proteus. 


You can setup your ssh keys and add the public key onto Proteus. To do this, you'll need to [generate an ssh key](https://help.github.com/articles/generating-ssh-keys/) if you do not already have one setup. Then add the public key to `~/.ssh/authorized_keys`.  

# Transferring Files

* [Filezilla](https://filezilla-project.org/)
* [WinSCP](http://winscp.net/eng/index.php)
* [Cyberduck](https://cyberduck.io/)

# Using Modules 

Proteus is using modules to setup the environment in the shell and the software that the user has available to them. The Proteus wiki has some useful information on navigating though the [modules](https://proteusmaster.urcf.drexel.edu/urcfwiki/index.php/Environment_Modules). 

```bash
  # view available modules
  module avail 
  # view the modules that are currently loaded 
  module list
```

## Loading Modules & Some Useful Modules 

You can manully load each of the modules as you need them; however, it may make your life easier to add the following commands to your `~/.bashrc` file. 

```bash
  module load python/2.7.7
  module load R/3.0.2
  module load matlab/R2013a
  module load ncbi-blast/gcc/64/2.2.29 
```

You can unload modules with `module unload <some modeule>`.

## Modules Installed for the Course

Several modules have been installed specifically for this course. Some of these tools are `FastQC`, `BowTie`, `CD-Hit`, `Cufflinks`, `Trimmomatic`, `muscle`, `fasttree`, `infernal`, and `tophat` to name a few. However, before any of these tools can be used, we must add them to our path if we want to use them. We can acheive this by running or adding this line to our SGE submission script.

```bash 
  source /mnt/HA/groups/nsftuesGrp/bashrc
```

# Simple Qsub and Scripts 

## Writing the Script
The outline for this script can be found on the [Proteus wiki](https://proteusmaster.urcf.drexel.edu/urcfwiki/index.php/Writing_Job_Scripts). As an example, consider `simple-script.sh`. The `#$` tell the scheduler that these lines are to be interpreted as flags. 

```bash
  #!/bin/bash
  # tell SGE to use bash for this script
  #$ -S /bin/bash
  # execute the job from the current working directory, i.e. the directory in which the qsub command is given
  #$ -cwd
  # set email address for sending job status
  #$ -M fixme@drexel.edu
  # project - basically, your research group name with "Grp" replaced by "Prj"
  #$ -P nsftuesPrj
  # select parallel environment, and number of job slots
  #$ -pe openmpi_ib 5
  # request 15 min of wall clock time "h_rt" = "hard real time" (format is HH:MM:SS, or integer seconds)
  #$ -l h_rt=00:15:00
  # a hard limit 8 GB of memory per slot - if the job grows beyond this, the job is killed
  #$ -l h_vmem=8G
  # want at least 6 GB of free memory
  #$ -l mem_free=6G
  # select the queue all.q, using hostgroup @intelhosts
  #$ -q all.q@@amdhosts 

  . /etc/profile.d/modules.sh
  module load shared
  module load proteus
  module load sge/univa

  python -c "print 'Hello World'"
```

## Calling the Script

We can submit the previous script to the scheduler using: 

```bash
  newgrp nsftuesGrp
  qsub simple-script.sh  
```
at the shell. We need to switch to the `nsftuesGrp` group to be able to submit our jobs to the cluster. Note that the previous commands will produce an error since the project and group names were fictitious.

## Monitoring Progress

```bash 
  qstat
  qstat -f 
```

## Using Scratch Space

It is very likely that your projects will require that you submit your code to the cluster and the result is something such as an output file from you program. Regardless of what your program is written in (e.g., Bash, Python, Perl, Matlab, R, ...), you'll need to specify where the file is going to be written. Make sure that you write to the scratch space then copy/move the file to your local folder. For example, lets say I have a python script `my_fun.py` that runs a Monte Carlo like simulation on a file $/home/gcd34/data.txt$ (file does not actually exist! its just an example), and output the result to $/home/gcd34/output.txt$.  The *lazy*, and also incorrect way, is 

```bash
  #!/bin/bash
  #$ -S /bin/bash
  #$ -cwd
  #$ -M fixme@drexel.edu
  #$ -P nsftuesPrj
  #$ -q all.q@@amdhosts 

  . /etc/profile.d/modules.sh
  module load shared
  module load proteus
  module load sge/univa
  
  ##
  # do some stuff here
  ##
  
  python my_fun.py -i /home/gcd34/data.txt -o /home/gcd34/output.txt
  
  ##
  # do some more stuff here
  ##
```

Rather write the file to scratch then move the file to your local directory after everything is done! This can be accomplished with:


```bash
  #!/bin/bash
  #$ -S /bin/bash
  #$ -cwd
  #$ -M fixme@drexel.edu
  #$ -P nsftuesPrj
  #$ -q all.q@@amdhosts 

  . /etc/profile.d/modules.sh
  module load shared
  module load proteus
  module load sge/univa
  
  ##
  # do some stuff here
  ##
  
  python my_fun.py -i /home/gcd34/data.txt -o $TMP/output.txt
  
  ##
  # do some more stuff here
  ##
  
  ## finish up
  cp $TMP/output.txt /home/gcd34/output.txt
```

Refer to this [link](http://gregoryditzler.wordpress.com/2014/09/17/performing-tasks-such-as-monte-carlo-simulations-on-a-cluster/) for a slightly more detailed Matlab example. 




