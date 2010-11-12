class RubygemsController < ApplicationController
  def index
    @rubygems = Rubygem.all
  end

  def show
    @rubygem = Rubygem.find(params[:id])
  end

end
