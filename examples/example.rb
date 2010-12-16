#$LOAD_PATH.push('./')
require 'rubygems'
require 'eluka'
require 'pp'

model = Eluka::Model.new(:directory => '/Users/raditya/Desktop',
#                  :svm_train_path   => "/opt/local/bin/svm-train",
#                  :svm_scale_path   => "/opt/local/bin/svm-scale",
#                  :svm_predict_path => "/opt/local/bin/svm-predict",
                  :grid_py_path     => "python /Users/raditya/Dropbox/Yahoo Internship/Code/libsvm-3.0/tools/grid.py",
                  :fselect_py_path  => "python /Users/raditya/Dropbox/Yahoo Internship/Code/libsvm-3.0/tools/fselect.py")

d1 = {:x => 3, :y => 1}
d2 = {:x => 1, :y => 3}
d3 = {:x => 3.5, :y => 1}
d4 = {:x => 1, :y => 4, :text => "Japanese Chinese", :title => "Cool great"}
d5 = {:x => 0, :y => 5}

model.add(d1, :positive)
model.add(d2, :negative)
model.add(d3, :positive)
model.add(d4, :negative)
model.add("Chinese Japanese", :positive)
model.add("Chinese Japanese", :positive)
model.add("Chinese Japanese", :positive)
model.add("Chinese Japanese", :positive)
model.add("Chinese Japanese", :positive)
model.build

#pp model.suggest_features

puts model.classify(d5)

__END__
model.add("Chinese Beijing Chinese", :positive)
model.add("Chinese Chinese Shanghai", :positive)
model.add("Chinese Macao", :positive)
model.add("Tokyo Japan Chinese", :negative)
#model.add("Tokyo Japan Chinese", :negative)
#model.add("Tokyo Japan Chinese", :negative)

features = model.suggest_features

features.push("beijing")
#pp features

model.build(features)

puts model.classify("Chinese Chinese Chinese Beijing Tokyo Japan India")


__END__

#(:verbose => true)#(:directory        => "/Users/raditya/Desktop")#,
                  # :svm_train_path   => "/opt/local/bin/svm-train",
                  # :svm_scale_path   => "/opt/local/bin/svm-scale",
                  # :svm_predict_path => "/opt/local/bin/svm-predict",
                  # :grid_py_path     => "python /Users/raditya/Dropbox/Yahoo Internship/Code/libsvm-3.0/tools/grid.py",
                  # :fselect_py_path  => "python /Users/raditya/Dropbox/Yahoo Internship/Code/libsvm-3.0/tools/fselect.py")
