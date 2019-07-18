# File Hasher Checksum Checker

Compares files in a directory with the md5 data supplied in an md5 file originally generated with the Windows tool [MD5 File Hasher](http://www.digital-tronic.com/md5-file-hasher/). Used to check whether or not files have been modified compared with md5 sums in md5-file.

## Application use

`perl md5processor.pl [absolute path]`

An absolute path the to the directory containing files and .md5 file has to be supplied

## Current Version: 1.2.1

### History

### 1.2.1

* new project owner (Lars Händler)
* Extensive in-code documentation
* Readme file update
* Deploy version for github generated

### 1.20 (2019-05-22)

* final version
* check if .md5 file exists
* check if all files listed in .md5 file exist
* check if there are more files in directory than in .md5 file
* log file generation

### 1.00 (2019-05-16)

* compare md5 sum of files in directory with sums listed in .md5 file
* parsing of .md5 file
* initial setup
