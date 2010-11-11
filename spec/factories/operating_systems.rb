Factory.sequence :operating_system_name do |n|
  "#{n.ordinalize} operating system"
end

Factory.define :operating_system do |f|
  f.name { Factory.next :operating_system_name }
end

