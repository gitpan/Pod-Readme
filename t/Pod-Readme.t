#!/usr/bin/perl

use strict;

use Test::More;

my %L_ARGS = (
  'http://www.cpan.org/' => undef,
  'ftp://www.cpan.org/'  => undef,
  'news://www.cpan.org/' => undef,
  'Some::Module'         => undef,
  'Some::Module/section' => 'Some::Module',
  'Module'               => undef,
  'Module/section'       => 'Module',
  '/Section'             => 'Section',
  'Text|Module'          => 'Text',
  'Text|Module/section'  => 'Text',
  'Text|http://www.cpan.org/' => 'Text',
  'Text|ftp://www.cpan.org/'  => 'Text',
  'Text|news://www.cpan.org/' => 'Text',
);

my @TYPES = qw( readme copying install hacking todo license );

plan tests => 2 + (19 * scalar(@TYPES)) + scalar(keys %L_ARGS);

use_ok("Pod::Readme");


# TODO - test other document types than "readme"

foreach my $type (@TYPES) {
  my $p = Pod::Readme->new( readme_type => $type );
  ok(defined $p, "new");

  ok($p->{readme_type} eq $type, "readme_type");
  ok(!$p->{README_SKIP}, "README_SKIP");

  # TODO - test output method

  $p->cmd_for("$type stop");
  ok($p->{README_SKIP}, "$type stop");
  $p->cmd_for("$type continue");
  ok(!$p->{README_SKIP}, "$type continue");

  $p->cmd_for("$type stop");
  ok($p->{README_SKIP}, "$type stop");
  $p->cmd_for("$type");
  ok(!$p->{README_SKIP}, "$type");

  $p->cmd_for("$type stop");
  ok($p->{README_SKIP}, "$type stop");
  $p->cmd_begin("$type");
  ok(!$p->{README_SKIP}, "begin $type");
  $p->cmd_end("$type");

  $p->cmd_for("foobar stop");
  ok(!$p->{README_SKIP}, "foobar stop");
  $p->cmd_for("foobar continue");
  ok(!$p->{README_SKIP}, "foobar continue");
  $p->cmd_for("foobar stop");
  ok(!$p->{README_SKIP}, "foobar stop");
  $p->cmd_for("foobar");
  ok(!$p->{README_SKIP}, "foobar");

  $p->cmd_for("$type,foobar stop");
  ok($p->{README_SKIP}, "$type,foobar stop");
  $p->cmd_for("$type,foobar continue");
  ok(!$p->{README_SKIP}, "$type,foobar continue");

  $p->cmd_for("$type,foobar stop");
  ok($p->{README_SKIP}, "$type,foobar stop");
  $p->cmd_for("$type,foobar");
  ok(!$p->{README_SKIP}, "$type,foobar");

  $p->cmd_for("$type,foobar stop");
  ok($p->{README_SKIP}, "$type,foobar stop");
  $p->cmd_begin("$type,foobar");
  ok(!$p->{README_SKIP}, "begin $type,foobar");
  $p->cmd_end("$type,foobar");

}

# TODO - test for readme include

{
  my $p = Pod::Readme->new();
  ok(defined $p, "new");

  foreach my $arg (sort keys %L_ARGS) {
    my $exp = $L_ARGS{$arg} || $arg;
    my $r   = $p->seq_l($arg);
    ok($r eq $exp, "L<$arg>");
    # print STDERR "\x23 $r\n";
  };
  
}
