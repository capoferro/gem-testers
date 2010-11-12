Factory.sequence :rubygem_name do |n|
  "#{n.ordinalize} rubygem"
end

Factory.define :rubygem do |f|
  f.name { Factory.next :rubygem_name }
end
  
