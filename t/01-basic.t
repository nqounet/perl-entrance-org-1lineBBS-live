use Test::More;
use Test::Mojo;

use FindBin;
require "$FindBin::Bin/../myapp.pl";

my $t = Test::Mojo->new;

$t->get_ok('/')
  ->status_is(200)
  ->header_is('X-Powered-By' => 'Mojolicious (Perl)')
  ->content_type_like(qr!text/html!, 'right content type')
  ->content_like(qr!<form!)
;

$t->get_ok('/?body=hoge')
  ->status_is(200)
  ->header_is('X-Powered-By' => 'Mojolicious (Perl)')
  ->content_type_like(qr!text/html!, 'right content type')
  ->content_like(qr!hoge!)
;

my $long_param = 'b' x 11000;
$t->post_form_ok('/' => {body => $long_param})
  ->status_is(200)
  ->header_is('X-Powered-By' => 'Mojolicious (Perl)')
  ->content_type_like(qr!text/html!, 'right content type')
  ->content_like(qr!$long_param!)
;

done_testing;
