package xpsweb::Controller::Xpscontroller;
use Mojo::Base 'Mojolicious::Controller';

# This action will render a template
sub welcome{
  my $self = shift;
  # Render template "example/welcome.html.ep" with message
  $self->render(msg => '欢迎访问采用Mojolicious实时架构的网站',template => "xpsTemplates/homepage");
}

#检查是否登录，如无跳转到登录页面
sub alreadyLoggedIn {
    my $self = shift;
    if($self->session('is_auth')){
      return 1;
    };
    $self->render(template => "xpsTemplates/login", error_message=>"未登录，请登录后访问此页面");
    return 0;
}

sub displayLogin{
   my $self = shift;
   #if( &alreadyLoggedIn($self) ){   ##This statement leads to Error, but seems good logically. Maybe Line 17 conflicts with line 27.
   if($self->session('is_auth')){
      &welcome($self);
   }else{
      $self->render(template => "xpsTemplates/login",error_message => "请登录后访问此页面");
   }
}

#用户名与密码合法性检查
sub validUserCheck {
    my $self = shift;
    #假定一组用户
    my %validUsers = ("JANE"=>"w123",
               "PAUL"=>"a1234",
		         "TOM"=>"t123",    
                    );
    #获取页面上填入的信息
    my $user = uc $self->param('username');
    my $password = $self->param('pass');

    #检测用户是否存在
    if($validUsers{$user}){
       if($validUsers{$user} eq $password){
          $self->session(is_auth => 1);
	       $self->session(username => $user);
	       $self->session(expiration => 600);
	       &welcome($self);
       }else{
          $self->render(template => "xpsTemplates/login",error_message=>"错误的密码，请重试");
       }
    }else{
       $self->render(template => "xpsTemplates/login",error_message=>"非会员，请离开！");
    }
}

#登出
sub logout{
    my $self = shift;
    $self->session(expires => 1);
    $self->render(template => "xpsTemplates/logout");
}

#将感谢信加载到模板页面
sub loadTestimonials{
   my $self = shift;
   my $all_testimonials_html;

   foreach my $all_testimonials (@{$self->dbhandle->fetch_all_testimonials}){
      $all_testimonials_html .= "<tr><td>".
           $all_testimonials->{testimonial}.
           "</br></br><div style='test-align:right;'><i>".
            $all_testimonials->{published_by}.
            "</br>".
            $all_testimonials->{published_on}.
            "</i></div></td></tr>";
   }
   $self->render(template=>'xpsTemplates/managetestimonials',msg=>'查看感谢信',alltestimonials=>$all_testimonials_html);
}

#提交感谢信
sub saveTestimonial{
   my $self = shift;
   my $new_testimonial = $self->param('userReview');
   my $user = $self->session('username');

   $self->dbhandle->publish_testimonial($new_testimonial,$user);
   &loadTestimonials($self);
}

1;
