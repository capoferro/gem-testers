class Response
  
  def initialize data = []
    @data = []
    @data << data
    @data.flatten!
    @errors = ActiveModel::Errors.new self
  end

  def to_yaml
    {:data => @data, :errors => @errors.full_messages}.to_yaml
  end
end
