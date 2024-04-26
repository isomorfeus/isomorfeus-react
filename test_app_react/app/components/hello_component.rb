class PropTest
  extend React::Component::Props::Declaration

  prop :email, validate.String.matches(/.+@.+/).max_length(64)
  prop :name, validate.String.matches(/T.+/).max_length(12)
end

class HelloComponent < React::Component::Base
  styles do
    { test: { color: 'red' }}
  end

  ref :form

  def validate_form
    ruby_ref(:form).current.JS.validateForm()
  end

  render do
    DIV 'Rendered!!'
    Formik.Formik(initial_values: { email: 'test@test', name: 'Test Test' }.to_n, on_submit: :incr) do
      Formik.Form do
        Formik.Field(type: :email, name: :email, validate: PropTest.validate_prop_function(:email))
        Formik.ErrorMessage(name: :email, component: :div)
        Formik.Field(type: :text, name: :name, validate: PropTest.validate_prop_function(:name))
        Formik.ErrorMessage(name: :name, component: :div)
        BUTTON(type: "submit") { 'Submit' }
      end
    end
    Formik.Formik(inner_ref: ref(:form), initial_values: { email: 'test@test', name: 'Test Test' }.to_n, validate: PropTest.validate_function,
                  on_submit: :validate_form) do
      Formik.Form do
        Formik.Field(type: :email, name: :email)
        Formik.ErrorMessage(name: :email, component: :div)
        Formik.Field(type: :text, name: :name)
        Formik.ErrorMessage(name: :name, component: :div)
        BUTTON(type: :submit) { 'validate' }
      end
    end
    # keep, was a BUG: component resolution
    YetAnother::Switch()
    DIV(on_click: method_ref(:incr, 'hello')) { "incr b_value" }
    NavigationLinks()
  end
end
