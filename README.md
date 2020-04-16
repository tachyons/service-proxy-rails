# Service::Proxy

When running a service-oriented architecture, it is sometimes desirable to allow your backend services to be mapped to URL paths within the application itself.

This allows you for example to be able to share cookies and reduce the need for CORS calls or to expose your services in a way that they are accessible only through a particular front-end application.

This gem allows you to easily set up these backend service proxy's through a simple YAML configuration file.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'service-proxy'
```

And then execute:
```bash
$ bundle
```

## Usage

Create a file named ``config/service_proxy.yml`` in your rails application directory.

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
