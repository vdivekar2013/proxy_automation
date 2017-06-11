#!/usr/bin/perl
# Automation script for deploying number of proxies on Mule gateway

package NitrohubMain;

BEGIN {
	unshift @INC, "./";
}

use NitrohubFile;

print "-------------------- Deploy Mule Proxies -----------------\n";

# create temporary folder in current directory

createFolder "\./\.tmp";

# read configuration to pick up key and values

my %configuration = readConfiguration "\./conf/deploy\.props";

# unzip the model proxy zip file to temporary folder

unzipFile $configuration{"ZipFile"}, "\./\.tmp";

# creating number of zip files in the output folder
createProxyZips \%configuration,"\./\.tmp";

# deleting temporary folder in current directory
deleteFolder "\./\.tmp";