require 'bundler'
require 'bundler/cli'
require 'bundler/cli/exec'

require_relative 'ruby/lib/react/version'

task default: %w[ruby_react_specs]

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
  system('rm -f Gemfile.lock')
  system('rm -rf spec')
  system('cp -R ../common_spec spec')
  system('rm -f public/assets/*')
  system('yarn install')
  Bundler.with_original_env do
    system('bundle install')
    system('THREADS=4 WORKERS=1 bundle exec rspec')
  end
  Dir.chdir(pwd)
end

task :push_ruby_packages do
  Rake::Task['push_ruby_packages_to_rubygems'].invoke
  # Rake::Task['push_ruby_packages_to_isomorfeus'].invoke
  Rake::Task['push_ruby_packages_to_github'].invoke
end

task :push_ruby_packages_to_rubygems do
  system("gem push ruby/isomorfeus-react-#{React::VERSION}.gem")
end

task :push_ruby_packages_to_github do
  system("gem push --key github --host https://rubygems.pkg.github.com/isomorfeus ruby/isomorfeus-react-#{React::VERSION}.gem")
end

task :push_ruby_packages_to_isomorfeus do
  Bundler.with_original_env do
    system("scp ruby/isomorfeus-react-#{React::VERSION}.gem iso:~/gems/")
    system("ssh iso \"bash -l -c 'gem inabox gems/isomorfeus-react-#{React::VERSION}.gem --host http://localhost:5555/'\"")
  end
end
