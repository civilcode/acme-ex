# FTP with Elixir

This guide covers connecting an Elixir client to:

1. Traditional FTP server
2. sFTP server

The notes below are suitable for a Docker-based development/CI environment.

## Traditional FTP

You need two items:

1. [Docker image](https://hub.docker.com/r/mcreations/ftp/)
2. Elixir FTP client: use the Erlang [ftp client](https://erlang.org/doc/man/ftp.html)

### Docker

```yaml
# docker-compose.yml
# 'ftp' will the host of the server within the docker network, i.e. if you try to connect
# to the server from another container

  ftp:
    image: mcreations/ftp
    ports:
      - "21:21"
    environment:
       FTP_USER: foo
       FTP_PASS: bar
       HOST: ftp
    volumes:
      - ftp-data:/data/foo/incoming/
```

### Elixir

```elixir
# example usage for :ftp
# note the use of charlists for the parameters

# connect
{:ok, connection_pid} = :ftp.open('ftp')
:ftp.user(connection_pid, 'foo', 'bar')

# pwd
:ftp.pwd(connection_pid)

# put
:ftp.send(connection_pid, 'local.txt', 'incoming/remote.txt')

# get
:ftp.recv_bin(connection_pid, 'incoming/remote.txt')

# delete
:ftp.delete(connection_pid, 'incoming/remote.txt')
```

## sFTP (secure)

You need two items:

1. [Docker image](https://github.com/atmoz/sftp)
2. Elixir [sFTP client](https://hexdocs.pm/sftp_ex/SftpEx.html#content): The wrapper library for [:ssh_sftp](http://erlang.org/doc/man/ssh_sftp.html) is highly recommended as it makes the library so much easier to use. Alternative,
[:sftp_utils](https://github.com/kivra/sftp_utils) is an option.

### Docker

```yaml
# docker-compose.yml
# 'sftp' will the host of the server within the docker network, i.e. if you try to connect
# to the server from another container

  sftp:
    image: atmoz/sftp
    environment:
      # username:password:::upload_directory
      # The upload directory here results in /home/foo/incoming
      # You can change 'incoming' to any directory you like, e.g. 'uploads'
      SFTP_USERS: foo:bar:::incoming
    ports:
      - "22:22"
```

### Elixir

```elixir
# example usage for SftpEx
# note the use of charlists for the parameters, event though it is an Elixir library

# connect
{:ok, connection} = SftpEx.connect( host: 'sftp', user: 'foo', password: 'bar')

# pwd (no equivalent in the library, use the erlang libary to do this)
:ssh_sftp.real_path(connection.channel_pid, '/')

# put
{:ok, binary} = File.read('local.txt')
SftpEx.upload(connection, 'incoming/remote.txt', binary)

# get
[binary] = SftpEx.download(connection, 'incoming/remote.txt')

# delete
 SftpEx.rm(connection, 'incoming/remote.txt')

 # disconnect
 SftpEx.disconnect(connection)
```

### Verify Setup

To make sure that everything is setup correctly you can use the command line `ftp` client.

    $ docker-compose up sftp # equivalent of `docker run -p 22:22 atmoz/sftp foo:bar:::incoming`
    $ sftp foo@localhost

Listed below are some issues that you may experience.

_Issue: Remote host identification has changed._

    $ sftp foo@localhost

    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
    Someone could be eavesdropping on you right now (man-in-the-middle attack)!
    It is also possible that a host key has just been changed.
    The fingerprint for the EDXXX key sent by the remote host is
    SHA256:XXX
    Please contact your system administrator.
    Add correct host key in /Users/your_user_name/.ssh/known_hosts to get rid of this message.
    Offending EDXXX key in /Users/your_user_name/.ssh/known_hosts:23
    EDXXX host key for localhost has changed and you have requested strict checking.
    Host key verification failed.
    Connection closed

_Solution: Remove the entry from the specified line in ` /Users/your_user_name/.ssh/known_hosts`, in this example line 23._

_Issue: permission denied._

    sftp> put /Users/your_user_name/Downloads/local.txt
    Uploading /Users/your_user_name/Downloads/local.txt to /remote.txt
    remote open("/test.jpg"): Permission denied

_Solution: Use the directory specified in the docker config._

    sftp> put /Users/your_user_name/Downloads/local.txt incoming/remote.txt
    Uploading /Users/your_user_name/Downloads/local.txt to /incoming/remote.txt
    /Users/your_user_name/Downloads/local.txt

## CircleCI

### Config

```yaml
# .circleci/config.yml

jobs:
  build:
    environment:
      - MIX_ENV: "test"
    docker:
      - image: atmoz/sftp
        environment:
          SFTP_USERS: foo:bar:::incoming
```

In this case the host name will be 'localhost', e.g:

```elixir
SftpEx.connect(host: 'localhost', user: 'foo', password: 'bar')
```

However, you can add other host names:

```yaml
# .circleci/config.yml
jobs:
  build:
  # ...
    steps:
      - checkout
      - run: echo 127.0.0.1 myhost | sudo tee -a /etc/hosts
```

Then you can use:

```elixir
SftpEx.connect(host: 'myhost', user: 'foo', password: 'bar')
```

But you should consider using a config to change the host name.