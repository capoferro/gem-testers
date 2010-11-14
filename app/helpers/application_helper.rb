module ApplicationHelper

  def pass_fail ruby, os
    return 'unknown' if @os_matrix[ruby].nil? or @os_matrix[ruby][os].nil? or (@os_matrix[ruby][os][:pass].nil? and @os_matrix[ruby][os][:fail].nil?)
    @os_matrix[ruby][os][:pass] > 0 ? 'pass' : 'fail'
  end
  
end
