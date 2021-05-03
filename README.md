# PostgREST

## Status

[![Build Status](https://api.travis-ci.org/marcelobarreto/postgrest.svg?branch=master)](https://travis-ci.org/marcelobarreto/postgrest-rb)
[![Code Climate](https://codeclimate.com/github/marcelobarreto/postgrest-rb.svg)](https://codeclimate.com/github/marcelobareto/postgrest-rb)
[![Code Climate](https://codeclimate.com/github/marcelobarreto/postgrest-rb/coverage.svg)](https://codeclimate.com/github/marcelobarreto/postgrest-rb)
[![Ruby Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop/rubocop)
[![RubyGems](http://img.shields.io/gem/dt/postgrest.svg?style=flat)](http://rubygems.org/gems/postgrest)

Ruby client for [PostgREST](https://postgrest.org/)

This gem is under development, any help are welcome :muscle:

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'postgrest'
```

And then execute:

`$ bundle install`

Or install it yourself as:

`$ gem install postgrest`

## Usage

### Configuration

```ruby
db = Postgrest::Client.new(url: url, headers: headers, schema: schema)
```

### Selecting

```ruby
# Basic select

db.from('todos').select('*').execute
# or just db.from('todos').select

# Selecting just one or more fields
db.from('todos').select(:title, :completed).execute

```

### Querying

```ruby
db.from('todos').select('*').eq(id: 100).execute

db.from('todos').select('*').neq(id: 100).execute
```

### Inserting

```ruby
db.from('todos').insert({ title: 'Go to the gym', completed: false }).execute

db.from('todos').upsert({ id: 1, title: 'Ok, I wont go to the gym', completed: true }).execute


# Inserting multiple rows at once
db.from('todos').insert([
  { title: 'Go to the gym', completed: false },
  { title: 'Walk in the park', completed: true },
]).execute

```

### Updating

### Deleting

## Responses

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/marcelobarreto/postgrest.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
