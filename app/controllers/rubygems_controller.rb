class RubygemsController < ApplicationController
  def index
    @rubygems = Rubygem.all
  end

  def show
    @rubygem = Rubygem.find(params[:id])
    @test_results = TestResult.where(:rubygem_id => params[:id]).all
    fill_results_page
  end

  def platform_overlay
    @rubygem = Rubygem.find(params[:rubygem_id])
    @test_results = TestResult.where(:rubygem_id => params[:rubygem_id], :ruby_version => params[:ruby_version], :operating_system => params[:operating_system]).all
    @platform_breakdown = {}
    @test_results.each do |result|
      platform = result.platform
      platform ||= 'None Given'
      @platform_breakdown[platform] ||= 0
      @platform_breakdown[platform] += 1
    end
  end
end
