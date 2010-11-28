Factory.sequence :rubygem_name do |n|
  "ruby#{n.ordinalize}gem"
end

Factory.define :rubygem do |f|
  f.name { Factory.next :rubygem_name }
end
  
