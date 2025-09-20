use Irssi;
use Irssi::Irc;
use strict;
use vars qw( $VERSION %IRSSI $DEBUG );
use LWP::Simple;

#
# autobleh is an irssi helper script for IRC Channel OPs
# and IRC Network Staff.
#
# Version:
#   $Id: autobleh.pl 33 2012-01-19 14:52:21Z sysdef $
#
# Contact:
#   email: sysdef@projectnet.org
#   project website: http://autobleh.projectnet.org/
#   support channel: irc://chat.freenode.net/#autobleh
#   repository: https://guest:guest@svn.projectnet.org/svn/autobleh/
#
# This script is licensed under GPL Version 3
# License - http://www.gnu.org/licenses/gpl.html
#
# Please send all your thanks, money, donations, coffee, code, suggestions,
# fixes and patches or hardware to the projects main contact but please
# write an email first.
#
# Sometimes it's possible to directly send gifts to the developer who needs
# the part you want to give away so we can save additional shipment fees.
#
# You will find your thanks and contributions in-kind listed on the project
# website and details on how it was shared and helped our development or
# developers.
#

$VERSION = q$Rev: 33 $;
%IRSSI = (
  authors     => 'Juergen (sysdef) Heine, Tom (tomaw) Wesley, Nathan (nhandler) Handler. Based on auto_bleh.pl by Don Armstrong',
  name        => 'autobleh',
  description => 'Provides /ak /aq /ab /abr /abrn /arn /amb /amr /at /op /topicset /modeset /af',
  license     => 'GPL3',
  changed     => q$Id: autobleh.pl 33 2012-01-19 14:52:21Z sysdef $,
);

# CHANGELOG
# 2012-01-19 - sysdef - renamed example config file; fixed comment char(;) in config ini file
# 2011-02-02 - nhandler - Allow using $nick and $channel in bleh_remove_message
# 2010-12-13 - nhandler - Remove extra space to fix kick command (Thanks rww)
# 2010-12-04 - nhandler - Change bleh_at_stay_opped from 10 to 300 seconds (5 minutes)
# 2010-07-24 - nhandler - Don't hardcode the path to the irssi directory
# 2010-07-23 - nhandler - Add check for updates and bleh_updates setting
# 2010-07-23 - nhandler - Use new ban forward syntax
# 2010-07-23 - nhandler - Turn $DEBUG insto a setting, bleh_debug
# 2010-07-23 - nhandler - Update quiet/ban exceptions
# 2010-07-23 - nhandler - Fix TIMEOUT default to really be 10 minutes
# 2010-07-23 - nhandler - add '/help autobleh' command
# ????-??-?? - tomaw  - add irssi setting bleh_deop_after_action
# 2008-01-08 - sysdef - add irssi setting bleh_remove_message
# 2008-01-08 - sysdef - add command op
# 2008-01-08 - sysdef - add command topicset
# 2008-01-08 - sysdef - add command modeset
# 2008-01-22 - sysdef - solve the 'Unable to find nick: CHANSERV' error
# 2008-01-22 - sysdef - add aliases /remove
# 2008-01-25 - sysdef - add command af (auto forward / forward ban)

# read the config file
open ( CONF, Irssi::get_irssi_dir()."/autobleh.conf" ) or Irssi::print( "warning: '".Irssi::get_irssi_dir()."/autobleh.conf' doesn't exist. Note there is 'autobleh.conf.example'.");
Irssi::print("loading autobleh config ...");
my $category;
my $config;
my $val;
my $key;
my $linecount;
foreach my $line ( <CONF> ) {
  chomp $line;
  $linecount++;
  # filter empty lines
  if ( $line =~ /^\s*$/ ) {
    # Irssi::print("empty: $line");
  }
  # new category
  elsif ( $line =~ /^\[/ ) {
    $line =~ /\[(.*)\]/;
    $category = $1;
    Irssi::print("category: $category");
  }
  # filter comments
  elsif ( $line =~ /^;\s+/ ) {
    # Irssi::print("comment: $line");
  }
  # get key/value pair
  elsif ( $line =~ /^([^ ]+)\s*=\s*([^ ]+)$/ && $category ) {
    Irssi::print( "by config.$linecount: $category '$1' => '$2'" );
    $config->{$category}{$1} = $2;
  }
  # crap line
  else {
    Irssi::print( "PLEASE FIX YOUR CONFIG, LINE $linecount: '$line'" );
  }
}
close CONF;

# unless defined $DEBUG;
Irssi::settings_add_bool( $IRSSI{name}, 'bleh_debug', 1 );
$DEBUG = Irssi::settings_get_bool( 'bleh_debug' );

# Check for updates by default
Irssi::settings_add_bool( $IRSSI{name}, 'bleh_updates', 1 ),
check_updates();

my ( $actions, %defaults );

%defaults = (
  GET_OP       => 1,    # Should we try to get opped when we bleh?
  USE_CHANSERV => 1,    # Should we use chanserv to get opped?
  EXPIRE       => 6000, # Do not try to do anything if the action is more than 6000 seconds old.
  TIMEOUT      => 600,  # Timeout /at bans after 600 seconds (10 minutes)
  DEOP         => 1,    # We want to deop after action
);

my %command_bindings = (

  op               => 'cmd_op',

  ams              => 'cmd_modeset',
  modeset          => 'cmd_modeset',

  ats              => 'cmd_topicset',
  topicset         => 'cmd_topicset',

  af               => 'cmd_af',
  forward          => 'cmd_af',

  ak               => 'cmd_ak',
  kick             => 'cmd_ak',

  ab               => 'cmd_ab',
  ban              => 'cmd_ab',

  aq               => 'cmd_aq',
  quit             => 'cmd_aq',

  ar               => 'cmd_ar',
  remove           => 'cmd_ar',

  abr              => 'cmd_abr',
  removeban        => 'cmd_abr',

  abk              => 'cmd_abk',
  kickban          => 'cmd_abk',

  abrn             => 'cmd_abrn',
  removeban_notice => 'cmd_abrn',

  abkn             => 'cmd_abkn',
  kickban_notice   => 'cmd_abkn',

  arn              => 'cmd_arn',
  remove_notice    => 'cmd_arn',

  amb              => 'cmd_amb',
  massban          => 'cmd_amb',

  amr              => 'cmd_amr',
  massremove       => 'cmd_amr',

  at               => 'cmd_at',
  quiet_temp       => 'cmd_at',

  help             => 'cmd_help',

);

my %bans_to_remove;


sub cmd_help{
  my ( $data, $server, $witem ) = @_;
  if( $data =~ m/^autobleh$/i ) {
    Irssi::print( "/op: Ops teh user given as argument, e.g. /op bofh" );
    Irssi::print( "/ams, /modeset: Sets any mode you want. This is useful for removing bans, e.g. /modeset -b *!*\@trollhost" );
    Irssi::print( "/ats, /topicset: Sets the topic, e.g. /topicset no trolls allowed in here" );
    Irssi::print( "/af, /forward: Sets a forward ban if defined in the config file, e.g. /af sometroll" );
    Irssi::print( "/ak, /kick: Kicks a user, e.g. /ak sometroll" );
    Irssi::print( "/ab, /ban: Sets up a ban on a user's host: /ab sometroll." );
    Irssi::print( "/aq, /quiet: Quiets a user e.g. /aq sometroll" );
    Irssi::print( "/ar, /remove: Remove a user" );
    Irssi::print( "/abr, /removeban: Bans and removes a user from a channel." );
    Irssi::print( "/abk, /kickban: Kickban a user" );
    Irssi::print( "/abrn, /removeban_notice: Bans, removes and sends the user a notice" );
    Irssi::print( "/arn, /remove_notice: Removes the user and sends a notice" );
    Irssi::print( "/amb, /massban: Bans more than one user with one command, e.g. /amb sometroll sometroll2" );
    Irssi::print( "/amr, /massremove: Removes more than one user with one command, e.g. /amr sometroll sometroll2" );
    Irssi::print( "/at, /quiet_temp: Quiets a user for 10 minutes." );
  }
}


sub cmd_op{
  my ( $data, $server, $witem ) = @_;
  #  return get_op($data,$server,$witem);
  return do_bleh( 'op', $data, $server, $witem );
}


sub cmd_modeset{
  my ( $data, $server, $witem ) = @_;
  return do_bleh( 'modeset', $data, $server, $witem );
}


sub cmd_topicset{
  my ( $data, $server, $witem ) = @_;
  return do_bleh( 'topicset', $data, $server, $witem );
}


sub cmd_at{
  my ( $data, $server, $witem ) = @_;
  return do_bleh( 'timeout', $data, $server, $witem );
}


sub cmd_ak{
  my ( $data, $server, $witem ) = @_;
  return do_bleh( 'kick', $data, $server, $witem );
}


sub cmd_af{
  my ( $data, $server, $witem ) = @_;

  if ( defined $config->{forwardban}{$witem->{name}} ) {
    # channel -> $config->{forwardban}{ $witem->{name}}
    my $targetchannel = $witem;
    my $channel = $server->channel_find( $config->{forwardban}{$witem->{name}} );
    if (!$channel) {
      Irssi::print( "Error: i'm not in channel " . $config->{forwardban}{$witem->{name}} . " right now." );
      return;
    }
    # TODO: Check if channel is +i and not +Q
    do_bleh( 'modeset', "+I " . $data, $server, $channel );
    return do_bleh( 'forward, kick', $data, $server, $witem );
  }
  else {
    Irssi::print( 'Error: forward channel for ' . $witem->{name} .' was not set. Please edit section [forwardban] in ~/.irssi/autobleh.conf');
  }
}


sub cmd_abk{
  my ( $data, $server, $witem ) = @_;
  return do_bleh( 'kick,ban', $data, $server, $witem );
}


sub cmd_abkn{
  my ( $data, $server, $witem ) = @_;
  return do_bleh( 'kick,ban,notice', $data, $server, $witem );
}


sub cmd_amb{
  my ( $data, $server, $witem ) = @_;
  my @nicks = split /\s+/, $data;
  for ( @nicks ) {
    next unless /\w/;
    do_bleh( 'ban', $_, $server, $witem );
  }
}


sub cmd_ab{
  my ( $data, $server, $witem ) = @_;
  return do_bleh( 'ban', $data, $server, $witem );
}


sub cmd_aq{
  my ( $data, $server, $witem ) = @_;
  return do_bleh( 'quiet', $data, $server, $witem );
}


sub cmd_amr{
  my ( $data, $server, $witem ) = @_;
  my @nicks = split /\s+/, $data;
  for ( @nicks ) {
    next unless /\w/;
    do_bleh( 'remove', $_, $server, $witem );
  }
}


sub cmd_ar{
  my ( $data, $server, $witem ) = @_;
  return do_bleh( 'remove', $data, $server, $witem );
}


sub cmd_abr{
  my ( $data, $server, $witem ) = @_;
  return do_bleh( 'remove,ban', $data, $server, $witem );
}


sub cmd_abrn{
  my ( $data, $server, $witem ) = @_;
  return do_bleh( 'remove,ban,notice', $data, $server, $witem );
}


sub cmd_arn{
  my ( $data, $server, $witem ) = @_;
  return do_bleh( 'remove,notice', $data, $server, $witem );
}


sub do_bleh{
  my ( $cmd, $data, $server, $witem, $duration ) = @_;

  if ( !$server || !$server->{connected} ) {
    Irssi::print( 'Not connected to server' );
    return;
  }

  # fix the error: "Can't use string ("0") as a HASH ref while "strict refs" in use at..."
  if ( $witem eq 0 ) {
    Irssi::print( 'Can\'t autokick on a non-channel.' );
    return;
  }

  if ( $witem->{type} ne 'CHANNEL' ) {
    Irssi::print( 'Can\'t autokick on a non-channel. [' . $witem->{type} . ']' );
    return;
  }

  # set the network that we're on, the channel and the nick to kick
  # once we've been opped
  $data =~ /^\s*([^\s]+)\s*(\d+)?\s*(.+?|)\s*$/;
  my $nick    = $1;
  my $timeout = $2;
  my $reason  = $3;
  $timeout = $defaults{TIMEOUT} if not defined $timeout or $timeout eq '';

  if ( $cmd =~ /^(topicset|modeset)$/ ) {
    $reason = $nick . ' ' . $reason;
    $nick = "CHANSERV";
  }
  else {
    $reason = Irssi::settings_get_str( 'bleh_remove_message' ) if not defined $reason or $reason eq '';
  }

  $reason =~ s/\$nick/$nick/g;
  $reason =~ s/\$channel/$witem->{name}/g;

  my $nick_rec = $witem->nick_find( $nick );
  if ( $nick ne 'CHANSERV' ) {
    if ( not defined $nick_rec ) {
      Irssi::print( 'Unable to find nick: ' . $nick);
      return;
    }
  }

  my $hostname = $nick_rec->{host} if defined $nick_rec;
  if ( $nick ne 'CHANSERV' ) {
    Irssi::print( 'Unable to find hostname for ' . $nick ) if not defined $hostname or $hostname eq '';
  }
  my $username = $hostname;
  $hostname =~ s/.+\@//;
  $username =~ s/@.*//;
  $username =~ s/.*=//;

  Irssi::print( 'Nick set to \'' . $nick . '\' from \'' . $data . '\', reason set to \'' . $reason . '\'.' ) if $DEBUG;

  my $action = {
    type      => $cmd,
    nick      => $nick,
    nick_rec  => $nick_rec,
    network   => $witem->{server}->{chatnet},
    server    => $witem->{server},
    completed => 0,
    inserted  => time,
    channel   => $witem->{name},
    reason    => $reason,
    hostname  => $hostname,
    username  => $username,
    timeout   => $timeout,
  };

  Irssi::print( i_want( $action ) ) if $DEBUG;

  if ( $witem->{chanop} ) {
    Irssi::print( 'DEBUG: take action ' . $action ) if $DEBUG;
    take_action( $action, $server, $witem );
  }
  else {
    Irssi::print( 'DEBUG: try to get op in ' . $action->{channel} ) if $DEBUG;
    $actions->{$data . $action->{inserted}}=$action;
    get_op( $server, $action->{channel} ) if $defaults{GET_OP};
  }

}


sub get_op{
  my ( $server,$channel) = @_;
  Irssi::print("QUOTE CS op $channel") if $DEBUG;
  $server->command("QUOTE CS op $channel") if $defaults{USE_CHANSERV};
}


sub i_want{
  my $action = shift;
  return 'I\'ve wanted to '
    . $action->{type}    . ' '
    . $action->{nick}    . ' in '
    . $action->{channel} . ' on '
    . $action->{network} . ' since '
    . $action->{inserted};
}


sub take_action {
  my ( $action, $server, $channel ) = @_;

  local $_ = $action->{type};
  # Now support multiple actions against a single nick (to FE, kick ban, or remove ban). See /abr foo

  if ( /op/ ) {
    Irssi::print( 'Give OP only' ) if $DEBUG;
    %defaults->{DEOP} = 0;
  }

  if ( /modeset/ ) {
    Irssi::print( 'Setmode on ' . $action->{channel} ) if $DEBUG;
    # Set channel mode
    $channel->command( '/mode ' . $action->{reason} );
  }

  if ( /topicset/ ) {
    Irssi::print( 'Settopic on ' . $action->{channel} ) if $DEBUG;
    # Set topic
    $channel->command( '/topic ' . $action->{reason} );
    # we have to deop us here becaue we receive no modechange
    if ( Irssi::settings_get_bool( 'bleh_deop_after_action' ) ) {
      Irssi::print( 'MODE ' . $channel->{name} . ' -o ' . $channel->{ownnick}->{nick} ) if $DEBUG;
      $channel->command( '/deop ' . $channel->{ownnick}->{nick} );
    }
  }

  if ( /timeout/ ) {
    if ( $action->{hostname} =~ /(gateway\/shell\/.+\/)x-.+/ || $action->{hostname} =~ /((?:conference|nat)\/.+\/)x-.+/ ) {
      Irssi::print( 'Quieting '
        . $action->{nick}     . ' on '
        . $action->{channel}  . ' with username '
        . $action->{username} . ' for '
        . $action->{timeout}  . ' seconds') if $DEBUG;
      #quiet username
      $channel->command( '/quote MODE ' . $action->{channel} . ' +q *!' . $action->{username} . '@' . $1 . '*' )
        if $action->{username} ne '';
    }
    else {
      Irssi::print( 'Quieting '
        . $action->{nick}     . ' on '
        . $action->{channel}  . ' with hostname '
        . $action->{hostname} . ' for '
        . $action->{timeout}  . ' seconds' ) if $DEBUG;
      #quiet hostname
      $channel->command( '/quote MODE ' . $action->{channel} . ' +q *!*@' . $action->{hostname} )
        if $action->{hostname} ne '';
    }
    $bans_to_remove{"$action->{nick}$action->{inserted}"} = $action;
    # don't deop on a short time
    if ( $action->{timeout} < Irssi::settings_get_str( 'bleh_at_stay_opped' ) ) {
      Irssi::print( 'I\'ll stay opped until unquiet because ' . $action->{timeout} . ' < ' . Irssi::settings_get_str( 'bleh_at_stay_opped' ) ) if $DEBUG;
      %defaults->{DEOP} = 0;
    }
    else {
      Irssi::print( 'I\'ll NOT stay opped until unquiet because ' . $action->{timeout} . ' < ' . Irssi::settings_get_str( 'bleh_at_stay_opped' ) ) if $DEBUG;
    }
  }

  if ( /quiet/ ) {
    if ( $action->{hostname} =~ /(gateway\/shell\/.+\/)x-.+/ || $action->{hostname} =~ /((?:conference|nat)\/.+\/)x-.+/ ) {
      Irssi::print( 'Quieting '
        . $action->{nick}    . ' on '
        . $action->{channel} . ' with username '
        . $action->{username} ) if $DEBUG;
      # Find hostname and quiet username
      $channel->command( '/quote MODE ' . $action->{channel} . ' +q *!' . $action->{username} . '@' . $1 . '*' )
        if $action->{username} ne '';
    }
    else {
      Irssi::print( 'Quieting '
        . $action->{nick}    . ' on '
        . $action->{channel} . ' with hostname '
        . $action->{hostname} ) if $DEBUG;
      # Find hostname and quiet hostname
      $channel->command( '/quote MODE ' . $action->{channel} . ' +q *!*@' . $action->{hostname} )
        if $action->{hostname} ne '';
    }
  }

  if ( /ban/ ) {
    if ( $action->{hostname} =~ /(gateway\/shell\/.+\/)x-.+/ || $action->{hostname} =~ /((?:conference|nat)\/.+\/)x-.+/ ) {
      Irssi::print( 'Banning '
        . $action->{nick}    . ' from '
        . $action->{channel} . ' with username '
        . $action->{username} ) if $DEBUG;
      # ban username
      $channel->command( '/quote MODE ' . $action->{channel} . ' +b *!' . $action->{username} . '@' . $1 . '*' )
        if $action->{username} ne '';
    }
    else {
      Irssi::print( 'Banning '
        . $action->{nick}. ' from '
        . $action->{channel} . ' with hostname '
        . $action->{hostname} ) if $DEBUG;
      # ban hostname
      $channel->command( '/quote MODE ' . $action->{channel} . ' +b *!*@' . $action->{hostname} )
        if $action->{hostname} ne '';
    }
  }

  if ( /set_invite/ ) {
    Irssi::print( 'Set +I for '
      . $action->{nick}    . ' in '
      . $action->{channel} . ' with hostname '
      . $action->{hostname} ) if $DEBUG;
    $channel->command( '/quote MODE ' . $action->{channel} . ' +I ' . $action->{nick} . '!*@' . $action->{hostname} )
      if $action->{hostname} ne '';
  } 


  if ( /forward/ ) {
    if ( defined $config->{forwardban}{$action->{channel}} ) {
      my $fwchan = $config->{forwardban}{$action->{channel}};
      Irssi::print( 'Forward '
        . $action->{nick}    . ' from '
        . $action->{channel} . ' to '
        . $fwchan . ' with hostname '
        . $action->{hostname} ) if $DEBUG;
      # ban hostname
      $channel->command( '/quote MODE ' . $action->{channel} . ' +b ' . $action->{nick} . '!*@' . $action->{hostname} . '$' . ${fwchan} )
        if $action->{hostname} ne '';

      # # invite user to fwchan
      # Irssi::print("INVITE user to $fwchan") if $DEBUG;
      # $channel->command("/quote invite $action->{nick} $fwchan");

      # notice user
      $channel->command( '/NOTICE '
        . $action->{nick}    . ' You got a FORWARD BAN from '
        . $action->{channel} . ' to '
        . $fwchan            . '. Please rejoin channel '
        . $action->{channel} );
    }
    else {
      Irssi::print( 'ATTENTION: add line \'' . $action->{channel} . ' <targetchannel>\' to [forwardban] section in ./irssi/autobleh.conf' );
      return;
    }
  }

  if ( /kick/) {
    Irssi::print( 'Kicking ' 
      . $action->{nick} . ' from '
      . $action->{channel} ) if $DEBUG;
    #wtf? -> if ($action->{reason} =~ /\s/) {
      $channel->command( '/quote KICK ' . $action->{channel} . ' ' . $action->{nick} . ' :' . $action->{reason} );
    #}
    #else {
    #  $channel->command("/quote REMOVE $action->{channel} $action->{nick} $action->{reason}");
    #}
  }

  if ( /remove/ ) {
    Irssi::print( 'Removing '
      . $action->{nick} . ' from '
      . $action->{channel} ) if $DEBUG;
    if ( $action->{reason} =~ /\s/ ) {
      $channel->command( '/quote REMOVE ' . $action->{channel} . ' ' . $action->{nick} . ' :' . $action->{reason} );
    } else {
      $channel->command( '/quote REMOVE ' . $action->{channel} . ' ' . $action->{nick} . ' ' . $action->{reason});
    }
  }

  if ( /notice/ ) {
    Irssi::print( 'Noticing '
      . $action->{nick} . ' with '
      . $action->{reason} ) if $DEBUG;
    $channel->command( '/NOTICE ' . $action->{nick} . ' ' . $action->{reason} );
  }

  if ( /teiuq/ ) {
    if ( $action->{hostname} =~ /(gateway\/shell\/.+\/)x-.+/ || $action->{hostname} =~ /((?:conference|nat)\/.+\/)x-.+/ ) {
      Irssi::print( 'Unquieting '
        . $action->{nick}    . ' on '
        . $action->{channel} . ' with username '
        . $action->{username} ) if $DEBUG;
      $channel->command( '/quote MODE ' . $action->{channel} . ' -q *!' . $action->{username} . '@' . $1 . '*' );
    }
    else {
      Irssi::print( 'Unquieting '
        . $action->{nick}    . ' on '
        . $action->{channel} . ' with hostname '
        . $action->{hostname} ) if $DEBUG;
      $channel->command("/quote MODE $action->{channel} -q *!*@".$action->{hostname});
    }
  }
  return; #for now.
}


sub deop_us{
  my ($rec)   = @_;
  my $channel = $rec->{channel};
  my $server  = $rec->{server};

  Irssi::print( 'MODE ' . $channel->{name} . ' -o ' . $channel->{ownnick}->{nick} ) if $DEBUG;
  $channel->command( '/deop ' . $channel->{ownnick}->{nick} );
}


sub sig_mode_change{
  my ( $channel, $nick ) = @_;

  # Are there any actions to process?
  # See if we got opped.
  return if scalar( keys %$actions ) eq 0;

  my @deop_array;
  if ( $channel->{server}->{nick} eq $nick->{nick} and $nick->{op} ) {
    Irssi::print( 'We\'ve been opped' ) if $DEBUG;
    foreach ( keys %$actions ) {
      # See if this action is too old
      if ( time - $actions->{$_}->{inserted} > $defaults{EXPIRE} ) {
        Irssi::print( 'Expiring action: "' . i_want( $actions->{$_} ) . '" because of timeout' ) if $DEBUG;
        delete $actions->{$_};
        next;
      }
      Irssi::print( i_want( $actions->{$_} ) ) if $DEBUG;
      # Find the server to take action on
      my $server = $actions->{$_}->{server};
      Irssi::print( 'Unable to find server for chatnet: ' . $actions->{$_}->{network} ) and return if not defined $server;
      Irssi::print( 'Found server for chatnet: ' . $actions->{$_}->{network} ) if $DEBUG;
      # Find the channel to take action on
      my $channel = $server->channel_find( $actions->{$_}->{channel} );
      Irssi::print( 'Unable to find channel for channel: ' . $actions->{$_}->{channel} ) and return if not defined $channel;
      Irssi::print( 'Found channel for channel: ' . $actions->{$_}->{channel} ) if $DEBUG;
      Irssi::print( 'We are opped on the channel!' ) if $DEBUG;
      take_action( $actions->{$_}, $server, $channel );
      if ( Irssi::settings_get_bool( 'bleh_deop_after_action' ) and %defaults->{DEOP} eq 1 ) {
        push @deop_array, {server=>$server,channel=>$channel};
      }
      %defaults->{DEOP} = 1;
      # Do not repeat this action.
      delete $actions->{$_};
    }
    foreach ( @deop_array ) {
      deop_us( $_ );
    }
  } else {
    Irssi::print( 'Fooey. Not opped.' ) if $DEBUG;
  }
}


sub try_to_remove_bans{
  return unless keys %bans_to_remove;
  for my $key ( keys %bans_to_remove ) {
    if ( ( $bans_to_remove{$key}{inserted} + $bans_to_remove{$key}{timeout} ) < time ) {
      $bans_to_remove{$key}{type} = 'teiuq';
      $actions->{$key} = $bans_to_remove{$key};
      delete $bans_to_remove{$key};

      # TODO: only try to get op if we're not opped
      # if ($witem->{chanop}) {
      #   Irssi::print("DEBUG: take action $action") if $DEBUG;
      #   take_action($action,$server,$witem);
      # }
      # else {
      #   Irssi::print("DEBUG: try to get op in $action->{channel}") if $DEBUG;
      #   $actions->{$data.$action->{inserted}}=$action;
      #   get_op($server, $action->{channel}) if $defaults{GET_OP};
      # }

      get_op( $actions->{$key}{server}, $actions->{$key}{channel} ) if $defaults{GET_OP};
    }
  }
}


sub check_updates{
  return unless Irssi::settings_get_bool( 'bleh_updates' );
  my $url = 'http://autobleh.projectnet.org/version';
  my $latest = get( $url );
  chomp $latest;
  my( $current ) = $VERSION =~ m/(\d+)/;
  $current = sprintf( "%4.2f", $current / 100 );
  if( defined $latest ) {
    if( $latest > $current ) {
      Irssi::print( 'A new version of autobleh (' . $latest . ') is available at http://autobleh.projectnet.org/downloads/autobleh-' . $latest . '.tar.gz' );
      Irssi::print( 'autobleh ' . $current . ' is currently installed.' );
    }
    else {
      Irssi::print( 'autobleh (' . $current . ') is up-to-date.' );
    }
  }
  else { 
    Irssi::print( 'Failed to check for updates to autobleh.' );
  }
}


# call the try to remove bans function every minute
Irssi::timeout_add( 1000 * 5, 'try_to_remove_bans', undef );
Irssi::signal_add_last( 'nick mode changed', 'sig_mode_change' );
my ( $command, $function );

while ( ( $command, $function ) = each %command_bindings ) {
  Irssi::command_bind( $command, $function, 'bleh' );
}

Irssi::settings_add_bool( $IRSSI{name}, 'bleh_deop_after_action', 1 );
Irssi::settings_add_str(  $IRSSI{name}, 'bleh_remove_message', 'you should know better' );
Irssi::settings_add_str(  $IRSSI{name}, 'bleh_at_stay_opped', 300 ); # 5 minutes

# find text for antispam
#Irssi::signal_add_last( "message public", "msg_public" );

1;

