require_relative 'app_loader'
require 'opal/rack_handler'

class TestAppApp < Roda
  include React::ViewHelper

  use Opal::RackHandler, {
    mount: '/opal',
    hot_updates: true,
    hot_ruby: "::React.force_render"
  }

  plugin :public, root: 'public'

  def page_content(host, location)
    rendered_tree = mount_component('TestAppApp', { location_host: host, location: location }, 'application_ssr.js')
    <<~HTML
      <html>
        <head>
          <title>Welcome to TestAppApp</title>
          <script src="/assets/application.js"></script>
          <script src="/opal/react_loader.js"></script>
        </head>
        <body>
          #{rendered_tree}
          <div id="test_anchor"></div>
        </body>
      </html>
    HTML
  end

  route do |r|
    r.root do
      page_content(env['HTTP_HOST'], '/')
    end

    r.public

    r.get 'favicon.ico' do
      r.public
    end

    r.get 'ssr' do
      rendered_tree = mount_component('TestAppApp', { location_host: env['HTTP_HOST'],  location: env['PATH_INFO'] }, 'application_ssr.js')
      content = <<~HTML
      <html>
        <head>
          <title>Welcome to TestAppApp</title>
        </head>
        <body>
          #{rendered_tree}
          <div id="test_anchor"></div>
        </body>
      </html>
      HTML
      response.status = ssr_response_status
      content
    end

    r.get do
      content = page_content(env['HTTP_HOST'], env['PATH_INFO'])
      response.status = ssr_response_status
      content
    end
  end
end
