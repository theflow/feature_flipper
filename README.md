**NOTE: THIS REPO HAS BEEN DEPRECATED**

FeatureFlipper
==============

FeatureFlipper is a simple library that allows you to restrict certain blocks
of code to certain environments. This is mainly useful in projects where
you deploy your application from HEAD and don't use branches.

Read more about the motivation in the
[introductory blog post](http://engineering.qype.com/2010/06/03/how-we-work-flipping-features/).

Install
-------

FeatureFlipper is packaged as a gem:

    $ gem install feature_flipper

In your project you have to configure the path to the app specific
configuration file after requiring FeatureFlipper:

    require 'feature_flipper'
    FeatureFlipper::Config.path_to_file = "#{RAILS_ROOT}/config/features.rb"

Example config file
-------------------

    FeatureFlipper.features do
      in_state :development do
        feature :rating_game, :description => 'play a game to get recommendations'
      end

      in_state :live do
        feature :city_feed, :description => 'stream of content for each city'
      end
    end

    FeatureFlipper::Config.states = {
      :development => ['development', 'test'].include?(Rails.env),
      :live        => true
    }

This is your complete features.rb config file. In the example there are two
states: `:development` is active on development boxes and `:live` is always active
(this is the last state a feature goes through).

The feature `:rating_game` is still in development and not shown on the
production site. The feature `:city_feed` is done and already enabled
everywhere. You transition features between states by just moving the line to
the new state block.

You can take a look at the `static_states.rb` in the examples folder to
see this in detail.

Configuration
-------------

You need to create a configuration file which defines the two entities
FeatureFlipper cares about:

 * states
 * features

You first define multiple 'states' which normally depend on the environment
(for example: the state 'development' is only active on development boxes).
After that you add 'features' which correspond to logical chunks of work in
your project. These features then move through the different states
as they get developed (for example: :development -> :staging -> :live).

### Defining features

A feature needs to have a name and you can add additional information like a
more detailed description, a ticket number, a date when it was started, etc.
Features are always defined in a state, you cannot define a feature which
doesn't belong to a state.

    in_state :development do
      feature :rating_game, :description => 'play a game to get recommendations'
    end

### Defining states

A state is just a name and a boolean check. The check needs to evaluate to
`true` when it is active. For a Rails app you can just use environments:

    FeatureFlipper::Config.states = {
      :development => ['development', 'test'].include?(Rails.env)
    }

Or you can use neat and simple DSL:

    FeatureFlipper.states do
      state :development, ['development', 'test'].include?(Rails.env)
    end

Usage
-----

In your code you then use the `show_feature?` method to branch depending on
wether a feature is active or not:

    if show_feature?(:rating_game)
      # new code
    else
      # old code
    end

The `show_feature?` method is defined on Object, so you can use it everywhere.

Cleaning up
-----------

The drawback of this approach is that your code can get quite ugly with all
these if/else branches. So you have to be strict about removing features
(we call it de-featurizing) after they have gone live.

Dynamic feature groups
----------------------

As soon as we have the feature_flipper infrastructure in place, we can start
doing more interesting things with it. For example, dynamic features which
are enabled on a per user basis. This allows you to release features to
employees only or to a private beta group, etc.

### Defining dynamic states

A dynamic state is defined a bit different than a normal, static state.

    FeatureFlipper.states do
      state :development, ['development', 'test'].include?(Rails.env),
      state :employees,   { :required_state => :development, :feature_group => :employees }
    end

It has a required state and a feature group. The feature group defines
a symbolic name for the group of users who should see this feature. You
can name this whatever you want. The required state is the state that gets
looked at for all other users that aren't in the feature group. The required
state (:development) must be a defined, static state.

### Setting the feature group

The feature group is set globally and is active for the whole thread.
In Rails you would define a before_filter like this:

    class ApplicationController < ActionController::Base
      before_filter :set_active_feature_group
      
      def set_active_feature_group
        # we need to reset the feature group in each request,
        # otherwise it's also active for the following requests.
        FeatureFlipper.reset_active_feature_groups
        
        if logged_in? && current_user.employee?
          FeatureFlipper.active_feature_groups << :employees
        end
      end

Don't forget to reset the feature group, without it the feature group
is active forever. The condition if someone is in a feature group
can be anything: You can store it in the database, in Redis,
look at request parameters, based on the current time, etc.

Take a look at `dynamic_states.rb` in the examples folder to see this
in detail.

### Feature dependencies

Specifying :requires option for your feature will create dependency. Example:

    FeatureFlipper.features do
      in_state :disabled do
        feature :will_never_work
      end

      in_state :live do
        feature :i_want_this, :requires => :will_never_work
      end
    end

Sure enough :i_want_this feature will be disabled because it's dependency is 
disabled. You can specify many dependencies by passing an array of features.

There are no checks for stack overflows so be careful.

Meta
----

* Code: `git clone git://github.com/qype/feature_flipper.git`
* Home: <http://github.com/qype/feature_flipper>
* Bugs: <http://github.com/qype/feature_flipper/issues>

This project uses [Semantic Versioning][sv].

Author
------

Florian Munz, Qype GmbH - florian@qype.com


[sv]: http://semver.org/
