[![Stories in Ready](https://badge.waffle.io/mumuki/mumuki-<RUNNER>-runner.png?label=ready&title=Ready)](https://waffle.io/mumuki/mumuki-<RUNNER>-runner)
[![Build Status](https://travis-ci.org/mumuki/mumuki-<RUNNER>-runner.svg?branch=master)](https://travis-ci.org/mumuki/mumuki-<RUNNER>-runner)
[![Code Climate](https://codeclimate.com/github/mumuki/mumuki-<RUNNER>-runner/badges/gpa.svg)](https://codeclimate.com/github/mumuki/mumuki-<RUNNER>-runner)
[![Test Coverage](https://codeclimate.com/github/mumuki/mumuki-<RUNNER>-runner/badges/coverage.svg)](https://codeclimate.com/github/mumuki/mumuki-<RUNNER>-runner)

> mumuki-<RUNNER>-runner

### Install

#### Clone the Project

```bash
$ git clone https://github.com/<USERNAME>/mumuki-<RUNNER>-runner
$ cd mumuki-<RUNNER>-runner
```

#### Install Ruby Environment

[Install rbenv](https://github.com/rbenv/rbenv#installation)

```bash
# install ruby
$ rbenv install 2.3.1
$ rbenv rehash

# install bundle gem
$ gem install bundler

# install project dependencies
$ bundle install
```

### Install Docker Environment

[Install Docker](https://docs.docker.com/engine/installation/)

Verify docker installation

```bash
$ sudo docker run hello-world
```

Allow docker run without root privileges

```bash
# Create the docker group
$ sudo groupadd docker

# Add your user to the docker group.
$ sudo usermod -aG docker [your-user]
```

Log out and log back in SO that your group membership is re-evaluated.

Then Verify that you can run docker commands without sudo.

```bash
$ docker run hello-world
```

Pull docker container

```bash
$ docker pull leandrojdl/mumuki-<RUNNER>-worker
```

#### Run Tests

```bash
$ bundle exec rspec
```

