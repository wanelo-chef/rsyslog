# The ipaddr_extensions gem adds the "privateaddress" top level attribute,
# which is the RFC1918 IP address (if present). Valid options are "ipaddress"
# and "privateaddress"
default_bind_attribute = "privateaddress"

default["rsyslog"]["udp"] = {
    "enabled" => true,
    "bind_attribute" => default_bind_attribute,
    "port" => "514"
}

default["rsyslog"]["tcp"] = {
    "enabled" => false,
    "bind_attribute" => default_bind_attribute,
    "port" => "514"
}
