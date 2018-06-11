# frozen_string_literal: true

require 'mixlib/shellout'

{
  copyright_holder: 'Socrata, Inc.',
  email: 'sysadmin@socrata.com',
  github_user: 'socrata-shared',
  github_org: 'socrata-cookbooks',
  supermarket_user: 'socrata',
  maintainer_name: Mixlib::ShellOut.new('git config user.name').run_command
                                                               .stdout.strip,
  maintainer_email: Mixlib::ShellOut.new('git config user.email').run_command
                                                                 .stdout.strip,
  use_berkshelf: true
}.each do |k, v|
  ChefDK::Generator.add_attr_to_context(k, v)
end

ChefDK::Generator.add_attr_to_context(
  :use_travis,
  ChefDK::Generator.context.license != 'all_rights'
)
