# TellThem

> Well, OK. But I don't want people thinking we're
> robo-sexuals, so if anyone asks, you're my debugger.
>
> -- <cite>Bender, Futurama</cite>

TellThem is a drop-in development aid for rails that puts a nice hovering box over any page which you want to provide debug information for.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tell-them'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tell-them

## Usage

You'll need to include the tell-them style file in app/assets/stylesheets/application.scss,

```
 //= require tell-them
```

...and add a line into your layout (say in apps/views/layouts/application.html.erb) that will insert the necessary HTML:

```
<%= TellThem.html %>
```

[OPTIONAL] add the script files in app/assets/javascripts/application.js (TellThem doesn't need the javascript to work, but it enables a few nice features like saved prefs, choosing the position of the pop-up debugging box and allowing you to pin it open)

```
 //= require tell-them
```

When all that's done, TellThem is ready to use! Whenever you want to expose internal data from the controller to the developer in the webpage, just add it as one or more key:value pairs using a map:

```
TellThem.add(this: 'this is some data!', :'Become Admin' => '/become_admin?source=tell-them')
```

This data will now appear in a little pop-up box on the webpage. Note that the popup box will only appear if Rails.env.development? is true, and it will only appear if at some point in rendering of the page some data has been added with TellThem.add()

* No data? No box
* In production/staging/test? No box

If the value of any item will parse as a URI, TellThem will wrap it in a link so that it's clickable.