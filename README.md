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
  return unless defined?(RspecChunked::ChunkedTests)

  RspecChunked::ChunkedTests.balance_settings =  { 1 => { to: 2, percentage: 15 }, 4 => { to: 3, percentage: 10 } }
```
Balance tests by moving 15% tests files from group 1 into group 2 and moving 10% tests files from group 4 into group 3

## Usage
` CI_JOBS=3 CI_JOB=1 rake rspec_chunked `
- `CI_JOBS`: quantity of groups/workers to be split
- `CI_JOB`: current group/worker to be executed, limit: 1 until CI_JOBS

### Github workflow result
- Before:    
  ![Before](/docs/before.png?raw=true)

- After:    
  ![After](/docs/current.png?raw=true)   

- Github workflow sample:
  ````yaml
  rspec_tests:
    name: Rspec tests
    runs-on: ubuntu-latest
    strategy:
      fail-fast: false
      matrix:
        ci_job: [ 1, 2, 3, 4 ] # enumerize jobs
    env:
      CI_JOBS: 4 # define total jobs (must match with matrix above)
  
    steps:
      - uses: actions/checkout@v2
      - name: Backend tests
        env:
          CI_JOB: ${{ matrix.ci_job }}
        run: docker-compose run test /bin/sh -c "CI_JOBS=$CI_JOBS CI_JOB=$CI_JOB rake rspec_chunked"

  ````  

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/owen2345/rspec_chunked. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
