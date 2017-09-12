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

my $bashrc    = "/root/.bashrc";

print "Reading $bashrc\n";
my @bashrc_lines = `/bin/cat ${bashrc}`;
my @git_lines;
for ( @bashrc_lines ) {
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
[]
# For Git command prompt
[ -f /usr/share/git-core/contrib/completion/git-prompt.sh ] && . /usr/share/git-core/contrib/completion/git-prompt.sh
GIT_PS1_SHOWDIRTYSTATE=true
#export PS1="\u@\h \[\033[32m\]\w\[\033[33m\]\$(__git_ps1)\[\033[00m\] $ "
export PS1="\u@\h \[\033[32m\]\W\[\033[33m\]\$(__git_ps1)\[\033[00m\] $ "

HISTFILESIZE=1048576000
HISTSIZE=

# Aliases
alias ls="ls -G --color=auto"
alias  l='ls -lF'
alias ll='ls -AlF'

set -o vi
END_HEREDOC

if( @new_config ) {
  print "Adding lines to ${bashrc}\n";
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

  system( "/bin/cp -a ${bashrc} ${bashrc}.bkup" );  # Backup original file

  open( my $fh, '>', ${bashrc}) or die "Could not open file '${bashrc}' $!";
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
