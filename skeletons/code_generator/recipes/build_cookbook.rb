# frozen_string_literal: true

context = ChefDK::Generator.context
delivery_project_dir = context.delivery_project_dir
pipeline = context.pipeline
dot_delivery_dir = File.join(delivery_project_dir, '.delivery')
config_json = File.join(dot_delivery_dir, 'config.json')
project_toml = File.join(dot_delivery_dir, 'project.toml')

generator_desc('Ensuring delivery configuration')

directory dot_delivery_dir

# Adding a new prototype file for delivery-cli local commands
cookbook_file project_toml do
  source 'delivery-project.toml'
  not_if { File.exist?(project_toml) }
end

generator_desc('Ensuring correct delivery build cookbook content')

# Construct git history as if we did all the work in a feature branch which we
# merged into master at the end, which looks like this:
#
# ```
# git log --graph --oneline
# *   5fec5bd Merge branch 'add-delivery-configuration'
# |\
# | * 967bb9f Add generated delivery build cookbook
# | * 1558e0a Add generated delivery configuration
# |/
# * db22790 Add generated cookbook content
# ```
#
if context.have_git && context.delivery_project_git_initialized && !context.skip_git_init

  generator_desc('Adding delivery configuration to feature branch')

  execute('git-create-feature-branch') do
    command('git checkout -t -b add-delivery-configuration')
    cwd delivery_project_dir
    not_if { shell_out('git branch', cwd: delivery_project_dir).stdout.match(/add-delivery-configuration/) }
  end

  # Adding the new prototype file to the feature branch
  # so it gets checked in with the delivery config commit
  execute('git-add-delivery-project-toml') do
    command('git add .delivery/project.toml')
    cwd delivery_project_dir
    only_if { shell_out('git status -u --porcelain', cwd: delivery_project_dir).stdout.match(%r{.delivery/project.toml}) }
  end

  execute('git-commit-delivery-config') do
    command('git commit -m "Add generated delivery configuration"')
    cwd delivery_project_dir
    only_if { shell_out('git status -u --porcelain', cwd: delivery_project_dir).stdout.match(/config\.json|project\.toml/) }
  end

  execute("git-return-to-#{pipeline}-branch") do
    command("git checkout #{pipeline}")
    cwd delivery_project_dir
  end

  generator_desc('Merging delivery content feature branch to master')

  execute('git-merge-delivery-config-branch') do
    command('git merge --no-ff add-delivery-configuration')
    cwd delivery_project_dir
  end

  execute('git-remove-delivery-config-branch') do
    command('git branch -D add-delivery-configuration')
    cwd delivery_project_dir
  end
end
