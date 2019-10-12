require 'bundler/cli'
require 'bundler/cli/exec'

task default: %w[ruby_specs]

task :ruby_specs => [:ruby_react_specs, :ruby_preact_specs, :ruby_nervjs_specs]

task :ruby_react_specs do
  pwd = Dir.pwd
  Dir.chdir('ruby/test_app')
  system('rm -f public/assets/*')
  system('yarn install')
  system('env -i PATH=$PATH bundle install')
  result = system('env -i PATH=$PATH THREADS=4 WORKERS=1 bundle exec rspec')
  Dir.chdir(pwd)
  raise "Ruby tests failed!" unless result
end

task :ruby_nervjs_specs do
  pwd = Dir.pwd
  Dir.chdir('ruby/test_app_nervjs')
  system('rm -f public/assets/*')
  system('yarn install')
  system('env -i PATH=$PATH bundle install')
  result = system('env -i PATH=$PATH THREADS=4 WORKERS=1 bundle exec rspec')
  Dir.chdir(pwd)
  raise "Ruby tests failed!" unless result
end

task :ruby_preact_specs do
  pwd = Dir.pwd
  Dir.chdir('ruby/test_app_preact')
  system('rm -f public/assets/*')
  system('yarn install')
  system('env -i PATH=$PATH bundle install')
  result = system('env -i PATH=$PATH THREADS=4 WORKERS=1 bundle exec rspec')
  Dir.chdir(pwd)
  raise "Ruby tests failed!" unless result
end
