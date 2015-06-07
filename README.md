# lita-wolfram-alpha

[![Build Status](https://travis-ci.org/tristaneuan/lita-wolfram-alpha.png?branch=master)](https://travis-ci.org/tristaneuan/lita-wolfram-alpha)
[![Coverage Status](https://coveralls.io/repos/tristaneuan/lita-wolfram-alpha/badge.png)](https://coveralls.io/r/tristaneuan/lita-wolfram-alpha)

**lita-wolfram-alpha** is a handler for [Lita](https://github.com/jimmycuadra/lita) that performs Wolfram Alpha queries. [Wolfram Alpha](http://www.wolframalpha.com/) is a computational knowledge engine that draws upon a comprehensive knowledge base of curated structured data to answer questions spanning a wide variety of topics.

## Installation

Add lita-wolfram-alpha to your Lita instance's Gemfile:

``` ruby
gem "lita-wolfram-alpha"
```

## Configuration

In order to use this plugin, you must obtain a [Wolfram Alpha App ID](https://developer.wolframalpha.com/portal/apisignup.html).

``` ruby
Lita.configure do |config|
  config.handlers.wolfram_alpha.app_id = "YOUR APP ID GOES HERE"
end
```

### Optional attributes
* `hide_link` (boolean) - By default, Lita returns a Wolfram Alpha link containing additional information after providing the best answer. If `hide_link` is set to true, this link is omitted.

``` ruby
Lita.configure do |config|
  config.handlers.wolfram_alpha.hide_link = true
end
```

## Usage

Specify a [Wolfram Alpha query](http://www.wolframalpha.com/examples/?src=input) using the `wa` command.

```
<me>   lita: wa most commonly spoken languages in california
<lita> only English | 19.65 million people
<lita> Spanish or Spanish Creole | 9.961 million people
<lita> Chinese | 1.037 million people
<lita> Tagalog | 765033 people
<lita> Vietnamese | 512456 people
<lita> (2008-2012 American Community Survey 5-year estimates)
<lita> Learn more: http://www.wolframalpha.com/input/?i=most+commonly+spoken+languages+in+california
```

## License

[MIT](http://opensource.org/licenses/MIT)
