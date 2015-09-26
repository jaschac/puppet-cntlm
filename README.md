# lostinmalloc-cntlm
#### Table of Contents
1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup](#setup)
    * [What lostinmalloc-cntlm affects](#what-lostinmalloc-cntlm-affects)
    * [Requirements](#requirements)
4. [Usage](#usage)
5. [Reference](#reference)
6. [Limitations](#limitations)
7. [Development](#development)

## Overview
This module deploys [cNTLM](http://cntlm.sourceforge.net), the fast NTLM authentication proxy. cNTLM is mainly used to reduce the complexity needed to get clients through the proxy of a company. This module is distributed through the Apache License 2.0. Please do refer to the LICENSE file for details.

## Module Description
The lostinmalloc-cntlm is responsible of: 

 1. Deploying a properly configured cNTLM instance.
 2. Optionally, to set system-wide environment variables so that they are available to all new users of the system.

In order to work, cNTLM requires:

 1. To be associated with an identity (username:password), used to identify the requests to the proxy. The cNTLM binary comes with an option, -H, that allows to encrypt a plain text password. The module does expect encrypted passwords.
 2. To know details about the proxy itself, that its URL and port, plus the domain which the node is part of. 

## Setup
In order to install this module, run the following command:

`puppet module install lostinmalloc-cntlm`

Once installed, getting cNTLM installed on a node is a simple as:

```puppet
node 'puppet.lostinmalloc.com' {
  class { 'cntlm': }
}
```

The module does expect all the data to be provided through Hiera. See below for an example on how to configure it.

#### What lostinmalloc-cntlm affects
The module installs the cNTLM package that comes through APT. It does overwrite the default configuration file, /etc/cntlm.conf, with the one built with the provided template. Optionally, It does overwrite /etc/profile, with a new file generated through a template. This adds the following environment variables, which will be available to every new user of the system:

 - ftp_proxy
 - http_proxy
 - https_proxy

The following files are created when cNTLM is installed:

 - /etc/cntlm.conf
 - /etc/default/cntlm
 - /etc/init.d/cntlm
 - /etc/rc0.d/K01cntlm
 - /etc/rc1.d/K01cntlm
 - /etc/rc2.d/S17cntlm
 - /etc/rc3.d/S17cntlm
 - /etc/rc4.d/S17cntlm
 - /etc/rc5.d/S17cntlm
 - /etc/rc6.d/K01cntlm
 - /usr/sbin/cntlm

The following file(s) can be optionally overwritten:

 - /etc/profile

#### Requirements
This module requires **Puppet 4**.

In terms of dependencies, the following modules are required:

 - puppetlabs-stdlib >= 2.2.1 <= 4.9.0

## Usage
lostinmalloc-cntlm expects all the data to be provided through Hiera. Here is an example:

\# global.yaml
```yaml
---
cntlm::params::cntlm:
  proxy_port: '3128'
  proxy_url: '127.0.0.1'
cntlm::params::config_file: '/etc/cntlm.conf'
cntlm::params::config_template: 'cntlm/cntlm.conf.epp'
cntlm::params::company:
  domain: 'lostinmalloc'
  proxy_port: '3128'
  proxy_url: 'proxy.lostinmalloc.com'
cntlm::params::export: true
cntlm::params::package_ensure: 'installed'
cntlm::params::package_name: 'cntlm'
cntlm::params::profile_file: '/etc/profile'
cntlm::params::profile_template: 'cntlm/profile.epp'
cntlm::params::service_enable: true
cntlm::params::service_ensure: 'running'
cntlm::params::service_name: 'cntlm'
```

\# nodes/puppet.lostinmalloc.com.yaml
```yaml
---
cntlm::params::user:
  passwordlm: 'QWERTY'
  passwordnt: 'ASDFG'
  passwordntlm2: 'ZXCVB'
  username: 'jascha'
```
Once configured, deploying cNTLM on a node is as easy as:

\# manifests/site.pp
```puppet
node 'puppet.lostinmalloc.com' {
  class { 'cntlm': }
}
```

## Reference
* *cntlm::params::cntlm* - A hash representing how the client will connect to cNTLM to pass throug the company proxy. If cNTLM is set to listen to 127.0.0.1:3128, then all the calls of the client should pass through this. Some application might require explicitly setting the proxy.
  * *proxy_port* - The port the client will use to pass through the proxy.
  * *proxy_url* - The URL the client will use to pass through the proxy.
* *cntlm::params::config_file* - The location of the cNTLM's configuration file.
* *cntlm::params::config_template* - The template used to generate cntlm::params::config_file.
* *cntlm::params::company* - A Hash holding details of the company's proxy.
  * *domain* - The domain.
  * *proxy_port* - The port of the proxy of the company.
  * *proxy_url* - The URL of the proxy of the company.
* *cntlm::params::export* ― A boolean. It allows to export the environment variables to /etc/profile so that they are available to all the users of the system.
* *cntlm::params::package_ensure* - An enum. It determines if the package should be present of not. Valid values are 'absent', 'held', 'installed', 'latest', 'present', and 'purged'.
* *cntlm::params::package_name* - The name of the package to install through APT.
* *cntlm::params::profile_file* - The file where the details about the proxy will be exported. This file is the one used by the system as a template, each time a new user is added to the system. This guarantees that any new user will have the environment variables set.
* *cntlm::params::profile_template* - The template used to generate cntlm::params::profile_file.
* *cntlm::params::service_enable* - A boolean representing whether the cNTLM daemon should start when the system boots.
* *cntlm::params::service_ensure* - An enum representing the desired state of the cNTLM daemon. Valid values are 'running', and 'stopped'.
* *cntlm::params::service_name* - The name of the service.
* *cntlm::params::user* - A hash representing the details that cNTLM uses to identify its requests to the proxy.
  * *passwordlm* - A string, representing the encrypted password. Generated through cntlm -H.
  * *passwordnt* - A string, representing the encrypted password. Generated through cntlm -H.
  * *passwordntlm2* - A string, representing the encrypted password. Generated through cntlm -H.
  * *username* - The username through which cNTLM will be identified as by the proxy of the company.

## Limitations
This module has been developed and tested on the following setup(s):

*Operating Systems*:

 - Debian 7 Wheezy (3.2.68-1+deb7u3 x86_64)
 - Debian 8 Jessie (3.16.7-ckt11-1+deb8u3 x86_64)

*Puppet*

 - 4.2.1

*Hiera*

 - 3.0.1

*Facter*

 - 2.4.4

*Ruby*

 - 2.1.6p336

## Development
You can contact me through the official page of this module: https://github.com/jaschac/puppet-cntlm.
Please do report any bug and suggest new features/improvements.

