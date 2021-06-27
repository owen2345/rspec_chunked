# RspecChunked
This gem permits running rspec tests in parallel by chunking tests into defined groups and balancing by file size. If the default order is not enough, it permits to balance manually by moving x percentage of test files from group A into group B.

## Installation
- Add this line to your application's Gemfile:
```ruby
  group :test do
    gem 'rspec_chunked'
  end
```

- And then execute:
`bundle install`

- Add manual balance (optional)
  ```ruby
    # config/rspec_chunked.rb
    if defined?(RspecChunked::ChunkedTests)
      data = { 1 => { to: 2, percentage: 15 },
               4 => { to: 3, percentage: 10 } }
      RspecChunked::ChunkedTests.balance_settings = data
    end
  ```
  Balance tests by moving 15% tests files from group 1 into group 2 and moving 10% tests files from group 4 into group 3

## Usage
- Basic initialization
  ` CI_JOBS=1/3 rake rspec_chunked`
- Custom initialization
  ` CI_LOGIC=qty_specs CI_JOBS=1/3 CI_CMD="bundle exec rspec ..." rake rspec_chunked`
- `CI_JOBS`: Current job number / quantity of groups/jobs to be split
- `CI_CMD`: Custom rspec command
- `CI_LOGIC`: Kind of logic to be used when ordering tests: `qty_specs` or `file_size` (by default `file_size`)

### Coverage merge reports (when using [simplecov](https://github.com/simplecov-ruby/simplecov#merging-test-runs-under-different-execution-environments))
This task will merge all coverage reports
`rake rspec_chunked:merge_reports`


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
      CI_JOBS: ${{ matrix.ci_job }}/4 # <current_job>/<total_jobs>
  
    steps:
      - uses: actions/checkout@v2
      - name: Backend tests
        run: docker-compose run test /bin/sh -c "CI_JOBS=$CI_JOBS rake rspec_chunked"

  ````  

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/owen2345/rspec_chunked. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
