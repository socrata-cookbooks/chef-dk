# frozen_string_literal: true

{
  copyright_holder: 'Socrata, Inc.',
  email: 'sysadmin@socrata.com',
  github_user: 'socrata-shared',
  github_org: 'socrata-cookbooks',
  supermarket_user: 'socrata',
  use_berkshelf: true
}.each do |k, v|
  ChefDK::Generator.add_attr_to_context(k, v)
end

ChefDK::Generator.add_attr_to_context(
  :use_travis,
  ChefDK::Generator.context.license != 'all_rights'
)
