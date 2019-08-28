class PropTest
  extend LucidPropDeclaration::Mixin

  prop :email, validate.String.matches(/.+@.+/).max_length(64)
  prop :name, validate.String.matches(/T.+/).max_length(12)
end

class HelloComponent < LucidMaterial::Component::Base
  class_store.a_value = 'component class store works'
  store.a_value = 'component store works'
  app_store.a_value = 'application store works'

  styles do
    { test: { color: 'red' }}
  end

  ref :form

  event_handler :validate_form do
    ruby_ref(:form).current.JS.validateForm()
  end

  render do
    DIV 'Rendered!!'
    DIV "#{class_store.a_value}"
    DIV "#{store.a_value}"
    DIV(class_name: styles.test){ "#{app_store.a_value}" }
    Formik.Formik(initial_values: { email: 'test@test', name: 'Test Test' }.to_n) do
      Formik.Form do
        Formik.Field(type: :email, name: :email, validate: PropTest.validate_prop_function(:email))
        Formik.ErrorMessage(name: :email, component: :div)
        Formik.Field(type: :text, name: :name, validate: PropTest.validate_prop_function(:name))
        Formik.ErrorMessage(name: :name, component: :div)
        BUTTON(type: "submit") { 'Submit' }
      end
    end
    Formik.Formik(ref: ref(:form), initial_values: { email: 'test@test', name: 'Test Test' }.to_n, validate: PropTest.validate_function) do
      Formik.Form do
        Formik.Field(type: :email, name: :email)
        Formik.ErrorMessage(name: :email, component: :div)
        Formik.Field(type: :text, name: :name)
        Formik.ErrorMessage(name: :name, component: :div)
        BUTTON(type: :submit, on_submit: :validate_form) { 'validate' }
      end
    end
    NavigationLinks()
  end
end