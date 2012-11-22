Rsyslog
=======

## Description

This cookbook installs and configures rsyslog.

## Requirements

### Platform

Tested on SmartOS Base64 1.8.1 dataset. This could be easily adapted
to Ubuntu, should there be desire and a pull request.

## Attributes

* `rsyslog.udp.enabled` - [true, false] - default true
* `rsyslog.udp.bind_interface` - net0, net1, eth0, eth1, lo0 - default
   net1
* `rsyslog.udp.protocol` - [inet, inet6] - default inet
* `rsyslog.udp.port` - default 514

* `rsyslog.tcp.enabled` - [true, false] - default false
* `rsyslog.tcp.bind_interface` - net0, net1, eth0, eth1, lo0, nil - default
   net1
* `rsyslog.tcp.protocol` - [inet, inet6] - default inet
* `rsyslog.tcp.port` - default 514

### Binding interfaces

By default on SmartOS rsyslog will be configured to bind on `net1`, which
on a multi-homed host should be its private interface. Set this to
`net0` to bind its public interface, or `lo0` to bind localhost. If you
would prefer that rsyslog binds all ports, set
`rsyslog.{udp,tcp}.bind_interface` to nil and override
`rsyslog.{udp,tcp}.bind_address` to `*`.

When dealing with platforms other than Solaris or Illumos ports,
interfaces will probably be identified as `eth0` or `eth1` instead of
net.

## Data Bags

This cookbook expects several data bag items. Each of these should live
in the `rsyslog` data bag.

```yml
- chef_repo
  - data_bags
    - rsyslog
      - logs.json
      - templates.json
```

### Custom template formats

Custom formats can be defined in the data bag item `templates`.

```json
{
  "id":"templates",
  "templates":[
    {
      "name":"MyCustomFormat",
      "format":"%msg:2:2048%\\n"
    },
    {
      "name":"MyOtherFormat",
      "format":"%timegenerated% %HOSTNAME%\n%syslogtag%%msg:::drop-last-lf%\n"
    }
  ]
}
```

### Custom log files

Log files are defined in the `logs` data bag item.

```json
{
  "id":"logs",
  "logs":[
    {
      "pri":"local.info",
      "file":"/var/log/my-log.log",
      "template": "MyCustomFormat",
      "owner": "my-user",
      "mode": "0644"
    }
  ]
}
```

The `template` value should match a custom template defined in your
`templates` data bag item. Directories will be recursively created if
necessary, and the file touched. Directory permissions will not be
altered, though the file will be created with the correct ownership and
permissions.

## Recipes

```ruby
run_list([
  "recipe[rsyslog::server]"
])
```

