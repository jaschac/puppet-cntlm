# This class provides the configuration for cNTLM
class cntlm::config {

  if $::cntlm::package_ensure in ['installed', 'latest', 'present']{
    file { $::cntlm::config_file :
      content => epp( $::cntlm::config_template ),
      notify  => Service[ $::cntlm::service_name ],
      require => Package[ $::cntlm::package_name ],
    }

    if $::cntlm::export{
      file { $::cntlm::profile_file :
        content => epp( $::cntlm::profile_template ),
        require => Service[ $::cntlm::service_name ],
      }
    }
  }
}
