# This class installs the packages required by cNTLM
class cntlm::install {
  package { $::cntlm::package_name :
    ensure => $::cntlm::package_ensure,
  }
}
