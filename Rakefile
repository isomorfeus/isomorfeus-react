require 'bundler/cli'
require 'bundler/cli/exec'

task default: %w[ruby_specs]

task :ruby_specs => [:ruby_react_specs, :ruby_preact_specs]

task :ruby_react_specs do
  puts <<~'ASCII'
  _____                 _   
 |  __ \               | |  
 | |__) |___  __ _  ___| |_ 
 |  _  // _ \/ _` |/ __| __|
 | | \ \  __/ (_| | (__| |_ 
 |_|  \_\___|\__,_|\___|\__|

  ASCII
  pwd = Dir.pwd
  Dir.chdir('ruby/test_app_react')
  system('rm -rf spec')
  system('cp -R ../common_spec spec')
  system('rm -f public/assets/*')
  system('yarn install')
  system('env -i PATH=$PATH bundle install')
  result = system('env -i PATH=$PATH THREADS=4 WORKERS=1 bundle exec rspec')
  Dir.chdir(pwd)
  raise "Ruby tests failed!" unless result
end

task :ruby_nervjs_specs do
  puts <<~'ASCII'
  _   _                 _     
 | \ | |               (_)    
 |  \| | ___ _ ____   ___ ___ 
 | . ` |/ _ \ '__\ \ / / / __|
 | |\  |  __/ |   \ V /| \__ \
 |_| \_|\___|_|    \_/ | |___/
                      _/ |    
                     |__/
  ASCII
  pwd = Dir.pwd
  Dir.chdir('ruby/test_app_nervjs')
  system('rm -rf spec')
  system('cp -R ../common_spec spec')
  system('rm -f public/assets/*')
  system('yarn install')
  system('env -i PATH=$PATH bundle install')
  result = system('env -i PATH=$PATH THREADS=4 WORKERS=1 bundle exec rspec')
  Dir.chdir(pwd)
  raise "Ruby tests failed!" unless result
end

task :ruby_preact_specs do
  puts <<~'ASCII'
  _____                     _   
 |  __ \                   | |  
 | |__) | __ ___  __ _  ___| |_ 
 |  ___/ '__/ _ \/ _` |/ __| __|
 | |   | | |  __/ (_| | (__| |_ 
 |_|   |_|  \___|\__,_|\___|\__|

  ASCII
  pwd = Dir.pwd
  Dir.chdir('ruby/test_app_preact')
  system('rm -rf spec')
  system('cp -R ../common_spec spec')
  system('rm -f public/assets/*')
  system('yarn install')
  system('env -i PATH=$PATH bundle install')
  result = system('env -i PATH=$PATH THREADS=4 WORKERS=1 bundle exec rspec')
  Dir.chdir(pwd)
  raise "Ruby tests failed!" unless result
end
