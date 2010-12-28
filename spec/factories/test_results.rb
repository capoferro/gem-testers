Factory.define :test_result do |t|
  t.result true
  t.test_output 'This is the test output'
  t.version {|b| b.association(:version)}
  t.rubygem {|b| b.association(:rubygem)}
  t.operating_system 'Linux'
  t.architecture 'somearch'
  t.machine_architecture 'somemachinearch'
  t.vendor 'somevendor'
  t.ruby_version '3.0.0'
  t.platform 'someplatform'
end
