package xpsweb::Model::Database;
use Mojo::Base -base;

has 'mysql';

#取回所有的推荐信
sub fetch_all_testimonials{shift->mysql->db->query('SELECT * FROM xpsweb_testimonials ORDER BY published_on DESC')->hashes->to_array}

#提交新的推荐信到数据库
sub publish_testimonial{

    my($self, $new_testimonial, $username) = @_;
    my $sql = 'INSERT INTO xpsweb_testimonials(published_by,testimonial) VALUES (?,?)';

    $self->mysql->db->query($sql, $username, $new_testimonial);
}

1;
