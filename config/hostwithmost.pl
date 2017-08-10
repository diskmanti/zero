#!/bin/env perl
#
# Ron Compos, 07/20/2017

use warnings;
use strict;
use Getopt::Std;
use Cwd;

select( ( select( STDERR ), $| = 1 )[0] );
select( ( select( STDOUT ), $| = 1 )[0] );

my %opt;
getopts( 'h', \%opt );
usage()  if $opt{ h };

my $system_hosts = "/etc/hosts";
my $ansible_dir = "/etc/ansible";
my $ansible_hosts = "$ansible_dir/hosts";

print "Reading $system_hosts\n";
my @system_host_lines = `/bin/cat ${system_hosts}`;
my @vagrant_hosts;
for ( @system_host_lines ) {
  next if /^\s*$/;
  #print if /## vagrant-hostmanager-start/../## vagrant-hostmanager-end/;
  if ( /^## vagrant-hostmanager-start/../^## vagrant-hostmanager-end/ ) {
    push( @vagrant_hosts, $_ ) unless /^## vagrant-hostmanager-/; 
  }
}
for ( @vagrant_hosts ) { chomp; print "  $_\n" }  # Print all Vagrant Hostmanager managed hosts 

print "\n";

#my @ansible_hosts = `/bin/cat /etc/ansible/hosts`;
my @ansible_hosts = `/bin/cat ${ansible_hosts}`;
my @ansible_hosts_new;

for ( @ansible_hosts ) {
  next if /^\s*\[localdev\]/../^\s*#+\s*End localdev/;
  push( @ansible_hosts_new, $_ ); 
}

if( @vagrant_hosts ) {
  print "Adding hosts to $ansible_hosts\n";
  push( @ansible_hosts_new, "[localdev]\n" );
  for ( @vagrant_hosts ) {
    chomp;
    s/^\s*\S+\s+(\S+)/$1/;
    push( @ansible_hosts_new, "$_\n" )
  }  # Push all Vagrant Hostmanager managed hosts 
  push( @ansible_hosts_new, "# End localdev\n" );
  system( "/bin/cp -a $ansible_hosts ${ansible_hosts}.bkup" );  # Backup original file

  open( my $fh, '>', $ansible_hosts ) or die "Could not open file '$ansible_hosts' $!";
  for ( @ansible_hosts_new ) { print $fh "$_" }
  close $fh;
}


sub usage {
    print "$_\n" for( @_ );
    print STDERR <<"USAGE";
Usage: $0 [-h] 
Desc:  Add hosts to Ansible hosts file
       -f  force
       -h  help
       -l  list
  -f : Option to force execution by skipping the confirmation
       step.
  -h : Show help message.
  -l : Option to list the commands to be run, but NOT perform 
       the installation. This option is useful for problem 
       determination.
USAGE
exit 0;
}   # end sub usage
