class VersionsController < ApplicationController

  def index
    redirect_to rubygem_path(params[:rubygem_id])
  end
  
  def show
    # /gems/somegem/1.2.3.json routes to id: 1.2.3.json,
    # not id: 1.2.3, format: json, so parse the .json off the end of
    # the string and set a flag to render the proper format.
    respond_to_json = !!(params[:id] =~ /(.+)\.json$/)
    version_number = $1 || params[:id]
    @rubygem = Rubygem.where(name: params[:rubygem_id]).first
    
    @version = Version.where(number: version_number, rubygem_id: @rubygem.id).first if @rubygem
    
    if respond_to_json
      render json: @version, include: :test_results if not @version.nil?
      render json: {} if @version.nil?
    else
      if @rubygem.nil?
        flash[:notice] = "Couldn't find that gem!"
        redirect_to rubygems_path and return
      end
      
      if @version.nil?
        flash[:notice] = "That version doesn't seem to exist."
        redirect_to rubygem_path(@rubygem.name) and return
      else
        @test_results = TestResult.where(rubygem_id: @rubygem.id, version_id: @version.id).all if @rubygem and @version
      end
      
      fill_results_page
    end
  end

end

