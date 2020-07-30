(specifications->manifest
 '(;; core dependencies
   "bash"
   "grep"
   "coreutils"
   "which"
   ;; test dependencies
   "bats-core"
   "python-pyyaml"
   "python-pycapnp"
   
   "px-accounts-service"
   "px-secret-service"
   "px-events-service"

   ;; plugins
   "px-accounts-service-plugin-gitlab"
   ))