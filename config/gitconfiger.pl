#!/bin/env perl
#
# Ron Compos, 08/08/2017

use warnings;
use strict;
use Getopt::Std;
use Cwd;

select( ( select( STDERR ), $| = 1 )[0] );
select( ( select( STDOUT ), $| = 1 )[0] );

my %opt;
getopts( 'h', \%opt );
usage()  if $opt{ h };

my $git_config    = "/root/.gitconfig";

print "Reading $git_config\n";
my @git_config_lines = `/bin/cat ${git_config}`;
my @git_lines;
for ( @git_config_lines ) {
  next if /^\s*$/;
  #print if /## vagrant-hostmanager-start/../## vagrant-hostmanager-end/;
  if ( /^## vagrant-provision-start/../^## vagrant-provision-end/ ) {
    #print "> $_\n";
    next;
  } else {
    #print "+ $_\n";
    push( @git_lines, $_ ) unless /^## vagrant-provision-/; 
  }
}
#for ( @git_lines ) { chomp; print "  $_\n" }  # Print all git lines

print "\n";

my @new_out;

my @new_config = <<'END_HEREDOC';
[
[color]
  branch = auto
  diff = auto
  status = auto
[color "branch"]
  current = yellow reverse
  local = yellow
  remote = green
[color "diff"]
  meta = yellow bold
  frag = magenta bold
  old = red bold
  new = green bold
[color "status"]
  added = yellow
  changed = green
  untracked = cyan
END_HEREDOC


if( @new_config ) {
  print "Adding lines to ${git_config}\n";
  for( @git_lines ) {
    push( @new_out, $_ );
  }
  push( @new_out, "\n## vagrant-provision-start\n" );
  for ( @new_config ) {
    chomp;
    s/^\s*\S+\s+(\S+)/$1/;
    push( @new_out, "$_\n" );
  }
  push( @new_out, "## vagrant-provision-end\n" );

  system( "/bin/cp -a ${git_config} ${git_config}.bkup" );  # Backup original file

  open( my $fh, '>', ${git_config}) or die "Could not open file '${git_config}' $!";
  for ( @new_out ) { print $fh "$_" }
  close $fh;
}


sub usage {
    print "$_\n" for( @_ );
    print STDERR <<"USAGE";
Usage: $0 [-h] 
Desc:  Add lines to .gitconfig
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
