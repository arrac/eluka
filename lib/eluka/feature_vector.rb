#!/usr/bin/env ruby
# 
# Feature Vectors performs two important functions
#
# 1. Maintain a list of <feature, value> pairs for each data point (vector)
# so that a model can be built whenever needed. (Sparse representation)
#
# 2. Adds every feature to the Features object to maintain
# a unique list of features
#
# TODO: On disk representation for large training data
module Eluka
  
  class FeatureVectors
    
    # Feature Vectors for a data point need to know the
    # global list of features and their respective ids
    #
    # During training, as we keep finding new features
    # we add them to the features list
    #
    # Hence we need to know whether the vectors we are computing
    # are for training or classification
    
    def initialize (features, train)
      @fvs      = Array.new
      @features = features  #Instance of features
      @train    = train     #Boolean
    end
    
    # We just keep all data points stored and convert them to 
    # feature vectors only on demand
    
    def add (vector, label = 0)
      @fvs.push([vector, label])
    end
    
    # For training data points we make sure all the features 
    # are added to the feature list
    
    def define_features
      @fvs.each do |vector, label|
        vector.each do |term, value|
          @features.add(term)
        end
      end
    end
    
    # Creates feature vectors and converts them to
    # LibSVM format -- a multiline string with one
    # data point per line
    #
    # If provided with a list of selected features then
    # insert only those features
    
    def to_libSVM (sel_features = nil)
      
      #Load the selected features into a Hash
      sf = Hash.new
      if (sel_features)
        sel_features.each do |f| 
          sf[f] = 1 
        end
      end
      
      self.define_features if (@train) #This method is needed only for training data
      
      output = Array.new
      @fvs.each do |vector, label|
        line = Array.new
        line.push(label)
        
        (1..@features.f_count).each do |id| #OPTIMIZE: Change this line to consider sorting in case of terms being features
          term = @features.term(id)
          if ( value = vector[term] ) then
            line.push([id, value].join(":")) if sf[term] or not sel_features
          end
        end
        output.push(line.join(" "))
      end
      output.join("\n")
    end
    
  end
  
end