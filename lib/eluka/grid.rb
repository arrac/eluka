
module Eluka
  module Grid
    def self.search(svm_train, c, g, fold, dataset)
      c[:begin]...c[:end].step(c[:step]) do |c_value|
        g[:begin]...g[:end].step(g[:step]) do |g_value|
          output = `#{svm_train} -c #{2**c_value} -g #{2**g_value} -v #{@fold} #{@dataset}`
          lines = output.split("\n")
          accuracy = lines[-1].split(" ")[-1].chomp
          puts "#{accuracy} (c = #{2**c}, g = #{2**g})"
        end
      end      
    end
  end
end

__END__
  @svm_train = "svm-train"
  
  @c_begin, @c_end, @c_step = [-5, 15, 2]
  @g_begin, @g_end, @g_step = [-15, 3, 2]
  
  @fold = 5
  @dataset = "/tmp/train"
  
  def self.run
    @c_begin...@c_end.step(@c_step) do |c|
      @g_begin...@g_end.step(@g_step) do |g|
        output = `#{@svm_train} -c #{2**c} -g #{2**g} -v #{@fold} #{@dataset}`
        lines = output.split("\n")
        accuracy = lines[-1].split(" ")[-1].chomp
        puts "#{accuracy} (c = #{2**c}, g = #{2**g})"
      end
    end
  end
end

begin
  GridSearch::run
end