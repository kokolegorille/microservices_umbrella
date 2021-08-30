# MicroservicesUmbrella

Building an Elixir application with CQRS/ES.

This is a demo application translated from the book [Practical Microservices](https://pragprog.com/titles/egmicro/practical-microservices/).

Translated from Node to Elixir, w/ some adaptation to actor model.

## Configuration

To make it work, You need to set the path for files and videos in config/dev.exs to a writable location.

```
# FILE STORE
# Configure where to save files...
config :file_store,
  storage_dir_prefix: "/path/to/uploads"

# Video
# Configure where to save videos...
config :bff, uploads_directory: "/path/to/uploads"
```

## ApiGW

$ mix phx.new api_gw --no-ecto --no-html --no-webpack --no-dashboard --module ApiGW

## Bff

Backend for frontend, liveview endpoint

## EventStore

Store domain events, required by all systems
Use postgresql

## FileStore

Used to persists uploads

## Emailer

Send email on demand

## Identity

Use postgresql
Store user identities

## VideoPublishing

Check video creation

## VideoStore

Use postgresql
View video data