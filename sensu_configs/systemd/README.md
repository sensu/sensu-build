Example systemd service unit scripts for Sensu.

There are a couple ways to control Sensu on a systemd system:

1. The supported way: Use `sensu-ctl` to manage sensu services.
---------------------------------------------------------------

Install: run `sensu-ctl configure`. This will copy `sensu-runsvdir.service`
to /etc/systemd/system and start the sensu-runsvdir.service.

Then use `sensu-ctl` to manage individual Sensu components.


2. Use systemd to manage each Sensu component.
----------------------------------------------

Alternatively, use the `sensu-{client,api,server,dashboard}.service` unit
files as templates, customize to taste. Then use standard
`systemctl {start,stop,restart,...}` commands to control them.
