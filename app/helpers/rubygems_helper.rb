module RubygemsHelper

  #
  # Selectors used on the test_results overview page (app/views/shared/_test_results_page.haml.html)
  #
  # All this shit needs to be refactored in the DB.
  #
  
  def version_select(rubygem, version, platform, tag_name='version')
    select_tag tag_name,
      options_for_select(get_versions(rubygem, platform), :selected => current_version(rubygem, version, platform)),
      :class => 'version-select'
  end

  def current_version(rubygem, version, platform)
    if version.nil?
      rubygem_path(rubygem) 
    else
      rubygem_version_path(rubygem.name, version.number, :platform => platform) 
    end
  end

  def get_versions(rubygem, platform)
    #
    # FIXME Turn this into a straight query that groups or distinct's version. Doing it this way is slow.
    # 
    versions = rubygem.versions.collect do |v| 
      [v.number, rubygem_version_path(rubygem.name, v.number, :platform => platform)] 
    end 

    versions.unshift(['All versions', rubygem_path(rubygem.name)])
    versions
  end

  def platform_select(test_results, rubygem, platform, version, tag_name='platform')
    select_tag 'platform', 
      options_for_select(get_platforms(test_results, rubygem, version), :selected => current_platform(platform, rubygem, version)), 
        :class => 'version-select'
  end

  def current_platform(platform, rubygem, version)
    if platform.nil?
      if version
        rubygem_version_path(rubygem.name, version.number)
      else
        rubygem_path(rubygem) 
      end
    else
      if version
        rubygem_version_path(rubygem.name, version.number)
      else
        rubygem_path(rubygem.name, :platform => platform)
      end
    end
  end

  def get_platforms(test_results, rubygem, version)
    #
    # FIXME Turn this into a straight query that groups or distinct's platform. Doing it this way is slow.
    # 
    platforms = test_results.map(&:platform).uniq.map do |x|
      # ugh bad inner loop bad
      if version
        [x, rubygem_version_path(rubygem.name, version.number, :platform => x)]
      else
        [x, rubygem_path(rubygem.name, :platform => x)]
      end
    end

    if version
      platforms.unshift(['All platforms', rubygem_version_path(rubygem.name, version.number)])
    else
      platforms.unshift(['All platforms', rubygem_path(rubygem.name)])
    end

    platforms
  end
end
