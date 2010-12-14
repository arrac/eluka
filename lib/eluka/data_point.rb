module Eluka
  class DataPoint
    
    def initialize(data, analyzer)
      raise "Can't find any data" unless (data)
      
      if data.instance_of?(String)
        data = {:text => data}
      end
  
      raise "Invalid data added" unless (data.instance_of? Hash)
      raise "Data can't be empty" unless (data.size > 0)
  
      @data     = data 
      @analyzer = analyzer
    end
    
    def vector
      vector = Hash.new
      
      @data.each do |field, value|
        if value.instance_of?(String) then
          doc_vec = Eluka::Document.new(field, value, @analyzer).vector
          vector.merge!(doc_vec)
        elsif value.instance_of?(Fixnum) or value.instance_of?(Float)
          vector[field] = value
        else
          raise "A field can contain either an integer or a double or it can be a string"
        end
      end
  
      vector
    end
  
  end
end