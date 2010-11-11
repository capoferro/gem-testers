class TestResultsController < ApplicationController

  def create
    @result = TestResult.new fetch_yaml
    render :json => if @result.save
                      Response.new :success
                    else
                      @response = Response.new :fail
                      @result.errors.each { |attribute, errors| errors.each { |e| response.errors.add attribute, e } }
                      @response
                    end
  end
  
  private
  
  def fetch_yaml
    yaml = YAML::load params[:results]
    yaml[:arch]         = Architecture.find_or_create_by_name yaml[:arch]
    yaml[:vendor]       = Vendor.find_or_create_by_name yaml[:vendor]
    yaml[:machine_arch] = MachineArchitecture.find_or_create_by_name yaml[:machine_arch]
    yaml[:os]           = OperatingSystem.find_or_create_by_name yaml[:os]
    yaml
  end
end
