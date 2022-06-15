package xpsweb;
use Mojo::Base 'Mojolicious', -signatures;

# This method will run once at server start
sub startup ($self) {

  # Load configuration from config file
  my $config = $self->plugin('NotYAMLConfig');

  # Configure the application
  $self->secrets($config->{secrets});

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('Xpscontroller#displayLogin');
  $r->post('/login')->to('Xpscontroller#validUserCheck');
  $r->any('/logout')->to('Xpscontroller#logout');
   #$r->get('/welcome')->to('Xpscontroller#welcome');
   #$r->get('/missing')->to('Xpscontroller#missing');
     
  my $authorized = $r->under('/')->to('Xpscontroller#alreadyLoggedIn');
}

1;
