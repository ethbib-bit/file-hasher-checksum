use warnings;

my $mp5_path = $ARGV[0];

if (not defined $mp5_path) {
  die "input path needed\n";
}

chdir($mp5_path) or die "cannot change to directory: $mp5_path\n\n";

open (LOGDATEI, ">md5log.txt") or die $!;

@fileliste = <$mp5_path/*.md5>;
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
    my (@linesArray, $line);
    my $cmd='md5sum '.$file;

    open(CMD, "$cmd |");
        @linesArray = <CMD>;
    close(CMD);

    my @separate = split " " , $linesArray[0];
    my $md5sum_calc = uc $separate[0];
    if ($md5sum_calc eq $md5sum)
    {
     print LOGDATEI "md5sum of file $file is correct\n";
    }
    else
    {
     print LOGDATEI "calculated md5sum of file $file is not correct! given md5sum is $md5sum, the file calculated md5sum is $md5sum_calc\n";
    }
   } else {
     print LOGDATEI "specified file ".$file." with specified md5sum ".$md5sum." does not exist on filesystem\n";
   }
  } else {
   print LOGDATEI $md5sum." is not a md5 checksum, specified filename in the ".$filename." is ".$file."\n";
  }
 }
}
print LOGDATEI "\n\nEND of ".$filename." file\n\n\n";
}

close (LOGDATEI);

