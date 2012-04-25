Sensu conf.d JSON snippets
--------------------------

The Sensu package installs a single `/etc/sensu/config.json` file that
contains examples of all config stanzas needed by a minimal Sensu
installation.

However, you may also break this monolithic config file up into smaller
pieces which often helps with config management systems such as Puppet or Chef.

Place any JSON snippets in this `/etc/sensu/conf.d` directory. Files must
have .json suffix. Examples:

`/etc/sensu/conf.d/handler_default.json`:

	{
	  "handlers": {
	    "default": {
	      "type": "pipe",
	      "command": "/etc/sensu/handlers/default"
	    }
	  }
	}

`/etc/sensu/conf.d/client.json`:

	{
	  "client": {
	    "name": "localhost",
	    "address": "127.0.0.1",
	    "subscriptions": [ "test" ]
	  }
	}