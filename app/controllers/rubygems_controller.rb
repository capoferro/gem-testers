require 'rss_feed'
require 'show_paged'

class RubygemsController < ApplicationController

  include ShowPaged
  
  def index
    if request.xhr? # autocomplete for the homepage
      @rubygems = Rubygem.where(['name LIKE ?', "%#{params[:term]}%"]).all
      gem_names = @rubygems.collect { |gem| gem.name }
      render json: gem_names
    else
      respond_to do |format|
        format.html { @latest_results = TestResult.order('created_at DESC').limit(10) }
      end
    end
  end

  def show
    @rubygem = Rubygem.where(name: params[:id]).last || Rubygem.where(id: params[:id]).last
    @platform = params[:platform] unless params[:platform].blank?

    respond_to do |format|
      format.json { render json: (@rubygem.nil? ? {} : @rubygem.to_json(include: { versions: {include: :test_results} } )) }
      format.html do
        if @rubygem
          @paged_source = rubygem_paged_path(@rubygem.name, %q[json])
          if @platform
            @paged_source += '?platform=' + @platform
            @test_results = TestResult.where(rubygem_id: @rubygem.id).where(platform: @platform).all
            @all_test_results = TestResult.where(rubygem_id: @rubygem.id)
          else
            @test_results = TestResult.where(rubygem_id: @rubygem.id).all
            @all_test_results = @test_results
          end
          
          fill_results_page
          
        else
          flash[:notice] = "Sorry, there's no data for #{params[:id]} yet."
          redirect_to :back rescue redirect_to root_path and return
        end
      end
    end
  end

  def feed

    rubygem = Rubygem.where(name: params[:rubygem_id]).last

    unless rubygem
      rubygem = Rubygem.find(params[:rubygem_id]) rescue nil
    end

    if rubygem
      respond_to do |format|
        format.xml { render :text => generate_feed(rubygem) }
      end
    else
      head 403
    end
  end
end
