# Network Executive

An experimental Rails engine used to drive displays hung around an office.

## Installation

Add this line to your application's Gemfile:

    gem 'network_executive'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install network_executive

Run the installation script:

    $ rails g network_executive:install

All that's left is to start building your network!

## Usage

    $ net_exec server

## Network

A class that represents a server instance. This is what holds the channel-line up and serves content to the browser.

### EAS

#### Creating

Each Network instance will respond to a POST to `/eas` with POST data that maps to a channel line-up.
The provided URL will pre-empt any currently scheduled programming.

#### Configuring

On the off chance that multiple EAS' are triggered at the same time, setting a priority will help the Network Executive determine which one
should be displayed. A priority of `0` is the highest value.

In the event of a tie, the most recent EAS will take priority.

It is up to the individual to be aware of each EAS they plan to trigger and what priority each should have.

For instance, an EAS for a drop in sales figures should have a lower priority than one indicating a server outage.

#### Clearing

Clearing an EAS will be made by accessing `/all_clear`. Doing so will return the viewer to regularly scheduled programming.

If multiple EAS' are active, the correct EAS will be cleared.

## Channel Line-up

  A JSON file that defines the various Programs (URLs to visit) and then they should be delivered.

    // In `channels/my_channel_name.json`
    {
      name   : 'My Channel Name',                   // Examples: Marketing, Sales, Technology, etc. Be creative!
      url    : '/my_channel_name',                  // Optional. Automatically inferred from the Channel Name
      logo   : '/logos/my_channel_logo.png,         // Optional. Automatically inferred from the Channel Name. Defaults to `nil`
      ticker : 'host.com/my_ticker_feed.xml',       // Optional. Specifying a URL will add a new ticker to the bottom for the screen with the feed's data
      on_air : '6am'
      line_up : [
        {
          url             : 'http://www.cnn.com',
          airs            : '30 * * * *'            // Every 30 minutes (from https://github.com/ncb000gt/node-cron,
                                                    // https://github.com/mattpat/node-schedule and http://www.openjs.com/scripts/jslibrary/demos/crontab.php)
          runtime         : '30min',                // How do runtimes affect air times?
          commercial_free : true,                   // Optional. Disables any commericals. Defaults to FALSE.
          username        : 'my_username',          // Optional. Necessary for Basic Auth ?
          password        : 'my_password'           // Optional. Necessary for Basic Auth ?
        },{
          url             : 'http://www.flickr.com/photos/USER/sets/1234/show/',
          airs            : '60 * * * *'
        }
      ],
      commercials : [
        '/spot_1',                                  // Local ad. Inherits all defaults.
        {
          url     : 'http://example.com/spot_2',    // Remote ad.
          airs    : '9am to 10am'                   // Air only in the morning.
          runtime : '15s'                           // Optional. `Xs`, `Xm`, or `Xh` where `X` is an integer. Defaults to 30 seconds.
        }
      ]
    }

## Commercials

Commercials provide a fun and interesting way to break up the monotony of viewing analytics data all day. Be creative!

The scheduling of commercials is determined by how many commercials are defined and long each program runs for. By default,
commercial breaks are taken twice for each 30-minute block of programming.

## Viewer

The viewer represents the client-side code that drives the whole end user experience.

## On-Screen Guide

The On-Screen Guide allows a viewer access to the entire Network. This provides an easy way to change channels.

### On-Demand

On-Demand is an On-Screen Guide feature that allows a viewer to continuously view one specific channel until further notice.

While commercials are ignored, EAS messages will still pre-empt programming.

# Ideas

* _Network_ - An server instance with a specific channel line-up. Think Tech vs. Sales vs. Marketing
* _Channel Line-up_ - A JSON/YML file that defines URLs and display times
* _EAS_ - Allow a channel to break into the schedule to display important content
* _Ticker_ - Allow a separate feed of info. Tweets, metrics, WOWs, etc.
* _Network Logo_ - Useful?
* _Commericals / PSAs_ - The More You Know?
* _Viewer_ - The client-side component. SSEs?
* _Clicker_ - Client-side slide out remote to change channels/networks?
* _On-Demand_ - Change to and stay at a specific channel. "Live" to exit.* _On-Demand_ - Change to and stay at a specific channel. "Live" to exit.1

## TODO

* Raise an exception if there are no channels to ease bootstrapping for new users
* Swap out jQuery for Zepto?
* Add http://brad.is/coding/BigScreen/

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
