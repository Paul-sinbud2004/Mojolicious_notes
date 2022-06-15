package xpsweb;
use Mojo::Base 'Mojolicious';
use Mojo::mysql;
use xpsweb::Model::Database;

# This method will run once at server start
sub startup{
  my $self = shift;
  # Load configuration from config file
  my $config = $self->plugin('NotYAMLConfig');

  # Configure the application
  $self->secrets($config->{secrets});
  
  # 设置数据库连接
  $self->helper(mysql => sub{state $mysql=Mojo::mysql->new(shift->config('mysql'))});
  $self->helper(dbhandle=>
      sub{state $vikidb=xpsweb::Model::Database->new(mysql=>shift->mysql)});

  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('Xpscontroller#displayLogin');
  $r->post('/login')->to('Xpscontroller#validUserCheck');
  $r->any('/logout')->to('Xpscontroller#logout');
   #$r->get('/welcome')->to('Xpscontroller#welcome');
     
  my $authorized = $r->under('/')->to('Xpscontroller#alreadyLoggedIn');

  $authorized->get('/testimonials')->to('Xpscontroller#loadTestimonials');
  $authorized->post('/testimonials')->to('Xpscontroller#saveTestimonial');
}

1;
