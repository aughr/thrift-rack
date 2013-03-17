# Thrift::Rack

A Rack interface to a Thrift service.

Thrift currently provides a `MongrelHttpServer`. This works the same way
(providing an HTTP interface to a Thrift service) but also provides
a bit better error handling.

## Installation

Add this line to your application's Gemfile:

    gem 'thrift-rack'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install thrift-rack

## Usage

```ruby
# in a Rack::Builder context

processor = YourThriftService::Processor.new YourThriftHandler.new
run Thrift::Rack::Server.new processor, :path => "/your_service"
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
