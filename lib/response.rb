class Response
  
  def initialize data = []
    @data = []
    @data << data
    @data.flatten!
    @errors = ActiveModel::Errors.new self
  end

end
