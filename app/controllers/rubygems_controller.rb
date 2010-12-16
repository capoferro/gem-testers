class RubygemsController < ApplicationController
  def index
    unless request.xhr?
      @rubygems = Rubygem.all
    else
      @rubygems = Rubygem.where(['name LIKE ?', "%#{params[:term]}%"]).all
      gem_names = @rubygems.collect { |gem| gem.name }
      render json: gem_names
    end
  end

  def show
    @rubygem = Rubygem.where(name: params[:id]).last || Rubygem.find(params[:id])
    if @rubygem
      @test_results = TestResult.where(rubygem_id: @rubygem.id).all
      fill_results_page
    else
      flash[:notice] = "That gem does not exist"
      redirect_to :back rescue redirect_to root_path 
    end
  end

end
