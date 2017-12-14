# Tugboat, automatic reverse proxy for containers

![tugboat logo](/tugboat.png)

This project contains a fabio reverse proxy, consul, and registrator.  When used together, they can create dynamic virtual host for any web container you launch.

This project requires that you are using Docker for Windows, Mac, or Linux. At the time of this writing, Docker Toolbox is not available for Linux, but docker-compose is available to download [here](https://docs.docker.com/compose/install/).

This means every new container (when lightly configured) you launch, will have a custom hostname you can pull up in your browser.

Yes. Really.

[![asciicast](https://asciinema.org/a/41133.png)](https://asciinema.org/a/41133)

## How to run:

1. Clone this repo.
2. Run `make start`

## How to get your project working

You need to add the following 5 lines to your service you want load balanced to `docker-compose.yml`

```
ports:
  - 3000 #ensure this is the correct port your service exposes
labels:
  SERVICE_3000_NAME: awesome-service #adjust the port number here too, if needed
  SERVICE_3000_TAGS: urlprefix-awesome-service.*/
```

**Note:** the `ports` line should NOT look like `3000:3000`. It should be a single port number only.  This allows docker to assign a RANDOM port to bind to on the host.  Consul / Registrator / fabio will handle this random port without issue. This prevents you from experiencing port conflicts!

Now run `docker-compose up` on your project.

Then simply go to `http://awesome-service.tugboat.zone/` (docker toolbox) or `http://awesome-service.native.tugboat.zone` (docker native) in your browser (because we set the name to be `awesome-service`)

## Docker for Windows

Docker for Windows needs to have its network subnet set to a very specific subnet.  Right-click on the docker icon in your system tray, once in settings, edit the Network settings to look like:

![](/windows-network.png)

## SSL Support

This project by default provides SSL support using a self-signed SSL cert for `*.tugboat.zone`

The self-signed certificate likely will not work well for internal app-to-app communication since it will likely reject the cert.  We personally just use http for that (it's internal anyways!), but you also have the option to use your own SSL certificate.

## Custom Configuration

To use a custom configuration (enable SSL, custom SSL cert, custom domain) please run:

`cp docker-compose.override.example.yml docker-compose.override.yml` and then edit to your needs.

**Note:** If you use a custom domain, you need to also setup wildcard DNS to the IP `192.168.65.1`. So if you use the domain `tugboat.ninja`, you need to setup `*.tugboat.ninja` to point to `192.168.65.1`.

We own and have wildcard DNS set up for the following domains:

* tugboat.zone
* tugboat.ninja
* tugboat.tools

## Static Custom Configuration

Are you at company where you want all of your devs to use the same custom configuration?  Well we are too, so we have you sorted there as well!

Head on over to [Tugboat Bootstrapper](https://github.com/articulate/tugboat-bootstrapper) to learn how to create a repo with static configs

## Dynamic Consul Key/Value pairs

Tugboat supports dynamically setting consul key/values into its consul when you start a container.

Add this TAG when starting your docker container: `consul-key:[consul path]:[value]`

For example: `consul-key:apps/my-service/env_vars/SOME_ENV_VAR:some-value`

That will set a key in `apps/my-service/env_vars/SOME_ENV_VAR` with the value of `some-value`

A complete labels section in your `docker-compose.yml` would look like:

```
labels:
  SERVICE_3000_NAME: awesome-service #adjust the port number here too, if needed
  SERVICE_3000_TAGS: >
    urlprefix-awesome-service.*/,
    consul-key:apps/my-service/env_vars/SOME_ENV_VAR:some-value
```

## Troubleshooting

### None of the tugboat domains are resolving

There are two causes of this:

1. You are using a router that has "rebind production" turned on, you will need to turn that off, or add an exception for this domain.  DD-WRT and Open-WRT often enable it by default.
2. Your DNS server doesn't allow hostnames to resolve to local IPs (eg: 192.168.x.x).  You can [try using Google's DNS servers](https://support.apple.com/en-mide/guide/mac-help/enter-dns-and-search-domain-settings-mh14127) (8.8.8.8 and 8.8.4.4).

## Contributing

1. Fork it ( https://github.com/articulate/tugboat/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- Check out the contributors [here](https://github.com/articulate/tugboat/graphs/contributors)
