require 'bundler'
require 'bundler/cli'
require 'bundler/cli/exec'
require 'fileutils'

require_relative 'ruby/lib/react/version'

task default: %w[specs]

task :specs do
  pwd = Dir.pwd
  Dir.chdir('test_app_react')
  FileUtils.rm_f('Gemfile.lock')
  FileUtils.rm_rf('spec')
  FileUtils.cp_r('../common_spec', 'spec')
  FileUtils.rm_rf('public/assets')
  system('yarn install')
  if Gem.win_platform?
    Bundler.with_original_env do
      system('bundle install')
      system('bundle exec rspec')
    end
  else
    Bundler.with_original_env do
      system('bundle install')
      system('THREADS=4 WORKERS=1 bundle exec rspec')
    end
  end
  Dir.chdir(pwd)
end

task :push_ruby_packages do
  Rake::Task['push_ruby_packages_to_rubygems'].invoke
end

task :push_ruby_packages_to_rubygems do
  system("gem push isomorfeus-react-#{React::VERSION}.gem")
end
