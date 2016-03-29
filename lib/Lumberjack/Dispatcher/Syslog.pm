use v6.c;

=begin pod

=head1 NAME

Lumberjack::Dispatcher::Syslog - syslog dispatcher for the the Lumberjack logger

=head1 SYNOPSIS

=begin code

=end code

=head1 DESCRIPTION



=end pod

use Lumberjack :FORMAT;
use Log::Syslog::Native;

class Lumberjack::Dispatcher::Syslog does Lumberjack::Dispatcher {

    has Log::Syslog::Native                 $!logger;
    has Str                                 $.ident         =   $*PROGRAM-NAME;
    has Log::Syslog::Native::LogFacility    $.facility      =   Log::Syslog::Native::Local0;
    has Str                                 $.format        =   "[%C - %S] : %M";
    has Int                                 $.callframes    =   4;

    has %.level-map =   Trace => Log::Syslog::Native::Debug,
                        Debug => Log::Syslog::Native::Debug,
                        Info  => Log::Syslog::Native::Info,
                        Warn  => Log::Syslog::Native::Warning,
                        Error => Log::Syslog::Native::Error,
                        Fatal => Log::Syslog::Native::Alert;


    method log(Lumberjack::Message $message) {
        if not $!logger.defined {
            $!logger = Log::Syslog::Native.new(facility => $!facility, ident => $!ident);
        }

        my $formatted-message = format-message($!format, $message, callframes => $!callframes);
        $!logger.log(%!level-map{$message.level}, $formatted-message);
    }
}
# vim: expandtab shiftwidth=4 ft=perl6
