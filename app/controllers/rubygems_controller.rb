require 'rss_feed'

class RubygemsController < ApplicationController
  def index
    if request.xhr?
      @rubygems = Rubygem.where(['name LIKE ?', "%#{params[:term]}%"]).all
      gem_names = @rubygems.collect { |gem| gem.name }
      render json: gem_names
    else
      @latest_results = TestResult.order('created_at DESC').limit(10);
    end
  end

  def show
    id = params[:id] || params[:rubygem_id]
    @rubygem = Rubygem.last(conditions: {name: id}) || Rubygem.last(conditions: {id: id})

    
    respond_to do |format|
      format.json do
        render json: if @rubygem                       
                       # case params[:filter]
                       # when 'pass'
                       #   @rubygem.to_json(include: { versions: {include: {test_results: {conditions: {result: true} }}} })
                       # when 'fail'
                       #   @rubygem.to_json(include: { versions: {include: {test_results: {conditions: {result: false} }}} })
                       # else
                         @rubygem.to_json(include: { versions: {include: :test_results} })
                       # end
                     else
                       {}
                     end
      end
      format.html do
        if @rubygem
          results_query = TestResult.where(rubygem_id: @rubygem.id)
          @test_results = case params[:filter]
                          when 'pass'
                            results_query.where(result: true).all
                          when 'fail'
                            results_query.where(result: false).all
                          else
                            results_query.all
                          end
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
