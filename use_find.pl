require v5.6.1;

use strict;

use File::Find;
use Cwd;        # For current work directory

my $OS = $^O;
my $cwd = format_path(getcwd);
my ($indir, $outdir) = io_dir(@ARGV, $cwd);
my $log = log_file($0, $outdir);
die "Can't write log file $log: $!\n" unless open(LOG_FILE, ">$log");

print LOG_FILE "Input directory is: " . $indir . "\n";
print LOG_FILE "Output directory is: " . $outdir . "\n";

print LOG_FILE "Task STARTED@" . time_string(1) . "\n";

find(\&want, $indir);

print LOG_FILE "Task ENDED@" . time_string(1) . "\n";
close LOG_FILE;


#------------------------------------------------------
# Functions Implementation
#------------------------------------------------------
#
sub want
{
	my $file = format_path($File::Find::name);
	print LOG_FILE $file . "\n" if $file =~ /$\.doc/;
}


sub io_dir(\@$)
{
	die "io_dir: Parameter error" if $#_ lt 0;
	my $in = $_[0];
	my $out = $in;
	$in = $ARGV[0] if $#ARGV ge 0;
	$out = $ARGV[1] if $#ARGV ge 1;
	die "io_dir: Directory is invalid: $!" unless -d $in and -R $in and -d $out and -W $out;
	return ($in, $out);
}

sub log_file
{
	die "log_file: Parameter error" if $#_ ne 1;
	my($sec, $min, $hour, $day, $mon, $year) = localtime();
	$year += 1900;
	return joint_path($_[1], "$_[0]\." . time_string() . "\.log");
}

sub time_string
{
	my($sec, $min, $hour, $day, $mon, $year) = localtime();
	$year += 1900;
	my $str = "$year$mon$day$hour$min$sec";
	$str = "$year/$mon/$day/$hour/$min/$sec" if $#_ eq 0;
	return $str;
}

sub format_path
{
	return $_[0] unless $OS eq "MSWin32";
	$_[0] =~ s/\//\\/g;
	return $_[0];
}

sub joint_path
{
	my $separator = "\/";  # default for Unix like OS
	if ( $OS eq "MSWin32" )
	{
		$separator = "\\";
	}
	my $jpath = shift(@_);
	foreach my $path (@_)
	{
		$jpath = $jpath . $separator . $path;
	}
	return $jpath;
}
