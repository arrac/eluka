#Creates a two way hash like lookup using two hashes
#Source inspired from a post in some forum
#Author: Unknown
module Eluka
  class Bijection < Hash
    def initialize(*args)
      super(*args)
      @reverse = self.invert
    end
  
    def []=(key, val)
      super(key, val)
      if @reverse.has_key?(val)
        self.delete(@reverse[val])
      end
      @reverse[val] = key
    end
  
    def lookup(val)
      @reverse[val]
    end
  end
end