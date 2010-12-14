
module Eluka
  
  class Document
    def initialize(field, text, analyzer)
      @field        = field
      @text         = text
      @analyzer     = analyzer
      @bag_of_words = nil
      self.bag_of_words
    end
    
    def bag_of_words
      #Position counter for the document
      pos = 0
      
      @bag_of_words = Hash.new
      
      #Token Stream
      token_stream = @analyzer.token_stream(:field, @text)
      while token = token_stream.next do      
        pos += token.pos_inc
  
        @bag_of_words[token.text] = Array.new unless @bag_of_words[token.text] 
        @bag_of_words[token.text].push(pos)    
      end
      
    end
    
    def vector
      vector = Hash.new
      squared_length = 0
      @bag_of_words.each do |term, pos_vector|
        squared_length += pos_vector.size**2
        #vector[[@field,term].join("||")] = pos_vector.size
      end
  
      length = squared_length.to_f**0.5
      @bag_of_words.each do |term, pos_vector|      
        vector[[@field,term].join("||")] = pos_vector.size.to_f / length
      end
  
      vector
    end
  end

end