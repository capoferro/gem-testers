class RubygemsController < ApplicationController
  def index
    @rubygems = Rubygem.all
  end

  def show
    @rubygem = Rubygem.find(params[:id])
    @test_results = TestResult.where(:rubygem_id => params[:id]).all

    @os_matrix = {}
    @test_results.each do |result|
      @os_matrix[result.ruby_version] ||= {}
      @os_matrix[result.ruby_version][result.operating_system] ||= {}
      @os_matrix[result.ruby_version][result.operating_system][:pass] ||= 0
      @os_matrix[result.ruby_version][result.operating_system][:fail] ||= 0
      @os_matrix[result.ruby_version][result.operating_system][(result.result ? :pass : :fail)] += 1
    end

    @ruby_versions = @os_matrix.keys
    @operating_systems = @test_results.collect { |r| r.operating_system }.uniq
  end

end
