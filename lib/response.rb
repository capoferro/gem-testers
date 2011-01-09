class Response

  attr_accessor :success, :data
  attr_reader :errors
  
  def initialize data = []
    @data = []
    @data << data
    @data.flatten!
    @errors = ActiveModel::Errors.new self
  end

  def to_yaml
    {success: @success, data: @data, errors: @errors.full_messages}.to_yaml
  end

  def self.human_attribute_name attr, options={}
    attr
  end

  def merge_errors other_errors, options={}
    other_object_string = " of the #{options[:object_name].downcase}" if options[:object_name] and !options[:object_name].empty?
    other_errors.each do |key, error|
      @errors.add :"#{key.capitalize}#{other_object_string}", error
    end
    self
  end
end
