case platform
  when "smartos", "solaris2"
    default_interface = "net1"
  else
    default_interface = "eth1"
end

default["rsyslog"]["udp"] = {
    "enabled" => true,
    "bind_interface" => default_interface,
    "protocol" => "inet",
    "port" => "514"
}

default["rsyslog"]["tcp"] = {
    "enabled" => false,
    "bind_interface" => default_interface,
    "protocol" => "inet",
    "port" => "514"
}
