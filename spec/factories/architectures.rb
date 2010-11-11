Factory.sequence :architecture_name do |n|
  "#{n.ordinalize} architecture"
end

Factory.define :architecture do |f|
  f.name { Factory.next :architecture_name }
end
  
