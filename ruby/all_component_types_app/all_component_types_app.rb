require_relative 'app_loader'
require_relative 'owl_init'
require_relative 'iodine_config'


class AllComponentTypesApp < Roda
  include OpalWebpackLoader::ViewHelper
  include Isomorfeus::ReactViewHelper

  plugin :public, root: 'public'

  def page_content(env, location)
    <<~HTML
      <html>
        <head>
          <title>Welcome to AllComponentTypesApp</title>
          #{owl_script_tag 'application.js'}
        </head>
        <body>
          #{mount_component('AllComponentTypesApp', location_host: env['HTTP_HOST'], location: location)}
        </body>
      </html>
    HTML
  end

  route do |r|
    r.root do
      page_content(env, '/')
    end

    r.public

    r.get 'favicon.ico' do
      r.public
    end

    r.get do
      content = page_content(env, env['PATH_INFO'])
      response.status = ssr_response_status
      content
    end
  end
end
