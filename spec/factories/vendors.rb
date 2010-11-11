Factory.sequence :vendor_name do |n|
  "#{n.ordinalize} vendor"
end

Factory.define :vendor do |f|
  f.name { Factory.next :vendor_name }
end

