require 'spec_helper'

describe TestResultsController do
  describe 'GET index.json' do
    it 'should respond to #index.json' do
      get :index, format: 'json'
      response.should be_success
      response.body.should == '{"pass_count":0,"fail_count":0,"test_results":[]}'
    end

    it 'should include total pass/fail counts with rubygems' do
      gem = Factory.create :rubygem, name: 'foo'
      v = Factory.create :version, number: '1.0.0', rubygem_id: gem.id
      Factory.create :test_result, rubygem_id: gem.id, version_id: v.id
      gem2 = Factory.create :rubygem, name: 'fooble'
      v2 = Factory.create :version, number: '1.0.0', rubygem_id: gem2.id
      Factory.create :test_result, rubygem_id: gem2.id, version_id: v2.id, result: false
      Factory.create :test_result, rubygem_id: gem2.id, version_id: v2.id

      get :index, format: 'json'
      response.body.should == {pass_count: 2, fail_count: 1, test_results: TestResult.order('created_at DESC').all.collect(&:short_attributes)}.to_json
    end
  end


  describe 'POST create' do
    describe 'with valid results' do
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
      
      it 'should create a result if the version # already exists' do
        g = Factory.create :rubygem, name: 'rubygems-test'
        Factory.create :version, number: '0.3.0', prerelease: false, rubygem: g
        
        post :create, {"results"=> <<RESULTS}
--- 
:arch: x86_64-darwin10.6.0
:vendor: apple
:os: darwin10.6.0
:machine_arch: x86_64
:name: rubygems-test
:version: 
  :release: 0.3.0
  :prerelease: 
:platform: ruby
:ruby_version: 1.9.2
:result: true
:test_output: |
  (in /Users/erikh/.rvm/gems/ruby-1.9.2-p136/gems/rubygems-test-0.3.0)
  Loaded suite -e
  Started  ../Users/erikh/.rvm/rubies/ruby-1.9.2-p136/lib/ruby/site_ruby/1.9.1/rubygems/specification.rb:725:in `to_yaml': YAML.quick_emit is deprecated

  Successfully uninstalled test-gem-0.0.0  ./Users/erikh/.rvm/rubies/ruby-1.9.2-p136/lib/ruby/site_ruby/1.9.1/rubygems/specification.rb:725:in `to_yaml': YAML.quick_emit is deprecated
  Successfully uninstalled test-gem-0.0.0
  ERROR:  Couldn't find rakefile -- this gem cannot be tested. Aborting.
  Successfully uninstalled test-gem-0.0.0
  ./Users/erikh/.rvm/rubies/ruby-1.9.2-p136/lib/ruby/site_ruby/1.9.1/rubygems/specification.rb:725:in `to_yaml': YAML.quick_emit is deprecated
  Successfully uninstalled test-gem-0.0.0
  .
  Finished in 0.758995 seconds.
  
  5 tests, 11 assertions, 0 failures, 0 errors, 0 skips
  Test run options: --seed 1201
RESULTS

        r = YAML::load response.body
        r[:success].should be_true
        r[:errors].empty?.should be_true
        
      end

      it 'should accept test results yaml and store it' do
        r = Factory.create(:rubygem, :name => 'methlab')
        n = Factory.create(:version, :rubygem_id => r.id, :number => '0.1.0')
        
        post :create, 'results' => @results_yaml

        expected_response = Response.new(rubygem_version_test_result_url(r.name,n.number,TestResult.order(:id).last.id))
        expected_response.success = true
        
        response.body.should == expected_response.to_yaml

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

      it 'should create the gem and version if the gem did not previously exist' do
        post :create, 'results' => @results_yaml

        (r = Rubygem.last).name.should == 'methlab' rescue fail 'Rubygem not created properly.'
        (v = Version.last).number.should == '0.1.0' rescue fail 'Version not created properly.'
        v.rubygem.id.should == r.id
        r.versions.size.should == 1
        r.versions.collect(&:id).include?(v.id).should be_true
      end
    end

    describe 'with invalid results' do

      it 'should report errors from creating the gem' do
        post :create, results: <<-YAML
--- 
:arch: x86_64-linux
:vendor: unknown
:os: linux
:machine_arch: x86_64
:name: 
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
        expected_response = Response.new
        expected_response.errors.add :'Name of the rubygem', 'is invalid'
        expected_response.success = false
        response.body.should == expected_response.to_yaml
      end

       it 'should report errors from creating the version' do
        post :create, results: <<-YAML
--- 
:arch: x86_64-linux
:vendor: unknown
:os: linux
:machine_arch: x86_64
:name: methlab
:version: 
:result: true
:test_output: |
  /home/josiah/.rvm/rubies/ruby-1.9.2-p0/bin/ruby -I"lib:lib" "/home/josiah/.rvm/rubies/ruby-1.9.2-p0/lib/ruby/1.9.1/rake/rake_test_loader.rb" "test/test_checks.rb" "test/test_integrate.rb" "test/test_inline.rb" "test/test_defaults.rb" 
  Loaded suite /home/josiah/.rvm/rubies/ruby-1.9.2-p0/lib/ruby/1.9.1/rake/rake_test_loader
  Started
  ............

YAML
        expected_response = Response.new
        expected_response.errors.add :'Version', 'can\'t be blank'
        expected_response.success = false
        response.body.should == expected_response.to_yaml
      end
      
      it 'should report errors from creating the test result' do
        post :create, results: <<-YAML
--- 
:arch: x86_64-linux
:vendor: unknown
:os: linux
:machine_arch: x86_64
:name: methlab
:version: 
  :prerelease: false
  :release: 0.1.0
:result: 
:test_output: |
  /home/josiah/.rvm/rubies/ruby-1.9.2-p0/bin/ruby -I"lib:lib" "/home/josiah/.rvm/rubies/ruby-1.9.2-p0/lib/ruby/1.9.1/rake/rake_test_loader.rb" "test/test_checks.rb" "test/test_integrate.rb" "test/test_inline.rb" "test/test_defaults.rb" 
  Loaded suite /home/josiah/.rvm/rubies/ruby-1.9.2-p0/lib/ruby/1.9.1/rake/rake_test_loader
  Started
  ............

YAML
        expected_response = Response.new
        expected_response.errors.add :'Result of the testresult',  'must be true or false'
        expected_response.success = false
        response.body.should == expected_response.to_yaml
      end

      it "should create a new version for a new gem" do
        r = Factory.create :rubygem
        v = Factory.create :version, rubygem: r

        post :create, results: <<-YAML
--- 
:arch: x86_64-linux
:vendor: unknown
:os: linux
:machine_arch: x86_64
:name: methlab
:version: 
  :prerelease: false
  :release: #{v.number}
:result: 
:test_output: |
  /home/josiah/.rvm/rubies/ruby-1.9.2-p0/bin/ruby -I"lib:lib" "/home/josiah/.rvm/rubies/ruby-1.9.2-p0/lib/ruby/1.9.1/rake/rake_test_loader.rb" "test/test_checks.rb" "test/test_integrate.rb" "test/test_inline.rb" "test/test_defaults.rb" 
  Loaded suite /home/josiah/.rvm/rubies/ruby-1.9.2-p0/lib/ruby/1.9.1/rake/rake_test_loader
  Started
  ............

YAML
        Version.all.select { |x| x.number == v.number }.count.should == 2
      end
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
