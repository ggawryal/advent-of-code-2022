#!/usr/bin/perl
use strict;
use warnings;

my $input = 'input/day7.in';
open my $info, $input or die "Could not open $input: $!";

my %subdirs = ();
my %sizes = ();
my %isDir = ();
my @pwd = ();

while(my $line = <$info>)  {
    $line = substr $line, 0, -1;
    if($line =~ /^\$/)  {
        my $command = substr $line, 2;
        if($command =~ /^cd/) {
            my $path = substr $command, 3;
            if($path eq "..") {
                if(@pwd > 0) {
                    pop(@pwd);
                }
            }
            elsif($path eq "/") {
                @pwd = ();
            }
            else {
                my $prevDir = "/" . (join "/", @pwd);
                push(@pwd, $path);
                push @{$subdirs{$prevDir}}, ("/" . (join "/", @pwd));
            } 
        } 
    }
    else {
        if($line =~ /^dir/) {
            my $dirName = substr $line, 4;
            my $pathToDir = "/" . (join "/", @pwd, $dirName);
            $isDir{$pathToDir} = 1;
        }
        else {
            if($line =~ /(\d*)\s*(.*)/i) {
                my $size = $1;
                my $name = $2;
                my $curDir = "/" . (join "/", @pwd);
                my $pathToFile = "/" . (join "/", @pwd, $name);
                $isDir{$pathToFile} = 0;
                $sizes{$pathToFile} = $size;
                push @{$subdirs{$curDir}}, $pathToFile;
            }
        }
    }
}
close $info;

sub uniq {
    my %seen;
    grep !$seen{$_}++, @_;
}

sub calcSizeOfDirs {
    my $curDir = $_[0];
    if (not exists $sizes{$curDir}) {
         $sizes{$curDir} = 0;
    }
    foreach(uniq @{$subdirs{$curDir}}) {
        my $sub = $_;
        calcSizeOfDirs($sub);
        $sizes{$curDir} = $sizes{$curDir} + $sizes{$sub};
    }
}



calcSizeOfDirs "/";

my $res = 0;
while ( (my $k, my $v) = each %sizes ) {
    if($isDir{$k} and $v <= 100000) {
        $res += $v; 
    }
}

print "$res\n";


my $total = 70000000;
my $needed = 30000000;
my $used = $sizes{"/"};

my $res2 = $total;

while ( (my $k, my $v) = each %sizes ) {
    if($isDir{$k} and $total-$used+$v >= $needed and $res2 > $v) {
        $res2 = $v; 
    }
}

print "$res2\n";