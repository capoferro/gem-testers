require 'show_paged'

class VersionsController < ApplicationController

  include ShowPaged
  
  def index
    redirect_to rubygem_path(params[:rubygem_id])
  end
  
  def show

    version_number = params[:id]

    # HACK HACK HACK
    #
    # rails can't handle version numbers PLUS the .json extension properly.
    # the Accepts: header works fine of course, but if passed a .json extension
    # it will be part of the :id. So, we detect this, scrub the extension and
    # set the format.
    #
    # HACK HACK HACK
    if params[:id] =~ /\.json$/
      version_number = params[:id].sub(/\.json$/, '')
      request.format = :json
    end

    @rubygem = Rubygem.where(name: params[:rubygem_id]).first
    @version = Version.where(number: version_number, rubygem_id: @rubygem.id).first if @rubygem
    @platform = params[:platform] unless params[:platform].blank?

    respond_to do |format|
      format.json do 
        if @version.nil?
          render json: {}
        else
          render json: @version, include: [:test_results], methods: [:pass_count, :fail_count]
        end
      end

      format.html do
        if @rubygem.nil?
          flash[:notice] = "Couldn't find that gem!"
          redirect_to rubygems_path and return
        end

        if @version.nil?
          flash[:notice] = "That version doesn't seem to exist."
          redirect_to rubygem_path(@rubygem.name) and return
        else
          if @rubygem and @version
            @paged_source = version_paged_path(@rubygem.name, @version.number)
            if @platform
              @paged_source += "?platform=#{@platform}"
              @test_results = TestResult.where(rubygem_id: @rubygem.id, version_id: @version.id, platform: @platform).all
              @all_test_results = TestResult.where(rubygem_id: @rubygem.id, version_id: @version.id).all
            else
              @test_results = @all_test_results = TestResult.where(rubygem_id: @rubygem.id, version_id: @version.id).all
            end
          end
        end
        fill_results_page
      end
    end
  end
end

