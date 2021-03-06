package MemberSite::Form::Introduction;
use HTML::FormHandler::Moose;
use MemberSite::Model::DB;

extends 'HTML::FormHandler';

has '+item_class' => ( default => 'Introduction::Item' );

has_field 'username' => (
	type => 'Text',
    wrapper_class => ['form-group'],
    element_class => ['form-control'],    
    validate_method => \&username_unique,
    minlength => 4,
    maxlength => 18,
	required => 1,
);

sub username_unique {
    my $self = shift;
    my $schema = MemberSite::Model::DB->new;
    $schema->connect;
    if ($schema->resultset('Member')->search(username => $self->value)->count) {
        $self->add_error('This username is taken!');
    }
}

has_field 'password' => (
	type => 'Password',
    wrapper_class => ['form-group'],
    element_class => ['form-control'],    
    validate_method => \&password_regex,
	required => 1,
);

has_field 'repeat_password' => (
    type => 'Password',
    wrapper_class => ['form-group'],
    element_class => ['form-control'],    
	required => 1,
);

sub password_regex {
    my $self = shift;
    unless ($self->value =~ m/\w/ and $self->value =~ m/\d/) {
        $self->add_error('Password is too weak.');        
    }
}

sub validate {
    my $self = shift;    
    unless ($self->field('password')->value eq $self->field('repeat_password')->value) {
        $self->field('repeat_password')->add_error('Passwords entered are not the same.');        
    }
}

sub password_validation {
    my $self = shift;
    if (password_regex($self)) {
        if(repeat_password($self)) {
            return 1;
        }
    }
    
    return;
}

has_field 'email' => (
	type => 'Email',
    wrapper_class => ['form-group'],
    element_class => ['form-control'],    
    validate_method => \&email_unique,
	required => 1,
);

sub email_unique {
    my $self = shift;
    my $schema = MemberSite::Model::DB->new;
    $schema->connect;
    if ($schema->resultset('Member')->search(email => $self->value)->count) {
        $self->add_error('This email is in use!');
    }
}

has_field 'surname' => (
	type => 'Text',
    wrapper_class => ['form-group'],
    element_class => ['form-control'],
	required => 1,
);

has_field 'given_name' => (
	type => 'Text',
    wrapper_class => ['form-group'],
    element_class => ['form-control'],    
	required => 1,
);

has_field 'submit' => (
	type => 'Submit',
	value => 'Submit',
    wrapper_class => ['form-group'],
	element_attr => {
		class => ['row', 'btn', 'btn-default', 'pull-right'],
	},
    tags => { 
		wrapper_tag => 'div',        
	},
);

1;