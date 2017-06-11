# Contains reusable code for handling folders and files
package NitrohubFile;

require Exporter;
use Cwd;
use File::Path;
use Config::Properties;
use Archive::Extract;
use Archive::Zip;

@ISA = qw/Exporter/;

@EXPORT = qw/createFolder deleteFolder readConfiguration unzipFile zipFiles createProxyZips/;

sub createFolder {
	unless (scalar @_ == 1) {
		die "No folder name provided\n";
	}
	my $curDirectory = getcwd;
	print "Creating folder $_[0]\n";
	unless(chdir($_[0])) {
		mkdir($_[0], 0700);
		chdir($_[0]) or die "can't chdir $_[0]\n";
		print "folder $_[0] created\n";
	} else {
		print "folder $_[0] already exists\n";
	}
	chdir($curDirectory);
}

sub deleteFolder {
	unless (scalar @_ == 1) {
		die "No folder name provided\n";
	}
	my $curDirectory = getcwd;
	print "Deleting folder $_[0]\n";
	if(chdir($_[0])) {
		chdir($curDirectory);
		rmtree($_[0]);
		print "folder $_[0] deleted\n";
	} else {
		print "Folder $_[0] does not exist\n";
	}
}

sub readConfiguration {
	unless (scalar @_ == 1) {
		die "No Configuration file provided\n";
	}
	open my $fh, '<', $_[0] or die "unable to open configuration file $_[0]\n";
	my $properties = Config::Properties->new();
	$properties->load($fh);
    my %configuration = $properties->properties();
    @keys = keys %configuration;
    foreach $key (@keys) {
    	print "Key $key has value ", $configuration{$key}, "\n";
    }
    return %configuration;
}

sub unzipFile {
	unless (scalar @_ == 2) {
		die "No Zip file and/or destination folder provided\n";
	}
	my $x = Archive::Extract->new( archive => $_[0] );
	$x->extract( to => $_[1] ) or die $x->error;
	print "Zip file $_[0] extracted at $_[1]\n";
}

sub zipFiles {
	unless (scalar @_ == 2) {
		die "No input folder and/or destination Zip name provided\n";
	}
	my $zip = Archive::Zip->new();
	$zip->addTree( $_[0], '' );
	$zip->writeToFileNamed($_[1]);
	print "$_[1] Zip file created\n";
}

sub createProxyZips {
	unless (scalar @_ == 2) {
		die "No configuration and/or input folder provided\n";
	}
	my $start = $_[0]{"ProxyStart"};
	my $noOfProxies = $_[0]{"NoOfProxies"};
	my $proxyZipBaseName = $_[0]{"ProxyZipBaseName"};
	my $outputFolder = $_[0]{"OutputFolder"};
	for(my $count=0; $count < $noOfProxies; $count++) {
		my $proxyName = $outputFolder . "/" . $proxyZipBaseName . $start . "\.zip";		
		print "Zip file name is $proxyName\n";
		$start++;
		zipFiles $_[1],$proxyName;
	}
}