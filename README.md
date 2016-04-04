# Tugboat, automatic NGINX reverse proxy for containers

This project contains a NGINX reverse proxy, consul, and registrator.  When used together, they can create dynamic virtual host for any web container you launch.

This project requires that you are using the Docker Toolbox, which uses docker-machine with Virtualbox and Boot2Docker.  It will not work on linux (unless you manually set a host IP of 192.168.99.100).

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
  - "SERVICE_3000_NAME=awesome-service" #adjust the port number here too, if needed
  - "SERVICE_3000_TAGS=load-balance"
```

**Note:** the `ports` line should NOT look like `3000:3000`. It should be a single port number only.  This allows docker to assign a RANDOM port to bind to on the host.  Consul / Registrator / NGINX will handle this random port without issue. This prevents you from experiencing port conflicts!

Now run `docker-compose up` on your project.

Then simply go to `http://awesome-service.tugboat.zone/` in your browser (because we set the name to be `awesome-service`)

## SSL Support

This project DOES provide SSL support (but needs to be enabled, see below).  By default, it uses a self-signed certificate.  You will receive a warning when you try to load `https://container.tugboat.zone`, you can simply bypass the warning and continue.

The self-signed certificate likely will not work well for internal app-to-app communication since it will likely reject the cert.  We personally just use http for that (it's internal anyways!), but you also have the option to use your own SSL certificate.

## Custom Configuration

To use a custom configuration (enable SSL, custom SSL cert, custom domain) please run:

`cp docker-compose.override.example.yml docker-compose.override.yml` and then edit to your needs.

**Note:** If you use a custom domain, you need to also setup wildcard
DNS to the IP `192.168.99.100`. So if you use the domain `tugboat.ninja`, you need to setup `*.tugboat.ninja` to point to `192.168.99.100`.

We own and have wildcard DNS set up for the following domains:

* tugboat.zone
* tugboat.ninja
* tugboat.tools

## Static Custom Configuration

Are you a company where you want all of your devs to use the same custom configuration?  Well we are too, so we have you sorted there as well!

Head on over to [Tugboat Bootstrapper](https://github.com/articulate/tugboat-bootstrapper) to learn how to create a repo with static configs

## What if I'm running linux?

Well, we don't officially support linux as our setup makes an assumption you are using the Docker Toolbox.  However you can still get it working.  You either need to create a virtual network interface bound on `192.168.99.100` or edit this project to change it to use your host IP and the using a custom domain which wildcards to your custom IP.  This is out of the scope of this tool, but its still possible.

A virtual network interface is your best option.

If you know of a good way to adapt this tool to work with linux, feel free to submit a pull request.

## Troubleshooting

### None of the tugboat domains are resolving!

- If you are using a router that has "rebind production" turned on, you will need to turn that off, or add an exception for this domain.  DD-WRT and Open-WRT often enable it by default.

## Contributing

1. Fork it ( https://github.com/articulate/tugboat/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [tecnobrat](https://github.com/tecnobrat) Brian Stolz - creator,
  maintainer
