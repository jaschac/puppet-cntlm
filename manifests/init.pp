# cNTLM proxy authentication
class cntlm
  (
) inherits ::cntlm::params {
  contain ::cntlm::install
  contain ::cntlm::config
  contain ::cntlm::service
}
