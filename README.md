# README

This is a 2-player implementation of chess playable in a browser. It is a rework of a pure Ruby implementation of chess I did in partial fulfillment of [The Odin Project](https://www.theodinproject.com/courses/ruby-programming/lessons/ruby-final-project). 
The driving motivation is to build a fully independent chess API consumable by a variety if client types. If you're interested in building a client to interact with this API, just fork submit a PR.


## Game Modes

- Play as a guest in hotseat mode with another guest account on the same computer (under construction)
- Authenticated account allowing you to save and load games (coming soon)
- Multiplayer over sockets with other authenticated users (coming soon)



## Rationale

#### Game Logic:
- The chess logic is self-contained in a module and housed in app/lib
- It is called through a limited number of class methods for top-level tasks as listed below
- It has no interactions with the database (which are handled by Rails models)

#### API interactions:
For a given game instance, the API provides a JSON dump that includes data for the game, white, and black players. It should also contains an array of available moves (expressed "a3") for each piece. 

Endpoints:



## Technical Description

#### Rails: 
- Business logic API for the board, game, pieces, and saved games
- Complete [Rspec](http://rspec.info/) test coverage 
- Rails [ActionCable](http://edgeguides.rubyonrails.org/action_cable_overview.html) and Redis for multiplayer
- [JSON serialization](https://www.sitepoint.com/active-model-serializers-rails-and-json-oh-my/)
- Authorization with [Devise](https://github.com/plataformatec/devise)

#### React/Redux:  
- [Create-react-app](https://github.com/facebookincubator/create-react-app) for front end of app
- [Redux](http://redux.js.org/) to handle data


#### Rails Chess Lib Methods (all accessed via call to Chess::Game):
- `.place_pieces`: consumes  
- 

## References:
- [Rails 5 + Create-React-App](https://medium.com/superhighfives/a-top-shelf-web-stack-rails-5-api-activeadmin-create-react-app-de5481b7ec0b)
- [Rails 5 as RESTful API](https://scotch.io/tutorials/build-a-restful-json-api-with-rails-5-part-one)
- [Learn Redux](https://egghead.io/courses/getting-started-with-redux)