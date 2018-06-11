# frozen_string_literal: true

context = ChefDK::Generator.context
ChefDK::Generator.add_attr_to_context(:resource_name, context.cookbook_name.gsub('-', '_'))
cookbook_dir = File.join(context.cookbook_root, context.cookbook_name)

silence_chef_formatter unless context.verbose

generator_desc('Ensuring correct cookbook file content')

# cookbook root dir
directory cookbook_dir

# metadata.rb
spdx_license =  case context.license
                when 'apachev2'
                  'Apache-2.0'
                when 'mit'
                  'MIT'
                when 'gplv2'
                  'GPL-2.0'
                when 'gplv3'
                  'GPL-3.0'
                else
                  'All Rights Reserved'
                end

template "#{cookbook_dir}/metadata.rb" do
  helpers(ChefDK::Generator::TemplateHelper)
  variables(
    spdx_license: spdx_license
  )
  action :create_if_missing
end

# README
template "#{cookbook_dir}/README.md" do
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

# Code of Conduct
template "#{cookbook_dir}/CODE_OF_CONDUCT.md" do
  helpers(ChefDK::Generator::TemplateHelper)
end

# Contributing
template "#{cookbook_dir}/CONTRIBUTING.md" do
  helpers(ChefDK::Generator::TemplateHelper)
end

# Testing
template "#{cookbook_dir}/TESTING.md" do
  helpers(ChefDK::Generator::TemplateHelper)
end

# CHANGELOG
template "#{cookbook_dir}/CHANGELOG.md" do
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

# Gemfile
template "#{cookbook_dir}/Gemfile" do
  helpers(ChefDK::Generator::TemplateHelper)
end

# chefignore
cookbook_file "#{cookbook_dir}/chefignore"

if context.use_berkshelf

  # Berks
  template "#{cookbook_dir}/Berksfile" do
    helpers(ChefDK::Generator::TemplateHelper)
    action :create_if_missing
  end
else

  # Policyfile
  template "#{cookbook_dir}/Policyfile.rb" do
    source 'Policyfile.rb.erb'
    helpers(ChefDK::Generator::TemplateHelper)
  end

end

# TravisCI
if context.use_travis
  template "#{cookbook_dir}/.travis.yml" do
    source 'travis.yml.erb'
    helpers(ChefDK::Generator::TemplateHelper)
  end

  directory "#{cookbook_dir}/.travis"

  file "#{cookbook_dir}/.travis/id_rsa" do
    content 'Replace this file with a GitHub deploy ' \
            "key for #{context.github_user}"
  end

  file "#{cookbook_dir}/.travis/client.pem" do
    content 'Replace this file with a Supermarket key ' \
            "for #{context.supermarket_user}"
  end
end

# LICENSE
template "#{cookbook_dir}/LICENSE" do
  helpers(ChefDK::Generator::TemplateHelper)
  source "LICENSE.#{context.license}.erb"
  action :create_if_missing
end

# Inspec
directory "#{cookbook_dir}/test/integration/default" do
  recursive true
end

template "#{cookbook_dir}/test/integration/default/default_test.rb" do
  source 'inspec_default_test.rb.erb'
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

# Chefspec
directory "#{cookbook_dir}/spec/unit/recipes" do
  recursive true
end

cookbook_file "#{cookbook_dir}/spec/spec_helper.rb" do
  if context.use_berkshelf
    source 'spec_helper.rb'
  else
    source 'spec_helper_policyfile.rb'
  end

  action :create_if_missing
end

template "#{cookbook_dir}/spec/unit/recipes/default_spec.rb" do
  source 'recipe_spec.rb.erb'
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

cookbook_file "#{cookbook_dir}/spec/dependencies_spec.rb" do
  action :create_if_missing
  only_if { context.use_berkshelf }
end

cookbook_file "#{cookbook_dir}/spec/unit/resources.rb" do
  action :create_if_missing
end

directory "#{cookbook_dir}/spec/unit/resources" do
  recursive true
end

template "#{cookbook_dir}/spec/unit/resources/#{context.resource_name}_spec.rb" do
  source 'resource_spec.rb.erb'
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

# Recipes

directory "#{cookbook_dir}/recipes"

template "#{cookbook_dir}/recipes/default.rb" do
  source 'recipe.rb.erb'
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

# Resources

directory "#{cookbook_dir}/libraries/resource" do
  recursive true
end

template "#{cookbook_dir}/libraries/resource/#{context.resource_name}.rb" do
  source 'resource.rb.erb'
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

# git
if context.have_git
  unless context.skip_git_init

    generator_desc('Committing cookbook files to git')

    execute('initialize-git') do
      command('git init .')
      cwd cookbook_dir
    end

  end

  template "#{cookbook_dir}/.gitignore" do
    source 'cookbook/gitignore.erb'
    helpers(ChefDK::Generator::TemplateHelper)
  end

  unless context.skip_git_init

    execute('git-add-new-files') do
      command('git add .')
      cwd cookbook_dir
    end

    execute('git-commit-new-files') do
      command('git commit -m "Add generated cookbook content"')
      cwd cookbook_dir
    end
  end
end

include_recipe '::build_cookbook' if context.enable_delivery
