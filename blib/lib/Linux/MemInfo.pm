package Linux::MemInfo;

use 5.008;
use strict;
use warnings;

require Exporter;
use AutoLoader qw(AUTOLOAD);

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Linux::MemInfo ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw( get_mem_info
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw( get_mem_info
);

our $VERSION = '0.01';


# Preloaded methods go here.

# Autoload methods go after =cut, and are processed by the autosplit program.

sub get_mem_info() {
    my %mem;
    open(INFIL,"/proc/meminfo") || die("Unable To Open /proc/meminfo\n");
    NXTMI: foreach(<INFIL>) {
        if( m/^Mem:(\s+)(\S+)(\s+)(\S+)(\s+)(\S+)(\s+)(\S+)(\s+)(\S+)(\s+)(\S+)/ ) {
            $mem{mem_total}   = $2;
            $mem{mem_used}    = $4;
            $mem{mem_free}    = $6;
            $mem{mem_shared}  = $8;
            $mem{mem_buffers} = $10;
            $mem{mem_cached}  = $12;
            next NXTMI;
        }
        elsif( m/^Swap:(\s+)(\S+)(\s+)(\S+)(\s+)(\S+)/ ) {
            $mem{swap_total} = $2;
            $mem{swap_used} = $4;
            $mem{swap_free} = $6;
            next NXTMI;
        }
        elsif( m/^(\S+):(\s+)(\S+) (\S+)/ ) {
            my $unit = $1 . "_unit";
            $mem{$1} = $3;
            $mem{$unit} = $4;
            next NXTMI;
        }
    }
    close(INFIL);
    return %mem
}


1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Linux::MemInfo - Perl extension for accessing /proc/meminfo

=head1 SYNOPSIS

  use Linux::MemInfo;

=head1 ABSTRACT

  This module will allow you to easily extract the fields out of the
  /proc/meminfo file.  All of the fields are stored in a hash.

=head1 DESCRIPTION

    %mem = get_mem_info
    foreach(sort keys %mem) {
        printf("%-20s\t%s\n",$_,$mem{$_});
    }

    Would yield the following:
    Active                  371368 
    ActiveAnon              104980 
    ActiveAnon_unit         kB 
    ActiveCache             266388 
    ActiveCache_unit        kB 
    Active_unit             kB 
    Buffers                 80968 
    Buffers_unit            kB 
    Cached                  272400 
    Cached_unit             kB 
    HighFree                0 
    HighFree_unit           kB 
    HighTotal               0 
    HighTotal_unit          kB 
    Inact_clean             9976 
    Inact_clean_unit        kB 
    Inact_dirty             0 
    Inact_dirty_unit        kB 
    Inact_laundry           75480 
    Inact_laundry_unit      kB 
    Inact_target            91364 
    Inact_target_unit       kB 
    LowFree                 11172 
    LowFree_unit            kB 
    LowTotal                512540 
    LowTotal_unit           kB 
    MemFree                 11172 
    MemFree_unit            kB 
    MemShared               0 
    MemShared_unit          kB 
    MemTotal                512540 
    MemTotal_unit           kB 
    SwapCached              6768 
    SwapCached_unit         kB 
    SwapFree                505096 
    SwapFree_unit           kB 
    SwapTotal               522072 
    SwapTotal_unit          kB 
    mem_buffers             82911232 
    mem_cached              285868032 
    mem_free                11440128 
    mem_shared              0 
    mem_total               524840960 
    mem_used                513400832 
    swap_free               517218304 
    swap_total              534601728 
    swap_used               17383424 
    
    The raw data looks like this:
            total:    used:    free:  shared: buffers:  cached:
    Mem:  524840960 510504960 14336000        0 81543168 283406336
    Swap: 534601728 17448960 517152768
    MemTotal:       512540 kB
    MemFree:         14000 kB
    MemShared:           0 kB
    Buffers:         79632 kB
    Cached:         269932 kB
    SwapCached:       6832 kB
    Active:         371352 kB
    ActiveAnon:     106300 kB
    ActiveCache:    265052 kB
    Inact_dirty:         0 kB
    Inact_laundry:   73628 kB
    Inact_clean:      9296 kB
    Inact_target:    90852 kB
    HighTotal:           0 kB
    HighFree:            0 kB
    LowTotal:       512540 kB
    LowFree:         14000 kB
    SwapTotal:      522072 kB
    SwapFree:       505032 kB
 


=head1 SEE ALSO

None

=head1 AUTHOR

Chad Kerner, E<lt>chadkerner@yahoo.com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2003 by Chad Kerner

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
