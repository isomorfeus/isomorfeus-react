### Props

In ruby props are underscored: `className -> class_name`. The conversion for React is done automatically.
Within a component props can be accessed using `props`:
```ruby
class MyComponent < React::Component::Base
  render do
    DIV { props.text }
  end
end
```
Props are passed as arguments to the component:
```ruby
class MyOtherComponent < React::Component::Base
  render do
    MyComponent(text: 'some other text')
  end
end
```

### Prop Declaration
#### Using options hash style
Props can be declared and type checked and a default value can be given:
```ruby
class MyComponent < React::Component::Base
  prop :text, class: String # a required prop of class String, class must match exactly
  prop :maybe_text, class: String, allow_nil: true # a required prop of class String, class must match exactly but a nil value is also ok.
  prop :other, is_a: Enumerable # a required prop, which can be a Array for example, but at least must be a Enumerable
  prop :cool, default: 'yet some more text' # a optional prop with a default value
  prop :even_cooler, class: String, required: false # a optional prop, which when given, must be of class String
  prop :super # a required prop of any type
  
  render do
    DIV { props.text }
  end
end
```
#### Using validate method style
Props can be declared and type checked and a default value can be given using a validate method chain::
```ruby
class MyComponent < React::Component::Base
  prop :text, validate.String # a required prop of class String, class must match exactly
  prop :other, validate.Enumerable # a required prop, which can be a Array for example, but at least must be a Enumerable
  prop :cool, validate.default('yet some more text') # a optional prop with a default value
  prop :even_cooler, validate.String.optional # a optional prop, which when given, must be of class String
  prop :super # a required prop of any type
  
  render do
    DIV { props.text }
  end
end
```
More complex variations are possible and can be expressed in a concise way:
```ruby
class MyComponent < React::Component::Base
  prop :float, validate.Float.cast.default(1.0).min(0.5).and.max(1.5)
  prop :text, validate.String.matches(/(a|b|c).*/).length(5)
  
  render do
    DIV { props.float }
  end
end
```

A validate method chain must start with the `validate` method.

#### Supported types
Checked for exact class:
- Array
- Float
- Hash
- Integer
- String
- Boolean (checked for TrueClass or FalseClass)

Checked for superclass or module containing:
- Enumerable

Examples:
```ruby
prop :beer, validate.Float
prop :carpet, validate.Float
```

#### Other types
Any other type can be supported with the following methods:
- `is_a(class)` checks for superclass or module containing class: `prop :some, validate.is_a(Rabbit)`
- `exact_class(class)`, checks for exact class: `prop :car, validate.exact_class(MercedesBenzSClass)`

Examples:
```ruby
prop :beer, validate.is_a(Liquid)
prop :carpet, validate.exact_class(Carpet)
```

#### validate method chain methods
- `cast` Tries to cast the value to any of the supported types above before validation: `prop :a_guy, validate.Integer.cast`
- `default(value)` Provide a default value, makes prop optional: `prop :food, validate.default('vegetarian')`
- `ensure(value)` If the given value is nil, change it to value: `prop :text, validate.String.ensure('')`
- `greater_than(value)`, `gt(value)` Checks value of numeric types: `prop :val, validate.Integer.greater_than(1)`
- `keys(*keys)` checks if a Hash contains the given keys: `prop :display, validate.Hash.keys(:size, :color)`
- `length(l)`, `size(l)` checks length of String, Enumarable, Array and Hash: `prop :list, validate.Enumarable.length(5)`
- `less_than(value)`, `lt(value)` Checks value of numeric types: `prop :val, validate.Integer.less_than(1)`
- `matches(reg_exp)`, matches a String against a regular expression: `prop :rope, validate.String.matches(/(a|b).*/)`
- `max(v)` checks numeric types: `prop :array, validate.Integer.max(5)`
- `max_size(l)`, `max_length(l)` checks max length of enumerable types or string: `prop :array, validate.Array.max_size(5)`
- `min(v)` checks numeric types: `prop :array, validate.Integer.min(5)`
- `min_size(l)`, `min_length(l)` checks min length of enumerable types or string: `prop :array, validate.Array.min_size(5)`
- `negative`, checks if numeric value is negative: `prop :numer, validate.Integer.negative`
- `optional`, declares prop as optional: `prop :numer, validate.Integer.optional`
- `positive`, checks if numeric value is positive: `prop :numer, validate.Integer.positive`
- `required`, declares prop as required: `prop :numer, validate.Integer.required`

- sugar methods
    - `and`
    - `is`
    - `has`
    - `with`
    
These methods are helper methods to express more clearly in language.
Example: `prop :wine, validate.String.with.length(5).and.matches(/(a|b}.*/)`

#### validating props

Props can be validated by calling:
```ruby
MyClass.validate_props(props_hash)
```
or individually, a single prop:
```ruby
MyClass.validate_prop(prop_name, prop_value)
```

### Props Outside Components

The props as above are used within the isomorfeus framework for isomorfeus-data classes and isomorfeus-operation.
These props can be used in any class simple by extending the class, example:
```ruby
class MyClass
  extend LucidPropDeclaration::Mixin
```
This makes all of the above available.

### Props in Forms
Especially when using LucidNodes from isomorfeus-data, but also for any other class with props, its helpful to have the form
validate the input. The LucidPropsDeclaration::Mixin provides helper functions, that can be used with various react
form components to automatically do the validation. For validating all declared props, for example for a complete form:
```ruby
MyClass.validate_function
```
It returns a javascript function that can be called by the form component. `function(props_object)`


To validate a single prop for a specific form input:
```ruby
MyClass.validate_prop_function(prop_name)
```
It returns a javascript function, that can called by a form input component. `function(value)`

Example:
```ruby
class PropTest # just to show props, could be any LucidNode or LucidOperation or anything else that accepts props
  extend LucidPropDeclaration::Mixin

  prop :email, validate.String.matches(/.+@.+/).max_length(64)
  prop :name, validate.String.matches(/T.+/).max_length(12)
end

class HelloComponent < LucidMaterial::Component::Base
  render do
    Formik.Formik(initial_values: { email: 'test@test', name: 'Test Test' }.to_n) do
      Formik.Form do
        # here the PropTest.validate_prop_function(:email) returns a function that is used by formik for field level validation
        Formik.Field(type: :email, name: :email, validate: PropTest.validate_prop_function(:email))
        Formik.ErrorMessage(name: :email, component: :div)
        # here the PropTest.validate_prop_function(:name) returns a function that is used by formik for field level validation
        Formik.Field(type: :text, name: :name, validate: PropTest.validate_prop_function(:name))
        Formik.ErrorMessage(name: :name, component: :div)
        BUTTON(type: "submit") { 'Submit' }
      end
    end
  end
end
```


