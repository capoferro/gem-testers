class TestResultsController < ApplicationController

  protect_from_forgery :except => :create

  def create
    @result = TestResult.new result_attributes
    render :json => if @result.save
                      Response.new :success
                    else
                      @response = Response.new :fail
                      @result.errors.each { |attribute, errors| errors.each { |e| @response.errors.add(attribute, e) } }
                      @response
                    end
  end
  
  private
  
  def result_attributes
    result = YAML::load params[:results]
    attributes = {}
    attributes[:architecture]         = Architecture.find_or_create_by_name result[:arch]
    attributes[:vendor]               = Vendor.find_or_create_by_name result[:vendor]
    attributes[:machine_architecture] = MachineArchitecture.find_or_create_by_name result[:machine_arch]
    attributes[:operating_system]     = OperatingSystem.find_or_create_by_name result[:os]

    attributes[:test_output] = result[:test_output]
    attributes[:result] = result[:result]
    
    # TODO: if integrated with gemcutter, the following will be find only, with nil results resulting in some sort of error.
    attributes[:rubygem]              = Rubygem.find_or_create_by_name result[:name]
    
    version_details = {
      :rubygem_id => attributes[:rubygem].id,
      :number     => result[:version].release,
      :prerelease => result[:version].prerelease?
    }
    attributes[:version] = Version.where(version_details).first
    attributes[:version] ||= Version.create(version_details)
    
    attributes
  end
end
