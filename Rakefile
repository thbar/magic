require 'rake'

desc "Home-baked spec task"
task :spec do
  unless ENV["RUBY_EXE"]
    # MSpec needs RUBY_EXE env var now - guess it from env
    ruby_exe = `which ir`.strip
    puts "Setting RUBY_EXE to '#{ruby_exe}'"
    ENV["RUBY_EXE"] = ruby_exe
  end
  
  #  system("ir spec/mspec/bin/mspec-run --format spec spec/*_spec.rb")
  # for some reason the latest build of ir (in the path) throws an error - works if I use older build
  system("mono /Users/thbar/Work/git/ironruby-labs/Release/ir.exe spec/mspec/bin/mspec-run --format spec spec/*_spec.rb")
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "magic"
    s.summary = %Q{TODO}
    s.email = "thibaut.barrere@gmail.com"
    s.homepage = "http://github.com/thbar/magic"
    s.description = "TODO"
    s.authors = ["Thibaut Barrère"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = 'magic'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib' << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |t|
    t.libs << 'test'
    t.test_files = FileList['test/**/*_test.rb']
    t.verbose = true
  end
rescue LoadError
  puts "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
end

begin
  require 'cucumber/rake/task'
  Cucumber::Rake::Task.new(:features)
rescue LoadError
  puts "Cucumber is not available. In order to run features, you must: sudo gem install cucumber"
end

task :default => :test
