# PostgREST

## Status

[![Build Status](https://api.travis-ci.com/marcelobarreto/postgrest-rb.svg?branch=master)](https://travis-ci.com/marcelobarreto/postgrest-rb)
[![Code Climate](https://codeclimate.com/github/marcelobarreto/postgrest-rb.svg)](https://codeclimate.com/github/marcelobarreto/postgrest-rb)
[![Code Climate](https://codeclimate.com/github/marcelobarreto/postgrest-rb/coverage.svg)](https://codeclimate.com/github/marcelobarreto/postgrest-rb)
[![Ruby Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop/rubocop)
[![RubyGems](https://img.shields.io/gem/dt/postgrest.svg?style=flat)](https://rubygems.org/gems/postgrest)

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

#<Postgrest::Responses::GetResponse GET OK data=[{"id"=>1, "title"=>"foo", "completed"=>false}, {"id"=>2, "title"=>"foo", "completed"=>false}]>

# Selecting just one or more fields
db.from('todos').select(:title).execute

#<Postgrest::Responses::GetResponse GET OK data=[{"title"=>"foo"}, {"title"=>"foo"}]>

```

### Querying

```ruby
db.from('todos').select('*').eq(id: 100).execute
#<Postgrest::Responses::GetResponse GET OK data=[{"id" => 100, "title"=>"foo", "completed" => true}}]>


db.from('todos').select('*').neq(id: 100).execute
#<Postgrest::Responses::GetResponse GET OK data=[{"id" => 101, "title"=>"foo", "completed" => true}}]>
```

### Inserting

```ruby
db.from('todos').insert(title: 'Go to the gym', completed: false).execute

#<Postgrest::Responses::PostResponse POST Created data=[{"id"=>1, "title"=>"Go to the gym", "completed"=>false}]>

db.from('todos').upsert(id: 1, title: 'Ok, I wont go to the gym', completed: true).execute

#<Postgrest::Responses::PostResponse POST Created data=[{"id"=>1, "title"=>"Ok, I wont go to the gym", "completed"=>true}]>

# Inserting multiple rows at once
db.from('todos').insert([
  { title: 'Go to the gym', completed: false },
  { title: 'Walk in the park', completed: true },
]).execute

#<Postgrest::Responses::PostResponse POST Created data=[{"id"=>110, "title"=>"Go to the gym", "completed"=>false}, {"id"=>111, "title"=>"Walk in the park", "completed"=>true}]>

```

### Updating

```ruby

# Query before update

db.from('todos').update(title: 'foobar').eq(id: 109).execute

#<Postgrest::Responses::PatchResponse PATCH OK data=[{"id"=>106, "title"=>"foo", "completed"=>false}]>

# Update all rows

db.from('todos').update(title: 'foobar').execute

#<Postgrest::Responses::PatchResponse PATCH OK data=[{"id"=>107, "title"=>"foobar", "completed"=>false}, {"id"=>1, "title"=>"foobar", "completed"=>true}, {"id"=>110, "title"=>"foobar", "completed"=>false}, {"id"=>111, "title"=>"foobar", "completed"=>true}, {"id"=>106, "title"=>"foobar", "completed"=>false}]>
```

### Deleting

```ruby
# Querying before delete

db.from('todos').delete.eq(id: 109).execute
#<Postgrest::Responses::DeleteResponse DELETE OK data=[{"id"=>109, "title"=>"Go to the gym", "completed"=>false}]>

# OR deleting everything

db.from('todos').delete.execute

#<Postgrest::Responses::DeleteResponse DELETE OK data=[{"id"=>110, "title"=>"Go to the gym", "completed"=>false}, {"id"=>111, "title"=>"Go to the gym", "completed"=>false}]>
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/marcelobarreto/postgrest.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
