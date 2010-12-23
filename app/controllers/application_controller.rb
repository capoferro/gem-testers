class ApplicationController < ActionController::Base
  protect_from_forgery

  layout :select_layout

  private
  
  def select_layout
    if request.xhr?
      nil
    else
      'application'
    end
  end

  def fill_results_page 
    @os_matrix = populate_os_matrix @test_results
    @ruby_versions = @os_matrix.keys
    @operating_systems = @test_results.collect { |r| r.operating_system }.uniq
  end

  def populate_os_matrix test_results
    os_matrix = {}
    test_results.each do |result|
      os_matrix[result.ruby_version] ||= {}
      os_matrix[result.ruby_version][result.operating_system] ||= {}
      os_matrix[result.ruby_version][result.operating_system][:pass] ||= 0
      os_matrix[result.ruby_version][result.operating_system][:fail] ||= 0
      os_matrix[result.ruby_version][result.operating_system][(result.result ? :pass : :fail)] += 1
    end
    os_matrix
  end
end
