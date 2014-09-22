# ActsAsJournalized

Plug-in for Redmine. It's used for tracking and recording changes in model attributes.

## Installation

Add this line to your application's Gemfile:

    gem 'acts_as_journalized'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install acts_as_journalized

## Usage

### Model

    class MyModel < ActiveRecord::Base
        ...
        acts_as_journalized
        ...
    end

Or

    class MyModel < ActiveRecord::Base
        ...
        acts_as_journalized name: 'journals', excepted_attributes: [:updated_at, :updated_on], find_options: {}
        ...
    end

## Contributing

1. Fork it ( http://github.com/shipiev/acts_as_journalized/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
