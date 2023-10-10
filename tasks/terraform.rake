# frozen_string_literal: true

# lib/tasks/terraform.rake

prompt = TTY::Prompt.new

namespace :terraform do
  desc 'Perform Terraform actions'
  task :default do
    environment = prompt.select('Select the environment:', %w[staging production])
    action = prompt.select('Select the environment:', %w[init fmt validate plan apply destroy])
    sh "cd #{environment} && terraform #{action}"
  end
end

task terraform: 'terraform:default'
