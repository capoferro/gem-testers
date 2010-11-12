Factory.sequence :version_number do |n|
  "#{n}.0.0.0"
end

Factory.define :version do |f|
  f.number { Factory.next :version_number }
  f.rubygem { |r| r.association(:rubygem) }
  f.prerelease false
end
  
