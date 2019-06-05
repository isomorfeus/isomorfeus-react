require_relative 'app_loader'
require_relative 'owl_init'



class TestAppApp < Roda
  include OpalWebpackLoader::ViewHelper
  include Isomorfeus::ReactViewHelper

  plugin :public, root: 'public'

  def page_content(location)
    <<~HTML
      <html>
        <head>
          <title>Welcome to TestAppApp</title>
          #{owl_script_tag 'application.js'}
        </head>
        <body>
          #{mount_component('TestAppApp', location: location)}
        </body>
      </html>
    HTML
  end

  route do |r|
    r.root do
      page_content('/')
    end

    r.public

    r.get 'favicon.ico' do
      r.public
    end

    r.get 'ssr' do
      <<~HTML
      <html>
        <head>
          <title>Welcome to TestAppApp</title>
        </head>
        <body>
          #{mount_component('TestAppApp', location: env['REQUEST_PATH'])}
        </body>
      </html>
      HTML
    end

    r.get do
      page_content(env['REQUEST_PATH'])
    end
  end
end
