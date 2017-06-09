# README

This is a 2-player implementation of chess playable in a browser. It is a rework of a pure Ruby implementation of chess I did in partial fulfillment of [The Odin Project](https://www.theodinproject.com/courses/ruby-programming/lessons/ruby-final-project). 


## How to Play

Sample Player credentials:
Email: player@example.com
Password: password

## Technical Description

Rails: 
- Business logic API for the board, game, pieces, and saved games
- Full [Rspec](http://rspec.info/) test coverage 
- Rails [ActionCable](http://edgeguides.rubyonrails.org/action_cable_overview.html) and Redis for multiplayer
- [JSON serialization](https://www.sitepoint.com/active-model-serializers-rails-and-json-oh-my/)
- Authorization with [Devise](https://github.com/plataformatec/devise)

React/Redux: 
- [Create-react-app](https://github.com/facebookincubator/create-react-app) for front end of app
- [Redux](http://redux.js.org/) to handle data

### References:
- [Rails 5 + Create-React-App](https://medium.com/superhighfives/a-top-shelf-web-stack-rails-5-api-activeadmin-create-react-app-de5481b7ec0b)
- [Rails 5 as RESTful API](https://scotch.io/tutorials/build-a-restful-json-api-with-rails-5-part-one)
- [Learn Redux](https://egghead.io/courses/getting-started-with-redux)