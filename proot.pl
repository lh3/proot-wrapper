#!/usr/bin/env perl

use strict;
use warnings;

die("Usage: proot.pl <rootfs> [cmd] [arguments]\n") if @ARGV == 0;

# look for 'proot'
my $proot = &gwhich('proot') || die("ERROR: failed to find the 'proot' executable\n");

# skip some system mount points
my @skip = ('/', '/usr', '/lib', '/lib64', '/usr/lib', '/usr/lib64', '/usr/local', '/usr/local/lib', '/usr/local/lib64');
my %skip;
$skip{$_} = 1 for (@skip);

# get the list of non-system mount points
my ($fh, @mnt);
open($fh, "/etc/mtab") || die;
while (<$fh>) {
	my @t = split;
	my $last = $t[1];
	next if (defined($skip{$last}));
	system(qq/bash -c "read -t1 < <(stat -t $last 2>&-)"/);
	if ($? == 0) {
		push(@mnt, "-b $last");
	} else {
		warn("Warning: mount point '$last' is stale.\n");
	}
}
close($fh);
push(@mnt, "-b /dev", "-b /proc", "-b $ENV{HOME}", "-b /etc/passwd", "-b /etc/group", "-b /etc/resolv.conf");

# clear existing environment variables because they may interfere with the "VM"
$ENV{PATH} = "/usr/local/bin:/bin:/usr/bin:/sbin";
$ENV{LIBRARY_PATH} = $ENV{LD_LIBRARY_PATH} = "";
$ENV{CPATH} = $ENV{C_INCLUDE_PATH} = $ENV{CPLUS_INCLUDE_PATH} = "";

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
