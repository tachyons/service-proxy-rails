# Service::Proxy

When running a service-oriented architecture, it is sometimes desirable to allow your backend services to be mapped to URL paths within the application itself.

This allows you for example to be able to share cookies and reduce the need for CORS calls or to expose your services in a way that they are accessible only through a particular front-end application.

This gem allows you to easily set up these backend service proxy's through a simple YAML configuration file.

## Installation
Add this line to your application's Gemfile:

```ruby

source "https://rubygems.pkg.github.com/sephora-asia" do
  gem 'service-proxy'
end

```

And then execute:
```bash
$ bundle
```

## Usage

Create a file named ``config/service_proxy.yml`` in your rails application directory.

## Usage

Create a file named ``config/service_proxy.yml`` in your rails application directory. It should look something like this -

## Usage

Create a file named ``config/service_proxy.yml`` in your rails application directory. It should look something like this -

```yml
default: &default
  services:
    address-api:
      path: /api/address
      backend: https://www.my-address-api.com:8888/

    user-api:
      path: /api/user
      backend: https://www.my-user-api.com/

    rewards-api:
      path: /api/rewards
      backend: http://www.my-rewards-api.com:9999/

    ads-api:
      path: /api/ads
      backend: http://www.my-ads-api.com:1101/
      forward_cookies: false


development:
  <<: *default

test:
  <<: *default
```

Each of the `services` block sequence in the `yml` file is given a - `sequence name`, and are expected to contain `path` and `backend` scalar. The request url that the app receives will be matched against each of these `path` and if a match is found, then the request will be forwarded to the corresponding backend. For eg. based on the above config, if our app is responding to https://www.my-app.com, then if a request to https://www.my-app.com/api/rewards?reward_id=1234 is made, it will be matched against the `rewards-api`  block sequence and the same request will get forwarded as http://www.my-rewards-api.com:9999/?reward_id=1234.

Each block sequence can contain the following scalars -
 - `path` :  The path that needs to be matched in the request url. It is a required field.
 - `backend` : This is the destination URI that we need to forward the current request to. This needs to have a valid url scheme `[scheme]://[domain]:[port]/`. Supported `scheme` is either `http` or `https`. `port` is optional and the default value of 80 or 443 is used depending up on whether the scheme is `http` or `https`. This is also a required field.
 - `forward_cookies`:  Can be `true` (default value) or `false`. Cookies will not be forwarded to `backend` if this is set to false.
 - `read_timeout`: This sets the proxy timeout. By default it times out in 60 seconds.
 - `verify_ssl`: Can be `true` (default value) or `false`. This tells `Net::HTTP` to not validate certs if set to `false`.

## Contributing

Run `make setup` in order to install your dev environment.

This project uses the [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/) for commit naming.

Publishing is done automatically when a push to the master branch is detected.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
