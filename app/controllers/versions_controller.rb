class VersionsController < ApplicationController

  def index
    redirect_to rubygem_path(params[:rubygem_id])
  end
  
  def show
    @rubygem = Rubygem.where(name: params[:rubygem_id]).first
    if @rubygem
      @version = Version.where(number: params[:id], rubygem_id: @rubygem.id).first
      if @version.nil?
        flash[:notice] = "That version doesn't seem to exist."
        redirect_to rubygem_path(@rubygem.name) and return
      else
        @test_results = TestResult.where(rubygem_id: @rubygem.id, version_id: @version.id).all if @rubygem and @version
      end
    else
      flash[:notice] = "Couldn't find that gem!"
      redirect_to rubygems_path and return
    end

    fill_results_page    
  end

end

