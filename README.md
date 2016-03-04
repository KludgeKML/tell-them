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

You'll need to add a line into your layout (say in apps/views/layouts/application.html.erb) that will insert the necessary HTML, along with JS and CSS links (I've assumed that because this is development only, JS and CSS pipeline optimisation is probably unnecessary):

```
<%= TellThem.html %>
```

Once that's done, TellThem is ready to use! 

### Data

Whenever you want to expose internal data from the controller to the developer in the webpage, just add it as one or more key:value pairs using a map:

```
TellThem.add(this: 'this is some data!', :'Become Admin' => '/become_admin?source=tell-them')
```

This data will now appear in a little pop-up box on the webpage. Note that the popup box will only appear if Rails.env.development? is true, and it will only appear if at some point in rendering of the page some data has been added with TellThem.add()

* No data? No box
* In production/staging/test? No box

If the value of any item will parse as a URI, TellThem will wrap it in a link so that it's clickable.

### Media Indicators

If you would like TellThem to help you debug your breakpoints and responsive behaviour, it can do that too. Using an array of maps, you can enable a set of CSS-styled indicators to appear on the box. Supply a `min` and/or `max` selector to match your breakpoints, and a `name` item that will display in the box header when the specified breakpoint is active. If you also add an `initial` item the ? in the TellThem box will be replaced, so that you don't have to open or pin the box to see the current breakpoint.

```
TellThem.enable_media_queries([
  { initial: "M", name: 'mobile', max: '767px' },
  { initial: "T", name: 'tablet', min: '768px', max: '889px' },
  { initial: "S", name: 'screen', min: '890px', max: '1249px' },
  { initial: "W", name: 'wide', min: '1250px' },
])
```

### Grid overlays

If you would like TellThem to help you debug grid layout as well, you can add column count, width, and spacing to the media query block. It will add a "Grid" button to the controls to toggle grid visibility, or in non-js land the grid will always be visible.

```
TellThem.enable_media_queries([
  { initial: "M", name: 'mobile', max: '767px', columns: 1, margins: '20px' },
  { initial: "T", name: 'tablet', min: '768px', max: '889px', columns: 18, column_width: '20px', column_space: '15px' },
  { initial: "S", name: 'screen', min: '890px', max: '1249px', columns: 24, column_width: '20px', column_space: '15px' },
  { initial: "W", name: 'wide', min: '1250px', columns: 36, column_width: '20px', column_space: '15px' },
])
```