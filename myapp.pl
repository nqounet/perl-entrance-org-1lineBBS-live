#!/usr/bin/env perl
use utf8;
use Mojolicious::Lite;
use Encode;

helper datafile => sub {
  my ($self) = @_;
  my $base_dir = $self->app->home->detect;
  my $datafile = qq{$base_dir/myapp.dat};
  return $datafile;
};

get '/' => sub {
  my ($self) = @_;
  my $datafile = $self->datafile;
  open my $fh, '<', $datafile or die $!;
  my @entries = <$fh>;
  close $fh;
  @entries = map { decode_utf8($_) } reverse @entries;
  $self->render(
    entries  => \@entries,
    template => 'index',
  );
};

post '/post' => sub {
  my ($self) = @_;
  my $body = $self->param('body');
  my $datafile = $self->datafile;
  open my $fh, '>>', $datafile or die $!;
  print $fh encode_utf8(qq{$body\n});
  close $fh;
  $self->redirect_to('/');
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
% for my $entry (@{$entries}) {
  <p><%= $entry %></p>
% }

@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
  <head><title><%= title %> - #Perl入学式 1行掲示板</title></head>
  <body><%= content %></body>
</html>
