# RspecChunked
This gem permits to run rspec tests in parallel by chunking tests into defined groups and balancing by file size.
If ordering is not enough, permits to balance manually by moving x percentage of tests files from group A into group B.

## Installation
- Add this line to your application's Gemfile:
```ruby
  group :test do
    gem 'rspec_chunked'
  end
```

- And then execute:
`bundle install`

- Add manual balance
```ruby
  # config/initializers/rspec_chunked.rb
  RspecChunked::ChunkedTests.balance_settings =  { 1 => { to: 2, percentage: 15 }, 4 => { to: 3, percentage: 10 } }
```
Balance tests by moving 15% tests files from group 1 into group 2 and moving 10% tests files from group 4 into group 3

## Usage
` CI_JOBS=3 CI_JOB=1 rake rspec_chunked `
- `CI_JOBS`: quantity of groups/workers to be split
- `CI_JOB`: current group/worker to be executed, limit: 1 until CI_JOBS


## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/owen2345/rspec_chunked. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
