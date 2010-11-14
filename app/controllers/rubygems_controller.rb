class RubygemsController < ApplicationController
  def index
    @rubygems = Rubygem.all
  end

  def show
    @rubygem = Rubygem.find(params[:id])
    @test_results = TestResult.where(:rubygem_id => params[:id]).all
    fill_results_page
  end


end
