# frozen_string_literal: true

module RspecChunked
  class ChunkedTests
    class << self
      attr_accessor :balance_settings
    end
    attr_accessor :qty_groups, :job_number, :balance_settings

    def initialize(qty_groups, job_number)
      @qty_groups = qty_groups
      @job_number = job_number - 1
      @balance_settings = self.class.balance_settings || {}
    end

    def run
      balanced_tests = balance_tests(group_tests, balance_settings)
      tests = balanced_tests[job_number]
      qty = balanced_tests.flatten.count
      Kernel.puts "**** running #{tests.count}/#{qty} tests (group number: #{job_number + 1})"
      Kernel.exec "bundle exec rspec #{tests.join(' ')}"
    end

    private

    def group_tests
      res = Array.new(qty_groups).map { [] }
      test_files.each_slice(qty_groups).each do |group|
        group.each_with_index do |path, index|
          res[index] << path
        end
      end
      res
    end

    def test_files
      Dir['spec/**/*_spec.rb'].sort_by do |path|
        File.size(File.join('./', path)).to_f
      end
    end

    # Balance tests by moving x percentage tests files from group 1 into group 2
    # Sample balance_tests(data, { 1 => { to: 2, percentage: 15 }, 3 => { to: 0, percentage: 10 } })
    # @return (Array) same array with balance applied tests
    def balance_tests(data, balance_data)
      balance_data.each do |index, info|
        from = index - 1
        to = info[:to] - 1
        move_tests(data, from, to, info[:percentage]) if data[from] && data[to]
      end
      data
    end

    def move_tests(data, from, to, percentage)
      qty_tests = ((data[from].count * percentage) / 100).round
      moving_tests = data[from][-qty_tests..-1]
      data[to] += moving_tests
      data[from] -= moving_tests
    end
  end
end
