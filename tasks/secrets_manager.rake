# frozen_string_literal: true
prompt = TTY::Prompt.new

namespace :secrets_manager do
  desc 'Perform Terraform actions'
  task :default do
    # Prompt for the environment (staging or production)
    environment = prompt.select('Select the environment:', %w[staging production])

    # Prompt for the secret name using a list prompt
    secret_name_suffix = prompt.select('Select the secret name suffix:',
                                       ['/secret/db/username', '/secret/db/password', '/secret/rails_master_key'])

    # Construct the full secret name
    secret_name = "/#{environment}#{secret_name_suffix}"

    # Prompt for the secret value
    secret_value = if ['/secret/db/password',
                       '/secret/rails_master_key'].include?(secret_name_suffix)
                     prompt.mask('Enter the secret value:')
                   else
                     prompt.ask('Enter the secret value:')
                   end

    # Create an AWS Secrets Manager client
    secrets_manager = Aws::SecretsManager::Client.new

    begin
      # Attempt to create or update the secret
      secrets_manager.create_secret({
                                      name: secret_name,
                                      secret_string: secret_value
                                    })

      puts "Secret #{secret_name} created or updated successfully."
    rescue Aws::SecretsManager::Errors::ResourceExistsException
      puts "Secret #{secret_name} already exists. Updating..."
      # If the secret already exists, update it
      secrets_manager.put_secret_value({
                                         secret_id: secret_name,
                                         secret_string: secret_value
                                       })

      puts "Secret #{secret_name} updated successfully."
    rescue StandardError => e
      puts "Error: #{e.message}"
    end
  end
end

task secrets_manager: 'secrets_manager:default'
