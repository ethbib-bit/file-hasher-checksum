#!/usr/bin/perl

# Repository: https://bitbucket.org/ethbib_bit/file-hasher-checksum
# Autor: mschwalm
#
use strict;
use warnings;

$|=1;

# use Digest::MD5::File qw(md5 md5_hex md5_base64);
# my $md5 = Digest::MD5->new;
my $mp5_path = $ARGV[0];

if (not defined $mp5_path) {
  die "input path needed\n";
}

chdir($mp5_path) or die "cannot change to directory: $mp5_path\n\n";

opendir(DIR, $mp5_path) or die "cannot open directory $mp5_path\n\n";
# grep all ., .md5 and md5log files
my @alldirfiles = grep(!/^md5log_[0-9]+.txt/,grep(!/.md5$/,grep {!/^\./} readdir(DIR)));
closedir(DIR) or die "cannot close directory $mp5_path\n\n";

my $md5log_file = "md5log_".time().".txt";
open (LOGDATEI, '>', $md5log_file) or die $!;

my @fileliste = <$mp5_path/*.md5>;
my $filename = "";
foreach $filename (@fileliste) {
  print LOGDATEI $filename." md5 file found\n\n";

  open(my $data, '<', $filename) or die "Could not open '$filename' $!\n";

  while (my $line = <$data>) {
  # die md5 Datei durchgehen
  chomp $line;

  my @fields = split " " , $line;

  if (@fields == 2)
  {
  my $md5sum = uc $fields[0];
  my $file = $fields[1];

  if ($md5sum =~ /^[0-9A-Z]+$/)
  {
   if (-e $file)
   {
    # delete md5 file from founded directory files
    #foreach $item (@del_indexes) {
    my $numalldirfiles = @alldirfiles;
    for ( my $inx = 0; $inx < $numalldirfiles; $inx++ ) {
      if ($file eq $alldirfiles[$inx]) {
       # delete the file with was found in the .md5 from the directory file list
       splice(@alldirfiles,$inx,1);
       last;
      }
    }

    my (@linesArray, $line);
    my $cmd='md5sum '.$file;

    open(CMD, "$cmd |");
        @linesArray = <CMD>;
    close(CMD);

    my @separate = split " " , $linesArray[0];
    my $md5sum_calc = uc $separate[0];
    if ($md5sum_calc eq $md5sum)
    {
     print LOGDATEI "md5sum of file $file is correct!\n";
    }
    else
    {
     print LOGDATEI "calculated md5sum of file $file is not correct! given md5sum is $md5sum, the file calculated md5sum is $md5sum_calc\n";
    }
   } else {
     print LOGDATEI "specified file ".$file." with specified md5sum ".$md5sum." do not exist on filesystem\n";
   }
  } else {
   print LOGDATEI $md5sum." is not a md5 checksum, specified filename in the ".$filename." is ".$file."\n";
  }
 }
}
my $item = "";
my $md5filename=substr($filename,rindex($filename,'/')+1);
print "path=".$mp5_path." ".$md5filename." ".$md5log_file."\n";
foreach $item (@alldirfiles) {
  if ($item ne $md5filename) {
     print LOGDATEI $item." file in directory but not in ".$filename." file!\n";
  }
}

print LOGDATEI "\n\nEND of ".$filename." file\n\n\n";
}

close (LOGDATEI);

