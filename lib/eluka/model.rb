
module Eluka
  class Model
    include Ferret::Analysis
    
    # Initialize the classifier with sane defaults 
    # if customised data is not provided
    
    def initialize (params = {})
      #Set the labels
      @labels             = Bijection.new
      @labels[:positive]  =  1
      @labels[:negative]  = -1
      @labels[:unknown]   =  0
      
      @gem_root           = File.expand_path(File.join(File.dirname(__FILE__), '..'))
      @bin_dir            = File.expand_path(File.join(File.dirname(@gem_root), 'bin'))

      @analyzer           = StandardAnalyzer.new
      @features           = Eluka::Features.new
      @fv_train           = Eluka::FeatureVectors.new(@features, true)
      @fv_test            = nil
      
      @directory          = (params[:directory]         or "/tmp")
      @svm_train_path     = (params[:svm_train_path]    or "#{@bin_dir}/eluka-svm-train")
      @svm_scale_path     = (params[:svm_scale_path]    or "#{@bin_dir}/eluka-svm-scale")
      @svm_predict_path   = (params[:svm_predict_path]  or "#{@bin_dir}/eluka-svm-predict")
      @grid_py_path       = (params[:grid_py_path]      or "python rsvm/tools/grid.py")
      @fselect_py_path    = (params[:fselect_py_path]   or "python rsvm/tools/fselect.py")
      @verbose            = (params[:verbose]           or false)
      
      #Convert directory to absolute path
      Dir.chdir(@directory) do @directory = Dir.pwd end
    end
    
    # Add a data point to the training data
  
    def add (data, label)
      raise "No meaningful label associated with data" unless ([:positive, :negative].include? label)
  
      data_point = Eluka::DataPoint.new(data, @analyzer)
      @fv_train.add(data_point.vector, @labels[label])
        end
  
    # Build a model from the training data using LibSVM
    
    def build (features = nil)
      File.open(@directory + "/train", "w") do |f| f.puts @fv_train.to_libSVM(features) end
      
      output = `#{@svm_train_path} #{@directory}/train #{@directory}/model`
      
      puts output if (@verbose)
  
      @fv_test  = Eluka::FeatureVectors.new(@features, false)
      return output
    end
    
    # Classify a data point
    
    def classify (data, features = nil)
      raise "Untrained model" unless (@fv_test)
  
      data_point = Eluka::DataPoint.new(data, @analyzer)
      @fv_test.add(data_point.vector)
  
      File.open(@directory + "/classify", "w") do |f| f.puts @fv_test.to_libSVM(features) end
      output = `#{@svm_predict_path} #{@directory}/classify #{@directory}/model #{@directory}/result`
      
      puts output if (@verbose)
  
      return @labels.lookup( File.open( @directory + "/result", "r" ).read.to_i )
    end
    
    # Suggests the best set of features chosen using fselect.py
    # IMPROVE: Depending on fselect.py (an unnecessary python dependency) is stupid
    # TODO: Finish wirting fselect.rb and integrate it 
    
    def suggest_features 
      sel_features = Array.new
  
      File.open(@directory + "/train", "w") do |f| f.puts @fv_train.to_libSVM end
  
      Dir.chdir('./rsvm/bin/tools') do
        output = `python fselect.py #{@directory}/train`
  
        puts output if (@verbose)
        
        x = File.read("train.select")
        sel_f_ids = x[1..-2].split(", ")
        sel_f_ids.each do |f|
          s_f = @features.term(f.to_i)
          if s_f.instance_of? String then
            s_f     = s_f.split("||")
            s_f[0]  = s_f[0].to_sym
          end
          sel_features.push(s_f)
        end
        
        #Remove temporary files
        File.delete("train.select") if File.exist?("train.select")
        File.delete("train.fscore") if File.exist?("train.fscore")
        File.delete("train.tr.out") if File.exist?("train.tr.out")
      end
      
      return sel_features
    end
  end

end