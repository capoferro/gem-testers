class VersionsController < ApplicationController

  def index
    redirect_to rubygem_path(params[:rubygem_id])
  end
  
  def show
    @rubygem = Rubygem.where(name: params[:rubygem_id]).first
    if @rubygem
      @version = Version.where(number: params[:id], rubygem_id: @rubygem.id).first
      if @version
        @test_results = TestResult.where(rubygem_id: @rubygem.id, version_id: @version.id).all
      end
    end

    unless @rubygem and @version and @test_results
      flash[:notice] = "This item could not be found"
      redirect_to :back rescue redirect_to root_url
    else
      fill_results_page    
    end
  end

end
