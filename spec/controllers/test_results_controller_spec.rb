require 'spec_helper'

describe TestResultsController do

  before :all do
    @results_yaml = <<-YAML
--- 
:arch: x86_64-linux
:vendor: unknown
:os: linux
:machine_arch: x86_64
:name: methlab
:version: 
  :prerelease: false
  :release: 0.1.0
:result: true
:test_output: |
  /home/josiah/.rvm/rubies/ruby-1.9.2-p0/bin/ruby -I"lib:lib" "/home/josiah/.rvm/rubies/ruby-1.9.2-p0/lib/ruby/1.9.1/rake/rake_test_loader.rb" "test/test_checks.rb" "test/test_integrate.rb" "test/test_inline.rb" "test/test_defaults.rb" 
  Loaded suite /home/josiah/.rvm/rubies/ruby-1.9.2-p0/lib/ruby/1.9.1/rake/rake_test_loader
  Started
  ............

YAML
  end

  it 'should accept test results yaml and store it' do
    r = Factory.create(:rubygem, :name => 'methlab')
    n = Factory.create(:version, :rubygem_id => r.id, :number => '0.1.0')
    
    post :create, 'results' => @results_yaml

    response.body.should == Response.new(rubygem_version_test_result_url(r.name,n.number,TestResult.order(:id).last.id)).to_yaml

    result = TestResult.last

    output = "/home/josiah/.rvm/rubies/ruby-1.9.2-p0/bin/ruby -I\"lib:lib\" \"/home/josiah/.rvm/rubies/ruby-1.9.2-p0/lib/ruby/1.9.1/rake/rake_test_loader.rb\" \"test/test_checks.rb\" \"test/test_integrate.rb\" \"test/test_inline.rb\" \"test/test_defaults.rb\" \nLoaded suite /home/josiah/.rvm/rubies/ruby-1.9.2-p0/lib/ruby/1.9.1/rake/rake_test_loader\nStarted\n............\n"
    {
      :architecture => 'x86_64-linux',
      :vendor => 'unknown',
      :operating_system => 'linux',
      :machine_architecture => 'x86_64',
      :result => true,
      :test_output => output,
      :rubygem => r,
      :version => n
    }.each do |key, value|
      result.send(key).should == value
    end
    
  end

  describe '#show' do
    it 'should respond to json' do
      r = Factory.create :rubygem
      v = Factory.create :version, rubygem: r
      t = Factory.create :test_result, rubygem: r, version: v

      get :show, rubygem_id: r.name, version_id: v.number, id: t.id, format: 'json'

      response.body.should == t.to_json
    end
    
    it 'should respond to json when the test result doesn\'t exist' do
      r = Factory.create :rubygem
      v = Factory.create :version, rubygem: r

      get :show, rubygem_id: r.name, version_id: v.number, id: '123', format: 'json'

      response.body.should == '{}'
    end
  end

  describe '#index' do
    it 'should redirect' do
      gem = Factory.create :rubygem
      v = Factory.create :version, rubygem_id: gem.id
      get :index, rubygem_id: gem.name, version_id: v.number
      response.should be_redirect
    end

    it 'should not die if the gem doesn\'t exist' do
      get :index, rubygem_id: '1', version_id: '1'
      response.should be_redirect
    end
  end
end
