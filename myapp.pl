#!/usr/bin/env perl
use utf8;
use Mojolicious::Lite;

get '/' => sub {
  my ($self) = @_;
  $self->render(
    template => 'index',
  );
};

post '/post' => sub {
  my ($self) = @_;
  my $body = $self->param('body');
  my $base_dir = $self->app->home->detect;
  my $datafile = qq{$base_dir/myapp.dat};
  open my $fh, '>>', $datafile or die $!;
  print $fh qq{$body\n};
  close $fh;
  $self->render(
    body => $body,
    template => 'post',
  );
};

app->start;
__DATA__

@@ form.html.ep
%= form_for '/post' => (method => 'POST') => begin
  %= text_field 'body', size => 50, autofocus => 'autofocus'
  %= submit_button '投稿する'
% end

@@ index.html.ep
% layout 'default';
% title '入力フォーム';
%= include 'form';

@@ post.html.ep
% layout 'default';
% title '出力';
%= include 'form';
<p><%= $body %></p>

@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
  <head><title><%= title %> - #Perl入学式 1行掲示板</title></head>
  <body><%= content %></body>
</html>
