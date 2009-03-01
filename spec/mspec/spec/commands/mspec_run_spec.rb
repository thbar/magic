require File.dirname(__FILE__) + '/../spec_helper'
require 'mspec/runner/mspec'
require 'mspec/commands/mspec-run'

describe MSpecRun, ".new" do
  before :each do
    @script = MSpecRun.new
  end

  it "sets config[:files] to an empty list" do
    @script.config[:files].should == []
  end
end

describe MSpecRun, "#options" do
  before :each do
    @stdout, $stdout = $stdout, IOStub.new

    @argv = ["a", "b"]
    @options, @config = new_option
    MSpecOptions.stub!(:new).and_return(@options)

    @script = MSpecRun.new
    @script.stub!(:config).and_return(@config)
  end

  after :each do
    $stdout = @stdout
  end

  it "enables the filter options" do
    @options.should_receive(:filters)
    @script.options @argv
  end

  it "enables the chdir option" do
    @options.should_receive(:chdir)
    @script.options @argv
  end

  it "enables the prefix option" do
    @options.should_receive(:prefix)
    @script.options @argv
  end

  it "enables the configure option" do
    @options.should_receive(:configure)
    @script.options @argv
  end

  it "provides a custom action (block) to the config option" do
    @script.should_receive(:load).with("cfg.mspec")
    @script.options ["-B", "cfg.mspec", "a"]
  end

  it "enables the name option" do
    @options.should_receive(:name)
    @script.options @argv
  end

  it "enables the randomize option to runs specs in random order" do
    @options.should_receive(:randomize)
    @script.options @argv
  end

  it "enables the dry run option" do
    @options.should_receive(:pretend)
    @script.options @argv
  end

  it "enables the background option" do
    @options.should_receive(:background)
    @script.options @argv
  end

  it "enables the unguarded option" do
    @options.should_receive(:unguarded)
    @script.options @argv
  end

  it "enables the interrupt single specs option" do
    @options.should_receive(:interrupt)
    @script.options @argv
  end

  it "enables the formatter options" do
    @options.should_receive(:formatters)
    @script.options @argv
  end

  it "enables the verbose option" do
    @options.should_receive(:verbose)
    @script.options @argv
  end

  it "enables the verify options" do
    @options.should_receive(:verify)
    @script.options @argv
  end

  it "enables the action options" do
    @options.should_receive(:actions)
    @script.options @argv
  end

  it "enables the action filter options" do
    @options.should_receive(:action_filters)
    @script.options @argv
  end

  it "enables the version option" do
    @options.should_receive(:version)
    @script.options @argv
  end

  it "enables the help option" do
    @options.should_receive(:help)
    @script.options @argv
  end

  it "exits if there are no files to process" do
    @options.should_receive(:parse).and_return([])
    @script.should_receive(:exit)
    @script.options
    $stdout.should =~ /No files specified/
  end

  it "calls #custom_options" do
    @script.should_receive(:custom_options).with(@options)
    @script.options @argv
  end
end

describe MSpecRun, "#run" do
  before :each do
    @script = MSpecRun.new
    @script.stub!(:exit)
    @spec_dir = File.expand_path(File.dirname(__FILE__)+"/fixtures")
    @file_patterns = [
      @spec_dir+"/level2",
      @spec_dir+"/one_spec.rb",
      @spec_dir+"/two_spec.rb"]
    @files = [
      @spec_dir+"/level2/three_spec.rb",
      @spec_dir+"/one_spec.rb",
      @spec_dir+"/two_spec.rb"]
    @script.options @file_patterns
  end

  it "registers the tags patterns" do
    @script.config[:tags_patterns] = [/spec/, "tags"]
    MSpec.should_receive(:register_tags_patterns).with([/spec/, "tags"])
    @script.run
  end

  it "registers the files to process" do
    MSpec.should_receive(:register_files).with(@files)
    @script.run
  end

  it "uses config[:files] if no files are given on the command line" do
    @script.config[:files] = @file_patterns
    MSpec.should_receive(:register_files).with(@files)
    @script.options []
    @script.run
  end

  it "processes the files" do
    MSpec.should_receive(:process)
    @script.run
  end

  it "exits with the exit code registered with MSpec" do
    MSpec.stub!(:exit_code).and_return(7)
    @script.should_receive(:exit).with(7)
    @script.run
  end
end
