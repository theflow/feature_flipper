FeatureFlipper
==============

[![Gem Version](https://badge.fury.io/rb/feature_flipper.svg)](https://rubygems.org/gems/feature_flipper)
[![Build Status](https://travis-ci.org/theflow/feature_flipper.svg?branch=master)](https://travis-ci.org/theflow/feature_flipper)

FeatureFlipper is a simple library that allows you to restrict certain blocks
of code to certain environments. This is mainly useful in projects where
you deploy your application from HEAD and don't use branches.

Read more about using feature flips here:
[Feature Toggles](http://martinfowler.com/articles/feature-toggles.html).

Install
-------

FeatureFlipper is packaged as a gem:

    $ gem install feature_flipper

In your project you have to configure the path to the app specific
configuration file after requiring FeatureFlipper:

```ruby
require 'feature_flipper'
FeatureFlipper::Config.path_to_file = "#{Rails.root}/config/features.rb"
```

Example config file
-------------------

```ruby
FeatureFlipper.features do
  in_state :development do
    feature :rating_game, :description => 'play a game to get recommendations'
  end

  in_state :live do
    feature :city_feed, :description => 'stream of content for each city'
  end
end

FeatureFlipper.states do
  state :development, ['development', 'test'].include?(Rails.env)
  state :live, true
end
```

This is your complete features.rb config file. In the example there are two
states: `:development` is active on development servers and `:live` is always active
(this is the last state a feature goes through).

The feature `:rating_game` is still in development and not shown on the
production site. The feature `:city_feed` is done and already enabled
everywhere. You transition features between states by just moving the line to
the new state block and deploying your code.

You can take a look at the `static_states.rb` in the examples folder to
see this in detail.

Configuration
-------------

You need to create a configuration file which defines the two entities
FeatureFlipper cares about:

 * states
 * features

You first define multiple 'states' which normally depend on the environment
(for example: the state 'development' is only active on development servers).
After that you add 'features' which correspond to logical chunks of work in
your project. These features then move through the different states
as they get developed (for example: :development -> :staging -> :live).

### Defining features

A feature needs to have a name and you can add additional information like a
more detailed description, a ticket number, a date when it was started, etc.
Features are always defined in a state, you cannot define a feature which
doesn't belong to a state.

```ruby
in_state :development do
  feature :rating_game, :description => 'play a game to get recommendations'
end
```

### Defining states

A state is just a name and a boolean check. The check needs to evaluate to
`true` when it is active. For a Rails app you can just use environments:

```ruby
FeatureFlipper.states do
  state :development, ['development', 'test'].include?(Rails.env)
  state :staging, ['staging', development', 'test'].include?(Rails.env)
end
```

Usage
-----

In your code you then use the `show_feature?` method to branch depending on
wether a feature is active or not:

```ruby
if show_feature?(:rating_game)
  # new code
else
  # old code
end
```

The `show_feature?` method is defined on Object, so you can use it everywhere.

Dynamic feature groups
----------------------

As soon as we have the feature_flipper infrastructure in place, we can start
doing more interesting things with it. For example, dynamic features which
are enabled on a per user basis. This allows you to release features to
employees only or to a private beta group, etc.

### Defining dynamic states

A dynamic state is defined using a Proc:

```ruby
FeatureFlipper.states do
  state :development, ['development', 'test'].include?(Rails.env)
  state :employees, Proc.new { |feature_name| respond_to?(:current_user, true) && current_user.employee? }
end
```

The Proc get's evaluated in the context of where you call the `show_feature?`
method from, so it depends on your app what you can do there. In a typical Rails
app you could do checks on the current user, as shown above. This way the condition
if someone should see a feature or not can be anything: You can store it in the
database, in Redis, look at request parameters, based on the current time, etc.

Take a look at `dynamic_states.rb` in the examples folder to see this
in detail.

Meta
----

* Home: <https://github.com/theflow/feature_flipper>
* Bugs: <https://github.com/theflow/feature_flipper/issues>

This project uses [Semantic Versioning](http://semver.org/).
