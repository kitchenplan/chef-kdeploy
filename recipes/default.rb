# Prerequisites

include_recipe "build-essential::default"

# SSH settings

ssh_known_hosts_entry 'github.com'
include_recipe "root_ssh_agent::ppid"
include_recipe "root_ssh_agent::env_keep"
