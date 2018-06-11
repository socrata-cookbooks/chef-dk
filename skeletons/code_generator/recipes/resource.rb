# frozen_string_literal: true

context = ChefDK::Generator.context
ChefDK::Generator.add_attr_to_context(:resource_name, context.new_file_basename)
cookbook_dir = File.join(context.cookbook_root, context.cookbook_name)

resource_dir = File.join(cookbook_dir, 'libraries/resource')
resource_path = File.join(resource_dir, "#{context.new_file_basename}.rb")

spec_dir = File.join(cookbook_dir, 'spec/unit/resources')
spec_path = File.join(spec_dir, "#{context.new_file_basename}_spec.rb")

inspec_dir = File.join(cookbook_dir, 'test/integration/default')
inspec_path = File.join(inspec_dir, "#{context.new_file_basename}_test.rb")

# ChefSpec
directory spec_dir do
  recursive true
end

template spec_path do
  source 'resource_spec.rb.erb'
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

# Inspec

directory inspec_dir do
  recursive true
end

template inspec_path do
  source 'inspec_default_test.rb.erb'
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

# Resource

directory resource_dir do
  recursive true
end

template resource_path do
  source 'resource.rb.erb'
  helpers(ChefDK::Generator::TemplateHelper)
end
