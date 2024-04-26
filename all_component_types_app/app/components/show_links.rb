class ShowLinks < React::Component::Base
  render do
    H2 { 'Functionality' }
    DIV do
      H3 { 'React::FunctionComponent, Props:' }
      Link(to: '/fun_fun/10') { 'Render 10 Components' }
    end
    DIV do
      H3 { 'React::Component, Props, State:' }
      Link(to: '/com_fun/10') { 'Render 10 Components'  }
    end
    DIV do
      H3 { 'Javascript Component, Props:' }
      Link(to: '/js_fun/10') { 'Render 10 Components'  }
    end
    DIV do
      H3 { 'Everything together:' }
      Link(to: '/all_the_fun/1') { 'Render all Component types'  }
    end
    H2 { 'Performance' }
    DIV { 'For example:' }
    DIV { '~ 1000 nodes -> most sites' }
    DIV { '~ 3000 nodes -> amazon' }
    DIV { '~ 10000 nodes -> youtube, twitter' }
    DIV do
      H3 { 'React::FunctionComponent, Props:' }
      Link(to: '/fun_run/1000') { 'Render 1000 nodes' }
      SPAN { ' | ' }
      Link(to: '/fun_run/3000') { 'Render 3000 nodes' }
      SPAN { ' | ' }
      Link(to: '/fun_run/10000') { 'Render 10000 nodes' }
    end
    DIV do
      H3 { 'React::Component, Props, State:' }
      Link(to: '/com_run/1000') { 'Render 1000 nodes' }
      SPAN { ' | ' }
      Link(to: '/com_run/3000') { 'Render 3000 nodes' }
      SPAN { ' | ' }
      Link(to: '/com_run/10000') { 'Render 10000 nodes' }
    end
    DIV do
      H3 { 'Javascript Component, Props:' }
      Link(to: '/js_run/1000') { 'Render 1000 nodes' }
      SPAN { ' | ' }
      Link(to: '/js_run/3000') { 'Render 3000 nodes' }
      SPAN { ' | ' }
      Link(to: '/js_run/10000') { 'Render 10000 nodes' }
    end
  end
end
