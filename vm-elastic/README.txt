This is a Vagrant ELK deployment for slurm monitoring or Dalma

Slurm data is in "dalma" directory, file named: slurm.completed.logs

this file has the format:

End,Cluster,JobID,Partition,User,Account,AllocNodes,AllocCPUS,Elapsed,Submit,Eligible,Start,CPUTimeRaw_in_secs

So the correct way to gather this data form slurm could be:

sacct -p -a --format='end,cluster,JobID,Partition,user,Account,AllocNodes,AllocCPUS,elapsed,submit,Eligible,start,cputimeraw,state' | grep COMPLETED | gawk -F"|" '{print $1","$2","$3","$4","$5","$6","$7","$8","$9","$10","$11","$12","$13}' | egrep -v  -e "[[:digit:]]+\." > ./data/$logfile 


It will create records in ElasticSearch with the following fields:

     "elegible" => "2018-04-22T09:53:57",
      "cputime_h" => 26.0,
      "elapsed_h" => 0.007222222222222223,
        "cluster" => "dalma",
     "alloc_cpus" => 1,
       "@version" => "1",
       "queued_m" => 90.13333333333334,
           "user" => "gencore",
     "@timestamp" => 2018-04-22T11:24:31.000Z,
    "elapsed_txt" => "00:00:26",
           "host" => "elastic2",
           "type" => "slurmctld",
            "end" => "2018-04-22T11:24:31",
        "account" => "gencore",
          "jobid" => 6195882245,
      "partition" => "ser_std",
         "submit" => "2018-04-22T09:53:56",
    "alloc_nodes" => 1,
           "path" => "/home/vagrant/dalma/slurm.completed.logs",
          "start" => "2018-04-22T11:24:05"



