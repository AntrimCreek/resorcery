# Resorcery

Resorcery is a gem that lets you quickly create RESTful resource controllers for your Rails application.
Think admin interfaces, dashboards, etc.

Resorcery controllers are plain old Rails controllers, and any controller can inherit the functionality of a Resorcery
controller. You can use Resorcery's features as much, or as little, as you like.

## Getting started

### Installation

To install `resorcery`, add the following line to your application's Gemfile:

```ruby
gem 'resorcery', github: 'antrimcreek/resorcery'
```

Next, run the following command to install the gem:

```bash
rails g resorcery:install
```

### Generate a controller

This will generate a controller for the model you specify, and add a route to it in `config/routes.rb`.

```bash
rails g resorcery:controller <model>
```

or you can generate a controller for multiple models at once:

```bash
rails g resorcery:controller <model1> <model2> <model3>
```

## Generating views

You can generate view files to customize using any of the following generators.

### Generate views for a controller:

This will generate the `index.html.erb`, `show.html.erb`, and `form.html.erb` views that will override the standard
template files. These files follow the same naming convention as standard view files, with the exception that a single
`form.html.erb` file may be used in lieu of `new.html.erb` and `edit.html.erb`. However, `new.html.erb` and
`edit.html.erb` files will take precedence over `form.html.erb` if you wish to use those instead.

```bash
rails g resorcery:views <resource>
```

The `<resource>` argument can be in any understandable format, e.g. `post`, `Post`, `posts`, `PostsController`, etc.

### Generate view templates for all controllers:

This will generate the `index.html.erb`, `show.html.erb`, and `form.html.erb` views in the `app/views/resorcery`
directory that will be used site-wide. As with views for individual controllers, you may use separate `new` and `edit`
templates in lieu of a shared `form`.

```bash
rails g resorcery:views --global
```

### Generate view components

Resorcery uses the [ViewComponent](https://viewcomponent.org) gem to generate reusable view components.
To generate all components used by the standard view templates in the `app/components/resorcery` directory, run:

```bash
rails g resorcery:components
```

### Pagination

Resorcery uses the [Kaminari](https://github.com/kaminari/kaminari) gem for pagination.

To generate Kaminari view partials in the `app/views/kaminari/resorcery` directory, run:

```bash
rails g resorcery:pagination
```

## Customizing content

In views, resources may be accessed by either the `@resource(s)` or `@<model>(s)` instance variables. For example, if
you have a `User` model, you may access the collection in the `index` view as either `@resources` or `@users`, or you
may access the record as either `@resource` or `@user` in the `show` and `form` views.

### Display Name

Models have a `display_name` method that is used to display the name of the model in the page header. You can specify
the value by either overriding the `display_name` method in the model, adding a `display_name` column to the model's
table, or by setting a `display_name_key` for the model.

Any of the following will use the user's `email` attribute as the `display_name`:

```ruby
class User < ApplicationRecord
  self.display_name_key = :email

  def self.display_name_key
    :email
  end

  def display_name
    email
  end
end
```

If a `display_name` is not explicitly defined, other common attributes such as `name` or `title` will be used instead.

Page and header titles show the `display_name` value by default.

Page titles may be customized by either setting the `@page_title` instance variable in the controller, or by calling
`content_for(:page_title) { <Custom title> }` in the view. Examples:

Similarly, headers titles in the page header may be customized by using
`content_for(:header_title) { <Custom title> }`

## Customizing controllers

You can turn any controller into a Resorcery controller by calling `resorcery <model>` in the controller class.
This will enable all of the default behaviors.

Controllers are plain old Rails controllers. You can override any of the methods provided by Resorcery (such as `index`
or `create`) or augement those methods by calling `super` in your custom method.

### Controller options

Options can be used to adjust how content is rendered in the standard view templates. All options are optional, as
omitting the options block will use the default settings.

```ruby
resorcery User do
  formats :html, :json
  list_keys :id, :email, :name, :created_at, :updated_at
  list_options id: { label: "User ID" }, name: { sort_key: "family_name" }
  detail_keys :id, :email, :given_name, :family_name, :created_at, :updated_at
  form_keys :email, :name
  form_options name: { label: "Full Name", as: :string }
  default_sorts "created_at desc"
  search_inputs id_eq: { label: "ID", as: :number }, email_cont: { label: "Email", as: :string }
end
```

#### `formats`

Available formats are `:html`, `:turbo_stream`, and `:json`. The formats for a controller can be retrieved via the
`resource_formats` method. The default formats are `:html` and `:turbo_stream`.

#### `list_keys`

These are the keys that will be displayed in the table on the `#index` view. The default keys are `:id`, `:display_name`,
`:created_at`, and `:updated_at`.

#### `list_options`

A hash of options for each key in the list.

- `sortable`: `true` or `false`. The default is `true` for all keys that correspond to columns in the model's table.
- `sort_key`: The name of the column to use for sorting. The default is the key name.
- `label`: The label to use for the column header. The default is the key name, titleized.
- `link`: `true` or `false`. Whether to use this cell to link to the records `show` page. The default is `true` for
  `:id` and `:display_name` keys.

The result of `list_keys` and `list_options` can by read via the `resource_list_columns` method.

#### `detail_keys`

The attributes that will be shown on the `#show` view. The default keys are all columns in the model's table,
ActiveStorage attachments, and any `belongs_to` or `has_and_belongs_to_many` associations.

#### `form_keys`

The attributes that will be shown on the `#new` and `#edit` views. The default keys are all columns in the model's
table, minus `:id`, `:created_at`, and `:updated_at`.

#### `form_options`

A hash of options for each key in the form. In addition to the options specified below, any options that are valid for
the corresponding Rails form helper may also be used.

- `as`: The type of input to use for the field. Accepted values are `:boolean`, `:string`, `:email`, `:password`,
  `:select`, `:belongs_to`, `:has_many`, `:has_and_belongs_to_many`, `:date`, `:datetime`, `:time`, `:integer`,
  `:float`, `:decimal`, `:text`, and `:file`
- `collection`: (`select` menus only) A collection of options to use for `:select` inputs.
- `:input_html`, `:wrapper_html`, `:label_html`, `:hint_html`, and `:error_html`: HTML options (`class`, `placeholder`,
  `data-*` attributes, etc.) to pass to the corresponding element. For example, `wrapper_html: { class: "my-class" }`
  will add the `my-class` class to the wrapper element.

The result of `form_keys` and `form_options` can by read via the `resource_form_fields` method.

#### `default_sorts`

The default sort order for the `#index` view. The default is `created_at desc`.

#### `search_inputs`

A hash of inputs to use for the search form. Each key is a Ransack search predicate, and the value is a hash of options.

You may hide the search fields completely by setting `search_inputs false`.

## Contributing

Contribution directions go here.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
