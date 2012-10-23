use Test::More;
use Test::Mojo;

use FindBin;
require "$FindBin::Bin/../myapp.pl";

my $t = Test::Mojo->new;

# トップページ
$t->get_ok('/')
  ->status_is(200)
  ->header_is('X-Powered-By' => 'Mojolicious (Perl)')
  ->content_type_like(qr!text/html!, 'right content type')
  ->content_like(qr!<form!)
;

# フォームの投稿
$t->ua->max_redirects(1);
$t->post_form_ok('/post' => {body => 'hoge'})
  ->status_is(200)
  ->header_is('X-Powered-By' => 'Mojolicious (Perl)')
  ->content_type_like(qr!text/html!, 'right content type')
  ->content_like(qr!<p>hoge\s*</p>!)
;

# 長い文字列の投稿
my $long_param = 'b' x 11000;
$t->post_form_ok('/post' => {body => $long_param})
  ->status_is(200)
  ->header_is('X-Powered-By' => 'Mojolicious (Perl)')
  ->content_type_like(qr!text/html!, 'right content type')
  ->content_like(qr!<p>$long_param\s*</p>!)
;

done_testing;
