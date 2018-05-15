#
class profile::app::sensu::handlers (
  String $mailer_from,
  Array  $mailer_to,
  String $hipchat_url,
  String $hipchat_apikey,
  String $hipchat_room,
  String $hipchat_from,
  String $hipchat_message_template,
){

  package { 'mailx':
      ensure   => 'present',
      provider => 'yum'
  }

  sensu::handler { 'default':
    type     => 'set',
    handlers => [ 'stdout', 'mailer', 'hipchat'],
  }

  sensu::handler { 'stdout':
    type    => 'pipe',
    command => 'cat',
  }

  sensu::handler { 'mailer':
    type    => 'pipe',
    command => 'handler-mailer.rb',
    config  => {
      admin_gui => "http://${::fqdn}:3000",
      mail_from => $mailer_from,
      mail_to   => $mailer_to,
    },
    filters => [ 'state-change-only' ],
  }

  file { '/opt/sensu_template.erb':
    ensure  => 'present',
    content => $hipchat_message_template,
    replace => 'no',
    mode    => '0644',
  }

  sensu::handler { 'hipchat':
    command => 'handler-hipchat.rb',
    config  => {
      'server_url'       => $hipchat_url,
      'apikey'           => $hipchat_apikey,
      'apiversion'       => 'v2',
      'room'             => $hipchat_room,
      'from'             => $hipchat_from,
      'message_template' => '/opt/sensu_template.erb'
    },
    filters => [ 'state-change-only' ],
  }

  sensu::filter { 'state-change-only':
    negate     => false,
    attributes => {
      occurrences => "eval: value == 1 || ':::action:::' == 'resolve'",
    },
  }
}
