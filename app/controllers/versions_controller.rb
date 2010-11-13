class VersionsController < ApplicationController

  def index
    redirect_to rubygem_path(params[:rubygem_id])
  end
  
  def show
    @version = Version.where(:id => params[:id], :rubygem_id => params[:rubygem_id]).first
  end

end
