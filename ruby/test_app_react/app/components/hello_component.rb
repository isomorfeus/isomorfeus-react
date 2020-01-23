class PropTest
  extend LucidPropDeclaration::Mixin

  prop :email, validate.String.matches(/.+@.+/).max_length(64)
  prop :name, validate.String.matches(/T.+/).max_length(12)
end

class MemoTest < LucidMaterial::Func::Base
  render do
    DIV "Memo"
    DIV app_store.a_value
    DIV "b: #{app_store.b_value}"
  end
end

class HelloComponent < LucidMaterial::Component::Base
  class_store.a_value = 'component class store works'
  store.a_value = 'component store works'
  app_store.a_value = 'application store works'
  app_store.b_value = 0

  styles do
    { test: { color: 'red' }}
  end

  ref :form

  def validate_form
    ruby_ref(:form).current.JS.validateForm()
  end

  def incr
    app_store.b_value = app_store.b_value + 1
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
    MemoTest()
    DIV(on_click: :incr) { "incr b_value" }
    NavigationLinks()
  end
end
