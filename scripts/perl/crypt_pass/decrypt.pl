#!/usr/bin/perl

use warnings;
use strict;
use 5.10.0;

print "\nEnter your password: ";
chomp ( my $password = <STDIN> );
my $salt = 'j4';
my $crypt_pass = crypt( $salt, $password );
my @hex_pass = map { sprintf( "%x", ( ord( $_ ) ) ) } split //, $crypt_pass;

say $_ for @hex_pass;

print "Enter your encrypted message: ";
chomp ( my $message = <STDIN> );
my @crypt_message = ( $message =~ m/../g );
say $_ for @crypt_message;

my @hash;
push @hash, @hex_pass until @hash > @crypt_message;

my @decrypted_message;

my $n = 0;
for my $letter ( @crypt_message ){
    push @decrypted_message, ( hex( $letter ) - hex( $hash[$n] ) ) ;
    $n++;
}

say "\n\nYour decrypted message: \n";
print map { chr( $_ ) } @decrypted_message;
print "\n\n";
