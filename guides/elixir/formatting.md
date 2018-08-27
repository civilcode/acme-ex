# Formatting

Elixir provides automatic code formatting that can be invoked via `mix format`. Some editors
have plugins that invoke the formatter when the buffer is saved. However, some plugins do
not respect `.formatter.exs` files in child apps. Such is the case for [Atom](https://github.com/rgreenjr/atom-elixir-formatter/issues/19). With remote development
environments such as [Cloud9](https://aws.amazon.com/cloud9/), formatting on save might not even
be an option.

The solution to this is to have an external watcher that formats the files when they are saved. The
default package used at CivilCode is Facebook's [Watchman](https://facebook.github.io/watchman/).

## Dotfiles

Our [dotfiles](https://github.com/civilcode/dotfiles) has an alias configured to format files
with the alias `elixir-format`. See the alias for the actual implementation.

## Configuration

`watchman` is configured to ignore directories via `.watcmanconfig` which is automatically used when
a command is invoked.

## Run

Triggers can be defined on the command line or via a file. Our standard is to configure via a file:

    watchman -j < .watchman/format.json

## Docker

Our custom Docker development environments run this automatically for us.

## Cheatsheet

Here are some helpful commands when working with `watchman`:

    # watch a directory
    watchman watch .
    # list watches
    watchman watch-list
    # set a trigger
    watchman -- trigger ./ format '**/*.ex' '**/*.exs' '**/*.default' -- mix format
    # list triggers
    watchman trigger-list .
    # remove all watches
    watchman watch-del-all
