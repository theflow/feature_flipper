FeatureFlipper
==============

FeatureFlipper is a simple library that allows you to restrict certain blocks
of code to certain environments. This is mainly useful in projects where
you deploy your application from HEAD and don't use branches.

Install
-------

FeatureFlipper is packaged as a gem:

    $ gem install feature_flipper

In your project you have to configure the path to the app specific
configuration file after requiring FeatureFlipper:

    require 'feature_flipper'
    FeatureFlipper::Config.path_to_file = "#{RAILS_ROOT}/config/features.rb"

Configuration
-------------

You need to create a configuration file which defines the two entities
FeatureFlipper cares about:

 * states
 * features

You first define multiple 'states' which normally depend on an environment
(for example: the state 'dev' is only active on development boxes). After that
you add 'features' which correspond to logical chunks of work in your project.
These features then move through the different states as they get developed.

### Defining features

A feature needs to have a name and you can add additional information like a
more detailed description, a ticket number, a date when it was started, etc.
Features are always defined in a state, you cannot define a feature which
doesn't belong to a state.

    in_status :dev do
      feature :rating_game, :description => 'play a game to get recommendations'
    end

### Defining states

A state is just a name and a boolean check. The check needs to evaluate to
´true´ when it is active. For a Rails app you can just use environments:

    :dev      => ['development', 'test'].include?(Rails.env),

Usage
-----

In your code you then use the `show_feature?` method to branch depending on
wether the feature is active or not:

    if show_feature?(:rating_game)
      # new code
    else
      # old code
    end

The `show_feature?` method is defined on Object, so you can use it everywhere.

Example config file
-------------------

    FeatureFlipper.features do
      in_status :dev do
        feature :rating_game, :description => 'play a game to get recommendations'
      end

      in_status :live do
        feature :city_feed, :description => 'stream of content for each city'
      end
    end

    FeatureFlipper::Config.states = {
      :dev      => ['development', 'test'].include?(Rails.env),
      :live     => true
    }

This is your complete features.rb config file. In the example there are two
states: `:dev` is active on development boxes and `:live` is always active
(this is the last state a feature is in).

The feature `:rating_game` is still in development and not shown on the
production site. The feature `:city_feed` is done and already enabled
everywhere. You transition features between states by just moving the line to
the new state block.

You can take a look at this example in detail in the 'examples' folder.

Cleaning up
-----------

The drawback of this approach is that your code can get quite ugly with all
these if/else branches. So you have to be strict about removing (we call it
de-featurizing) features after they have gone live.

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
