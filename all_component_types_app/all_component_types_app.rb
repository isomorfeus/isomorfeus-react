require_relative 'app_loader'
require_relative 'iodine_config'

class AllComponentTypesApp < Roda
  include React::ViewHelper

  plugin :public, root: 'public'

  def page_content(env, location)
    <<~HTML
      <html>
        <head>
          <title>Welcome to AllComponentTypesApp</title>
        </head>
        <body>
          #{mount_component('AllComponentTypesApp', { location_host: env['HTTP_HOST'], location: location }, 'application_ssr.js')}
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
