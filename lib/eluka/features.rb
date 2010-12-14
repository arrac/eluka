
module Eluka
  
  class Features
    def initialize
      @features = Eluka::Bijection.new
      @f_count  = 0
    end
  
    attr_reader :f_count
  
    def add (term)
      unless @features[term] then
        @f_count += 1
        @features[term] = @f_count
      end
      return @features[term]
    end
    
    def id (term)
      @features[term]
    end
    
    def term (id)
      @features.lookup(id)
    end
  
  end
  
end

