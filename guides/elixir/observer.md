# Using Observer

## Setup

On MacOS, you first have to install XQuartz:

    brew cask install xquartz

Then, start XQuartz and change the following Security preferences:

- Authenticate connections: unchecked
- Allow connections from network clients: checked

Restart XQuartz for the new settings to be applied.

## How-To

Using `observer` on the application node involves first starting the application
with a cookie and a short name. Then, you start an `observer` in the `erlang`
container using the same cookie, and then connect to the application node.

Start the application:

    make console

Start the observer:

    make observer

Connect to the application node in `observer` using the name `vm@application`.
