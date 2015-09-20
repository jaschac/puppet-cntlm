# This class manages the cNTLM daemon
class cntlm::service {
  if $::cntlm::package_ensure in ['installed', 'latest', 'present']{
    service { $::cntlm::service_name :
      ensure  => $::cntlm::service_ensure,
      enable  => $::cntlm::service_enable,
      require => File[ $::cntlm::config_file ],
    }
  }
}
