module ShowPaged
  
  def show_paged
    rubygem = Rubygem.where(name: params[:rubygem_id]).last || Rubygem.where(id: params[:rubygem_id]).last

    conditions = {rubygem_id: rubygem.id}
    conditions.merge!(platform: params[:platform]) if params[:platform]
    
    if params[:version_id]
      v = Version.where(number: params[:version_id], rubygem_id: rubygem.id).first
      conditions.merge!(version_id: v.id)
    end
    
    filtered_q = q = TestResult.where(conditions).includes(:version).includes(:rubygem)
    
    @count = q.count

    unless params[:sSearch].nil? or params[:sSearch].empty?
      filtered_q = q.matching(params[:sSearch])
    end

    @filtered_count = filtered_q.count
    @results = filtered_q.offset(params[:iDisplayStart]).limit(params[:iDisplayLength]).all
    
    render json: {iTotalRecords: @count, iTotalDisplayRecords: @filtered_count, aaData: @results.collect(&:datatables_attributes)}
  end
  
end
