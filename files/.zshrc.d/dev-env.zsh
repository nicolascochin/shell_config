! command -v "limactl" &> /dev/null && return 

dev_create() {
  bash <(curl -Ls https://raw.githubusercontent.com/nicolascochin/lima-dev/refs/heads/main/create_env.sh) "$@"
}

_comp_list_vms() {
  compadd $(limactl list -q)
}

dev_enter() {
  bash <(curl -Ls https://raw.githubusercontent.com/nicolascochin/lima-dev/refs/heads/main/create_env.sh) NAME_OF_VM
}
compdef _comp_list_vms dev_enter

