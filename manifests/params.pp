# This class holds the cNTLM parameters.
class cntlm::params
  (
    Struct[{
      proxy_port => String[1,6],
      proxy_url  => String[1,default],
    }] $cntlm,
    String[1,default] $config_file,
    String[1,default] $config_template,
    Struct[{
      domain     => String[1,default],
      proxy_port => String[1,default],
      proxy_url  => String[1,default],
    }] $company,
    Boolean $export,
    Enum[
      'absent',
      'held',
      'installed',
      'latest',
      'present',
      'purged'] $package_ensure,
    String[1,default] $package_name,
    String[1,default] $profile_file,
    String[1,default] $profile_template,
    String[1,default] $service_name,
    Boolean $service_enable,
    Enum[
      'running',
      'stopped'] $service_ensure,
    Variant[
      String[1,30],
      Struct[{
        passwordlm    => String[32,32],
        passwordnt    => String[32,32],
        passwordntlm2 => String[32,32],
        username      => String[1,30],
      }]
    ] $user,
){
}
