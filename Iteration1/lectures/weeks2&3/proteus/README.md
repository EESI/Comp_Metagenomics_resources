# Getting Started

First, download the Git repo to you home folder on the login node of Proteus. Before we can run anything we need to configure a few things. Let us download the code and data from Github. 

```bash
  # Assuming you have ssh'd into the head node and are in your
  # home folder. Run 'pwd' without the ticks. You should see
  # /home/<your user name>. Then run:
  git clone https://github.com/gditzler/ECES490-Sp2015.git
  cd ECES490-Sp2015/proteus/
```

Now that we have the code, you must edit `submitter.sh`. Use `nano` to edit the following

* Change the email address in line 4 to be your Drexel email address (i.e., the username you would use to ssh into the cluster)
* Change lines 22 and 23 from `/home/gcd34/ECES490-Sp2015/data` to `/home/<your user name>/ECES490-Sp2015/data`. Perform the same change for line 23 

# What are we doing here?

This tutorial goes over how to use  Qiime  to process data from a high-throughput 16S rRNA sequencing studie collected from *Crawford et al., 2009*. The original tutorial can be found [here](http://qiime.org/tutorials/tutorial.html); however, due to changes in the software some components of the tuturial have been changed from its original to somethings that can be deployed on Protues's version of Qiime.  Before getting started, lets point a few things out: 

* `data/` contains all of the data that we would like to analyze
* `submitter.sh` is the script we're going to submit to SGE
* Before attempting to run any code you'll need to create a directory for the results of `submitter.sh` to be placed. create a folder called `output` in `bio-course-materials/proteus-demo/` (i.e., from this directory run `mkdir output`). Also, make sure nothing is in `output/` when you submit your job. This can be acheived by:
```bash 
  # assuming you are in bio-course-materials/proteus-demo
  rm -Rf output/ 
  mkdir output/
```

*Be very careful with the `rm` command!* [Remember, once its gone, its gone! ](http://iconic-inc.com/wp-content/uploads/2013/08/il_570xN.347082039.jpg)


You also need to setup your Qiime configuration (i.e., tell Qiime where otherr software and databases are located). So run
```bash 
  cp /mnt/HA/groups/nsftuesGrp/qiime_config ~/.qiime_config
```


# Submitting to the Proteus cluster

You need to make sure you change from your group to the courses group before you submit your job to the queuing system. This is true for any job that you run. Once you have changed your group, run: 

```bash 
  newgrp nsftuesGrp
  qsub submitter.sh
```

Use the `qstat` command to check the status of the job. SGE produces two files, an error and output file, in the directory where the script was submitted into the queue. Runnign `qstat` should give you something like 

```bash 
[gcd34@proteusi01 proteus-demo]$ qstat
job-ID  prior   name       user         state submit/start at     queue                          jclass                         slots ja-task-ID 
------------------------------------------------------------------------------------------------------------------------------------------------
 110147 0.00500 submitter. gcd34        r     10/16/2014 08:41:54 all.q@ac01n02.cm.cluster                                          1        
```

where the `r` lets us know the code is running. 

You can check the file contents for any errors or things that would have normally been dumped to the standard output. Check the `output/` folder for the contents of the Qiime output being executed in `submitter.sh` 

```bash
[gcd34@proteusi01 proteus-demo]$ ls -l output/
total 20
-rw-r--r-- 1 gcd34 rosenGrp   69 Oct  8 14:19 alpha_params.txt
drwxr-xr-x 2 gcd34 rosenGrp  120 Oct  8 14:19 mapping_output
drwxr-xr-x 8 gcd34 rosenGrp 4096 Oct  8 14:19 otus
drwxr-xr-x 2 gcd34 rosenGrp   86 Oct  8 14:19 split_library_output
drwxr-xr-x 4 gcd34 rosenGrp  106 Oct  8 14:19 wf_arare
drwxr-xr-x 4 gcd34 rosenGrp 4096 Oct  8 14:19 wf_bdiv_even146
drwxr-xr-x 5 gcd34 rosenGrp 4096 Oct  8 14:19 wf_jack
drwxr-xr-x 3 gcd34 rosenGrp 4096 Oct  8 14:19 wf_taxa_summary
```

# Acknowledgements

* Prof. Rosen provided a lot of great advice to get this tutorial to its current state. 
 
