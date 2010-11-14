class VersionsController < ApplicationController

  def index
    redirect_to rubygem_path(params[:rubygem_id])
  end
  
  def show
    @rubygem = Rubygem.where(:id => params[:rubygem_id]).first
    @version = Version.where(:id => params[:id], :rubygem_id => @rubygem.id).first
    @test_results = TestResult.where(:rubygem_id => @rubygem.id, :version_id => @version.id).all
    fill_results_page    
  end

end
