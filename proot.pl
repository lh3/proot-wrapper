#!/usr/bin/env perl

use strict;
use warnings;

die("Usage: proot.pl <rootfs> [cmd] [arguments]\n") if @ARGV == 0;

# look for 'proot'
my $proot = &gwhich('proot') || die("ERROR: failed to find the 'proot' executable\n");

# skip some system mount points
my @skip = ('/', '/usr', '/lib', '/lib64', '/usr/lib', '/usr/lib64');
my %skip;
$skip{$_} = 1 for (@skip);

# get the list of non-system mount points
my ($fh, @mnt);
open($fh, "df -P |") || die;
while (<$fh>) {
	next if $. == 1;
	my @t = split;
	my $last = $t[@t-1];
	push(@mnt, "-b $last") unless defined($skip{$last});
}
push(@mnt, "-b /dev", "-b /proc", "-b $ENV{HOME}", "-b /etc/passwd", "-b /etc/group");
close($fh);

# run
my $rootfs = shift(@ARGV);
exec $proot, "-r $rootfs", @mnt, @ARGV;

# misc

sub which {
	my $file = shift;
	my $path = (@_)? shift : $ENV{PATH};
	return if (!defined($path));
	foreach my $x (split(":", $path)) {
		$x =~ s/\/$//;
		return "$x/$file" if (-x "$x/$file") && (-f "$x/$file");
	}
	return;
}

sub gwhich {
    my $progname = shift;
    my $addtional_path = shift if (@_);
    my $dirname = &dirname($0);
    my $tmp;

    chomp($dirname);
    if ($progname =~ /^\// && (-x $progname) && (-f $progname)) {
        return $progname;
    } elsif (defined($addtional_path) && ($tmp = &which($progname, $addtional_path))) {
        return $tmp;
    } elsif (defined($dirname) && (-x "$dirname/$progname") && (-f "$dirname/$progname")) {
        return "$dirname/$progname";
    } elsif ((-x "./$progname") && (-f "./$progname")) {
        return "./$progname";
    } elsif (($tmp = &which($progname))) {
        return $tmp;
    } else {
        return;
    }
}

sub dirname {
	my $prog = shift;
	return '.' unless ($prog =~ /\//);
	$prog =~ s/\/[^\s\/]+$//g;
	return $prog;
}
