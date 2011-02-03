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
      end
    end
  end

  def show_paged
    rubygem = Rubygem.where(name: params[:rubygem_id]).last || Rubygem.where(id: params[:rubygem_id]).last
    
    q = TestResult.where(rubygem_id: rubygem.id).includes(:version)
    @count = q.count

    # Gem Version is pulled from the versions table
    column_list = ['result', 'versions.number', 'platform', 'ruby_version', 'operating_system', 'architecture', 'vendor'].freeze

    column_sorted = column_list[params[:iSortCol_0].to_i]
    sort_direction = params[:sSortDir_0]

    filtered_q = q.order("#{column_sorted} #{sort_direction}")

    @filtered_count = filtered_q.count
    @results = filtered_q.offset(params[:iDisplayStart]).limit(params[:iDisplayLength]).all
    
    render json: {iTotalRecords: @filtered_count, iTotalDisplayRecords: @count, aaData: @results.collect(&:datatables_attributes)}
  end

  def show
    @rubygem = Rubygem.where(name: params[:id]).last || Rubygem.where(id: params[:id]).last
    @platform = params[:platform] unless params[:platform].blank?
    respond_to do |format|
      format.json { render json: (@rubygem.nil? ? {} : @rubygem.to_json(include: { versions: {include: :test_results} } )) }
      format.html do
        if @rubygem
          if @platform
            @test_results = TestResult.where(rubygem_id: @rubygem.id).where(platform: @platform).all
            @all_test_results = TestResult.where(rubygem_id: @rubygem.id)
          else
            @test_results = TestResult.where(rubygem_id: @rubygem.id).all
            @all_test_results = @test_results
          end

          unless @test_results.empty?
            fill_results_page
          else
            if @platform
              flash[:notice] = "No results for that platform"
              redirect_to rubygem_path(@rubygem) and return
            else
              flash[:notice] = "No results for that gem"
              redirect_to root_path and return
            end
          end
        else
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
