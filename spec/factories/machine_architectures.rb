Factory.sequence :machine_architecture_name do |n|
  "#{n.ordinalize} machine architecture"
end

Factory.define :machine_architecture do |f|
  f.name { Factory.next :machine_architecture_name }
end
