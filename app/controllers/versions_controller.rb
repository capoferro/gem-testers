class VersionsController < ApplicationController
  def index
  end

  def show
    @version = Version.where(:id => params[:id], :rubygem_id => params[:rubygem_id]).first
  end

end
