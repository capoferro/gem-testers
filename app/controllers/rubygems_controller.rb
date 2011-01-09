require 'rss_feed'

class RubygemsController < ApplicationController
  def index
    if request.xhr? # autocomplete for the homepage
      @rubygems = Rubygem.where(['name LIKE ?', "%#{params[:term]}%"]).all
      gem_names = @rubygems.collect { |gem| gem.name }
      render json: gem_names
    else
      respond_to do |format|
        format.html { @latest_results = TestResult.order('created_at DESC').limit(10) }
        format.json do
          q = TestResult.where('created_at > ?', 1.hour.ago)
          render json: {
            pass_count: q.where(result: true).count,
            fail_count: q.where(result: false).count,
            test_results: q.order('created_at DESC').all.collect(&:simple_attributes)
          }
        end
      end
    end
  end

  def show
    @rubygem = Rubygem.where(name: params[:id]).last || (Rubygem.find(params[:id]) rescue nil)
    
    respond_to do |format|
      format.json { render json: (@rubygem.nil? ? {} : @rubygem.to_json(include: { versions: {include: :test_results} } )) }
      format.html do
        if @rubygem
          @test_results = TestResult.where(rubygem_id: @rubygem.id).all
          fill_results_page
        elsif !params[:format]
          flash[:notice] = "Couldn't find that gem!"
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
        format.xml do
          render :text => generate_feed(rubygem)
        end
      end
    else
      head 403
    end
  end
end
