# Description:
# Puppet module for configuring the squid caching service.
# 
# Usage:
# The set up a simple squid server with a cache to forward
# http port 80 requests.
# 
# class { 'squid': }
# squid::acl { 'Safe_ports':
#   type    => port,
#   entries => ['80'],
# }
# squid::http_access { 'Safe_ports':
#   action => allow,
# }
# squid::http_access{ '!Safe_ports':
#   action => deny,
# }
# 
# This module will set the SELINUX-context for the cache_dir and/or port, requires puppet-selinux (https://github.com/voxpupuli/puppet-selinux)
# 
# # Parameters for squid Class
# Parameters to the squid class almost map 1 to 1 to squid.conf parameters themselves.
# 
# `ensure_service` The ensure value of the squid service, defaults to `running`.
# `enable_service` The enable value of the squid service, defaults to `true`.
# `config` Location of squid.conf file, defaults to `/etc/squid/squid.conf`.
# `config_user` user which owns the config file, default depends on `$operatingsystem`
# `config_group` group which owns the config file, default depends on `$operatingsystem`
# `daemon_user` user which runs the squid daemon, this is used for ownership of the cache directory, default depends on `$operatingsystem`
# `daemon_group` group which runs the squid daemon, this is used for ownership of the cache directory, default depends on `$operatingsystem`
# `cache_mem` defaults to `256 MB`. http://www.squid-cache.org/Doc/config/cache_mem/
# `cache_replacement_policy` defaults to undef. http://www.squid-cache.org/Doc/config/cache_replacement_policy/
# `memory_replacement_policy` defaults to undef. (http://www.squid-cache.org/Doc/config/memory_replacement_policy/
# `memory_cache_shared` defaults to undef. http://www.squid-cache.org/Doc/config/memory_cache_shared/.
# `maximum_object_size_in_memory` defaults to `512 KB`. http://www.squid-cache.org/Doc/config/maximum_object_size_in_memory/
# 
# `url_rewrite_program` defaults to undef http://www.squid-cache.org/Doc/config/url_rewrite_program/
# `url_rewrite_children` defaults to undef http://www.squid-cache.org/Doc/config/url_rewrite_children/
# `url_rewrite_child_options` defaults to undef http://www.squid-cache.org/Doc/config/url_rewrite_children/
# `access_log` defaults to `daemon:/var/logs/squid/access.log squid`. http://www.squid-cache.org/Doc/config/access_log/
# `coredump_dir` defaults to undef. http://www.squid-cache.org/Doc/config/coredump_dir/
# `error_directory` defaults to undef. http://www.squid-cache.org/Doc/config/error_directory/
# `err_page_stylesheet` defaults to undef. http://www.squid-cache.org/Doc/config/err_page_stylesheet/
# `package_name` name of the squid package to manage, default depends on `$operatingsystem`
# `package_ensure` package status and/or version, default to present
# `service_name` name of the squid service to manage, default depends on `$operatingsystem`
# `max_filedescriptors` defaults to undef. http://www.squid-cache.org/Doc/config/max_filedescriptors/
# `workers` defaults to undef. http://www.squid-cache.org/Doc/config/workers/
# `snmp_incoming_address` defaults to undef. Can be set to an IP address to only listen for snmp requests on an individual interface. http://www.squid-cache.org/Doc/config/snmp_incoming_address/
# `buffered_logs` defaults to undef. http://www.squid-cache.org/Doc/config/buffered_logs/
# `acls` defaults to undef. If you pass in a hash of acl entries, they will be defined automatically. http://www.squid-cache.org/Doc/config/acl/
# `visible_hostname` defaults to undef. http://www.squid-cache.org/Doc/config/visible_hostname/
# `via` defaults to undef. http://www.squid-cache.org/Doc/config/via/
# `httpd_suppress_version_string` defaults to undef. http://www.squid-cache.org/Doc/config/httpd_suppress_version_string/
# `forwarded_for` defaults to undef. supported values are "on", "off", "transparent", "delete", "truncate". http://www.squid-cache.org/Doc/config/forwarded_for/
# `http_access` defaults to undef. If you pass in a hash of http_access entries, they will be defined automatically. http://www.squid-cache.org/Doc/config/http_access/
# `http_ports` defaults to undef. If you pass in a hash of http_port entries, they will be defined automatically. http://www.squid-cache.org/Doc/config/http_port/
# `https_ports` defaults to undef. If you pass in a hash of https_port entries, they will be defined automatically. http://www.squid-cache.org/Doc/config/https_port/
# `icp_access` defaults to undef. If you pass in a hash of icp_access entries, they will be defined automatically. http://www.squid-cache.org/Doc/config/icp_access/
# `refresh_patterns` defaults to undef.  If you pass a hash of refresh_pattern entires, they will be defined automatically. http://www.squid-cache.org/Doc/config/refresh_pattern/
# `snmp_ports` defaults to undef. If you pass in a hash of snmp_port entries, they will be defined automatically. http://www.squid-cache.org/Doc/config/snmp_port/
# `send_hit` defaults to undef. If you pass in a hash of send_hit entries, they will be defined automatically. http://www.squid-cache.org/Doc/config/send_hit/
# `cache_dirs` defaults to undef. If you pass in a hash of cache_dir entries, they will be defined automatically. http://www.squid-cache.org/Doc/config/cache_dir/
# `ssl_bump` defaults to undef. If you pass in a hash of ssl_bump entries, they will be defined automatically. http://www.squid-cache.org/Doc/config/ssl_bump/
# `sslproxy_cert_error` defaults to undef. If you pass in a hash of sslproxy_cert_error entries, they will be defined automatically. http://www.squid-cache.org/Doc/config/sslproxy_cert_error/
# `extra_config_sections` defaults to empty hash. If you pass in a hash of `extra_config_section` resources, 
# they will be defined automatically.
# `service_restart` defaults to undef. Overrides service resource restart command to be executed. 
# It can be used to perform a soft reload of the squid service.
# `squid_bin_path` path to the squid binary, default depends on `$operatingsystem`
# 
# class { 'squid':
#   cache_mem    => '512 MB',
#   workers      => 3,
#   coredump_dir => '/var/spool/squid',
# }
# 
# class { 'squid':
#   cache_mem                 => '512 MB',
#   workers                   => 3,
#   coredump_dir              => '/var/spool/squid',
#   acls                      => { 'remote_urls' => {
#                                    type    => 'url_regex',
#                                    entries => ['http://example.org/path',
#                                                'http://example.com/anotherpath'],
#                                  },
#                                },
#   http_access               => { 'our_networks hosts' => { action => 'allow', }},
#   http_ports                => { '10000' => { options => 'accel vhost', }},
#   snmp_ports                => { '1000' => { process_number => 3, }},
#   cache_dirs                => { '/data/' => { type => 'ufs', options => '15000 32 256 min-size=32769', process_number => 2 }},
#   url_rewrite_program       => '/usr/bin/squidguard -c /etc/squidguard/squidguard.conf',
#   url_rewrite_children      => 12,
#   url_rewrite_child_options => startup=1,
# }
class squid (
  String            $access_log                       = $squid::params::access_log,
  Squid::Size       $cache_mem                        = $squid::params::cache_mem,
  String            $config                           = $squid::params::config,
  String            $config_group                     = $squid::params::config_group,
  String            $config_user                      = $squid::params::config_user,
  String            $daemon_group                     = $squid::params::daemon_group,
  String            $daemon_user                      = $squid::params::daemon_user,
  Boolean           $enable_service                   = $squid::params::enable_service,
  String            $ensure_service                   = $squid::params::ensure_service,
  Squid::Size       $maximum_object_size_in_memory    = $squid::params::maximum_object_size_in_memory,
  String            $package_name                     = $squid::params::package_name,
  Squid::PkgEnsure  $package_ensure                   = $squid::params::package_ensure,
  String            $service_name                     = $squid::params::service_name,
  Stdlib::Absolutepath $squid_bin_path                = $squid::params::squid_bin_path,
  Optional[Stdlib::Absolutepath] $error_directory     = $squid::params::error_directory,
  Optional[Stdlib::Absolutepath] $err_page_stylesheet = $squid::params::err_page_stylesheet,
  Optional[String]  $cache_replacement_policy      = $squid::params::cache_replacement_policy,
  Optional[String]  $memory_replacement_policy     = $squid::params::memory_replacement_policy,
  Optional[Boolean] $httpd_suppress_version_string = $squid::params::httpd_suppress_version_string,
  Optional[Variant[Enum['on', 'off', 'transparent', 'delete', 'truncate'], Boolean]]
                    $forwarded_for                 = $squid::params::forwarded_for,
  Optional[String]  $visible_hostname              = $squid::params::visible_hostname,
  Optional[Boolean] $via                           = $squid::params::via,
  Optional[Hash]    $acls                          = $squid::params::acls,
  Optional[Hash]    $auth_params                   = $squid::params::auth_params,
  Optional[Hash]    $cache_dirs                    = $squid::params::cache_dirs,
  Optional[Hash]    $cache                         = $squid::params::cache,
  Optional[String]  $coredump_dir                  = $squid::params::coredump_dir,
  Optional[String]  $url_rewrite_program           = $squid::params::url_rewrite_program,
  Optional[Integer] $url_rewrite_children          = $squid::params::url_rewrite_children,
  Optional[String]  $url_rewrite_child_options     = $squid::params::url_rewrite_child_options,
  Optional[Hash]    $extra_config_sections         = {},
  Optional[Hash]    $http_access                   = $squid::params::http_access,
  Optional[Hash]    $send_hit                      = $squid::params::send_hit,
  Optional[Hash]    $snmp_access                   = $squid::params::snmp_access,
  Optional[Hash]    $http_ports                    = $squid::params::http_ports,
  Optional[Hash]    $https_ports                   = $squid::params::https_ports,
  Optional[Hash]    $icp_access                    = $squid::params::icp_access,
  Optional[String]  $logformat                     = $squid::params::logformat,
  Optional[Boolean] $buffered_logs                 = $squid::params::buffered_logs,
  Optional[Integer] $max_filedescriptors           = $squid::params::max_filedescriptors,
  Optional[Variant[Enum['on', 'off'], Boolean]]
                    $memory_cache_shared              = $squid::params::memory_cache_shared,
  Optional[Hash]    $refresh_patterns                 = $squid::params::refresh_patterns,
  Optional[Stdlib::Compat::Ip_address]
                    $snmp_incoming_address            = $squid::params::snmp_incoming_address,
  Optional[Hash]    $snmp_ports                       = $squid::params::snmp_ports,
  Optional[Hash]    $ssl_bump                         = $squid::params::ssl_bump,
  Optional[Hash]    $sslproxy_cert_error              = $squid::params::sslproxy_cert_error,
  Optional[Integer] $workers                          = $squid::params::workers,
  Optional[String]  $service_restart                  = $squid::params::service_restart,
) inherits ::squid::params {

  contain squid::install
  contain squid::config
  contain squid::service

  Class['squid::install']
  -> Class['squid::config']
  ~> Class['squid::service']
}
