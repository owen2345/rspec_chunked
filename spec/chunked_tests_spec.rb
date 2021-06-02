# frozen_string_literal: true

require 'spec_helper'
RSpec.describe RspecChunked::ChunkedTests do
  let(:qty_jobs) { 3 }
  let(:job_number) { 1 }
  let(:inst) { described_class.new(qty_jobs, job_number) }
  let(:ordered_files) { %w[File1 File2 File3] }
  before do
    allow(Kernel).to receive(:abort)
    allow(File).to receive(:size).and_return(0)
    allow(Kernel).to receive(:puts).and_call_original
    allow(Kernel).to receive(:system).and_return(true)
    allow_any_instance_of(described_class).to receive(:test_files).and_return(ordered_files)
  end

  describe 'when running tests' do
    it 'runs only tests corresponding to the current group/worker' do
      expect(Kernel).to receive(:system).with(include('File1'))
      inst.run
    end

    it 'does not run tests not corresponding the current worker' do
      expect(Kernel).not_to receive(:system).with(include(ordered_files[job_number]))
      inst.run
    end

    it 'chunks tests equally into defined groups' do
      expect(inst.send(:group_tests).count).to eq(qty_jobs)
    end
  end

  describe 'when sorting' do
    it 'sorts files by file size' do
      allow(inst).to receive(:test_files).and_call_original
      expect(File).to receive(:size).at_least(1)
      inst.run
    end
  end

  describe 'when balancing manually: (12 files / 3 groups) => 4 items per group, 50% of 4 is 2' do
    let(:qty_files) { 12 }
    let(:ordered_files) { qty_files.times.map { |no| "File #{no}" } }
    let(:balance_settings) { { 2 => { to: 1, percentage: 50 } } }
    before do
      allow(described_class).to receive(:balance_settings).and_return(balance_settings)
    end

    it 'moves the files to the target group' do
      expect(Kernel).to receive(:puts).with(include("running 6/#{qty_files} test files"))
      described_class.new(qty_jobs, 1).run
    end

    it 'moves the files from the source group' do
      expect(Kernel).to receive(:puts).with(include("running 2/#{qty_files} test files"))
      described_class.new(qty_jobs, 2).run
    end
  end
end
