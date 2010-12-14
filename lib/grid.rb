
module GridSearch
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