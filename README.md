# LLT::DbHandler

LLT abstraction to communicate with stem dictionaries/databases.

## Installation

Add this line to your application's Gemfile:

    gem 'llt-db_handler'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install llt-db_handler

## Usage

The Prometheus Stem Dictionary comes with this gem. To use it make sure
you have postgresql installed and a user called prometheus ready:

```
  psql
    create user prometheus with password 'admin'
```
Create the database and seed data:

```
  rake prometheus:db:create
  rake prometheus:db:seed
```

The database prometheus_stems will now be available.
<!-->
# This should not be needed as the db is created by the user prometheus
anyway.
You might have to grant privileges to the user prometheus before going
further:

```
  psql
    grant all on database prometheus_stems to prometheus
```
-->

```ruby
  require 'llt/db_handler/prometheus'

  db = LLT::DbHandler::Prometheus.new
  db.count            # => returns the total number of entries
  db.all_entries      # => returns all entries as AR models
  db.lemma_list       # => returns an Array of lemmas as strings
  db.lemma_list(true) # => returns detailed lemma strings
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
