# MicroservicesUmbrella

Building an Elixir application with CQRS/ES

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