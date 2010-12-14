#trying to convert fselect.py method by method into ruby
require 'rbconfig'

##### Path Setting #####
is_win32 = (Config::CONFIG["host_os"] == 'win32')
unless is_win32
	gridpy_exe      = "./grid.py -log2c -2,9,2 -log2g 1,-11,-2"
	svmtrain_exe    = "../svm-train"
	svmpredict_exe  = "../svm-predict"
else
	gridpy_exe      = ".\\grid.py -log2c -2,9,2 -log2g 1,-11,-2"
	svmtrain_exe    = "..\\windows\\svmtrain.exe"
	svmpredict_exe  = "..\\windows\\svmpredict.exe"
end

##### Global Variables #####

@train_pathfile=""
@train_file=""
@test_pathfile=""
@test_file=""
@if_predict_all=0

@whole_fsc_dict={}
@whole_imp_v=[]

VERBOSE_MAX=100
VERBOSE_ITER = 3
VERBOSE_GRID_TIME = 2
VERBOSE_TIME = 1

def arg_process
  unless (ARGV.size == 2 or ARGV.size == 3)
    puts 'Usage: #{ARGV[0]} training_file [testing_file]'
    exit
  end
  
  @train_pathfile = ARGV[1]
  raise "training file not found" unless File.exist? @train_pathfile
  @train_file = File.basename(@train_pathfile)
  
  if ARGV.size == 3
    @test_pathfile = ARGV[1]
    raise "testing file not found" unless File.exist? @test_pathfile
    @test_file = File.basename(@test_pathfile)    
  end
end


##### Decide sizes of selected feautures #####

def feat_num_try_half(max_index)
	v=[]
	while max_index > 1 do
		v.push(max_index)
		max_index /= 2
  end
	return v
end

def feat_num_try(f_tuple)
	for i in 0...f_tuple.size do
		if f_tuple[i][1] < 1e-20
			i = i - 1
      break
    end
  end
	#only take first eight numbers (>1%)
	return feat_num_try_half(i+1)[0...8]
end

def random_shuffle(label, sample)
  srand 1
	size = label.size
	for i in 0...label.size
		ri = rand(size)
		tmp = label[ri]
		label[ri] = label[size-i-1]
		label[size-i-1] = tmp
		tmp = sample[ri]
		sample[ri] = sample[size-i-1]
		sample[size-i-1] = tmp
  end
end


### compare function used in list.sort(): sort by element[1]
#def value_cmpf(x,y):
#	if x[1]>y[1]: return -1
#	if x[1]<y[1]: return 1
#	return 0

def value_cmpf(x)
	return (-x[1])
end

### cal importance of features
### return fscore_dict and feat with desc order
def cal_feat_imp(label, sample)

	puts("calculating fsc...")

	score_dict = cal_Fscore(label, sample)

  #NOTE: Convert the following two lines carefully
	score_tuples = list(score_dict.items())
	score_tuples.sort(key = value_cmpf)

	feat_v = score_tuples
	for i in 0...feat_v.size
    feat_v[i] = score_tuples[i][0]
  end
  
	puts("fsc done")
	return score_dict,feat_v
end



### select features and return new data
def select(sample, feat_v)
	new_samp = []

	feat_v.sort()

	#for each sample
  sample.each do |key, s| #NOTE: Extremely doubtful conversion
    point = Hash.new
		#for each feature to select
    feat_v.each do |f|
			if s[f] 
        point[f]=s[f]
      end
    end
		new_samp.push(point)
  end
	return new_samp
end


=begin
#TODO: Convert the following code

### Do parameter searching (grid.py) 
def train_svm(tr_file)
	cmd = "#{gridpy_exe} #{tr_file}"
	puts(cmd)
	puts('Cross validation...')
	std_out = Popen(cmd, shell = True, stdout = PIPE).stdout

	line = ''
	while 1:
		last_line = line
		line = std_out.readline()
		if not line: break
	c,g,rate = map(float,last_line.split())

	print('Best c=%s, g=%s CV rate=%s' % (c,g,rate))

	return c,g,rate

### Given (C,g) and training/testing data,
### return predicted labels
def predict(tr_label, tr_sample, c, g, test_label, test_sample, del_model=1, model_name=None):
	global train_file
	tr_file = train_file+".tr"
	te_file = train_file+".te"
	if model_name:  model_file = model_name
	else:  model_file = "%s.model"%tr_file
	out_file = "%s.o"%te_file
        
	# train
	writedata(tr_sample,tr_label,tr_file)
	cmd = "%s -c %f -g %f %s %s" % (svmtrain_exe,c,g,tr_file,model_file)
	os.system(cmd) 

	# test
	writedata(test_sample,test_label,te_file)
	cmd = "%s %s %s %s" % (svmpredict_exe, te_file,model_file,out_file )
	print(cmd)
	os.system(cmd)
        
	# fill in pred_y
	pred_y=[]
	fp = open(out_file)
	line = fp.readline()
	while line:
		pred_y.append( float(line) )
		line = fp.readline()
        
	rem_file(tr_file)
	#rem_file("%s.out"%tr_file)
	#rem_file("%s.png"%tr_file)
	rem_file(te_file)
	if del_model: rem_file(model_file)
	fp.close()
	rem_file(out_file)
        
	return pred_y


def cal_acc(pred_y, real_y):
	right = 0.0

	for i in range(len(pred_y)):
		if(pred_y[i] == real_y[i]): right += 1

	print("ACC: %d/%d"%(right, len(pred_y)))
	return right/len(pred_y)

### balanced accuracy
def cal_bacc(pred_y, real_y):
	p_right = 0.0
	n_right = 0.0
	p_num = 0
	n_num = 0

	size=len(pred_y)
	for i in range(size):
		if real_y[i] == 1:
			p_num+=1
			if real_y[i]==pred_y[i]: p_right+=1
		else:
			n_num+=1
			if real_y[i]==pred_y[i]: n_right+=1

	print([p_right,p_num,n_right,n_num])
	writelog("       p_yes/p_num, n_yes/n_num: %d/%d , %d/%d\n"%(p_right,p_num,n_right,n_num))
	if p_num==0: p_num=1
	if n_num==0: n_num=1
	return 0.5*( p_right/p_num + n_right/n_num )
=end

##### Log related #####
def initlog(name)
  @logname = name
  logfile = File.open(@logname, "w").close
end

def writelog(str, vlevel = VERBOSE_MAX)
  if vlevel > VERBOSE_ITER
    logfile = File.open(@logname, "a")
    logfile.print(str)
    logfile.close
  end
end

###### svm data IO ######

def readdata(filename)
  labels = Array.new
  samples = Array.new
  max_index = 0
  
  f = File.open(filename)
  
  f.each_line do |line| 
    line.chomp!
    next if line[0] == "#"
    
    elems = line.split(" ")
    sample = Hash.new
    label_read = false
    elements.each do |e|
      unless label_read
        labels.push e.to_f
        label_read = true
        next
      end
      
      feature, value = e.split(":")
      p0 = feature.chomp.to_i
      p1 = value.chomp.to_f
      sample[p0] = p1
      
      max_index = p0 if p0 > max_index
      
      samples.push(sample)
    end
  end
  
  f.close
  
  return labels, samples, max_index
end

def writedata(samples, labels, filename)
  fp = $stdout
  if filename
		fp = File.open(filename, "w")
  end

	num = samples.size
  samples.each_index do |i|
    if labels
      fp.print label[i]
    else
      fp.print "0"
    end
    samples[i].keys.sort.each do |k|
      fp.print(" #{k}:#{samples[i][k]}")
    end
    fp.puts ""
  end
  fp.close  
end

###### PROGRAM ENTRY POINT ######

arg_process()

initlog("#{@train_file}.select")
writelog("start: #{Time.now}\n\n")
main()

# do testing on all possible feature sets
if if_predict_all
	predict_all()
end

writelog("\nend: \n#{Time.now}\n")