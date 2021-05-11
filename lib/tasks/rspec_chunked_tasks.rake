# frozen_string_literal: true

desc 'Run chunked rspec tests on specific qty, sample: CI_JOBS=3 CI_JOB=1 rake rspec_chunked'
task :rspec_chunked do
  qty_jobs = (ENV['CI_JOBS'] || 3).to_i
  job_number = (ENV['CI_JOB'] || 1).to_i

  service = RspecChunked::ChunkedTests.new(qty_jobs, job_number)
  service.run
end
