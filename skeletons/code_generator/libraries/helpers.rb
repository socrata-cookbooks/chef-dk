# frozen_string_literal: true

{
  copyright_holder: 'Socrata, Inc.',
  email: 'sysadmin@socrata.com',
  use_berkshelf: true
}.each do |k, v|
  ChefDK::Generator.add_attr_to_context(k, v)
end
