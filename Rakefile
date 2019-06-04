require 'bundler/cli'
require 'bundler/cli/exec'

task default: %w[ruby_specs]

task :ruby_specs do
  pwd = Dir.pwd
  Dir.chdir('ruby/test_app')
  system('yarn install')
  system('env -i PATH=$PATH bundle install')
  system('env -i PATH=$PATH bundle exec rspec')
  Dir.chdir(pwd)
end
