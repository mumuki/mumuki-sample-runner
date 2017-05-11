# mumukit-bootstrap

> A quick way to create a runner project using [mumukit](https://github.com/mumuki/mumukit)

## Getting Started

1. Clone this project in a clean directory, e.g. `~/projects/mumuki`
2. In a terminal, `cd` to the clone repository, run `./create.sh` and follow instructions.

## Developing

After you have created your runner, you are ready to the actual development.

### Introduction

First, let's understand what is a runner and how `mumukit` helps you to build it.

#### Brief introduction to Mumuki Runners

A runner is, simply put, an HTTP server that exposes a few routes:

* `POST /test`, which runs a mumuki test. The request contains both the code sent by the student and also the test code provided by the teacher.
* `POST /query`, which runs a mumuki query - think it as a line in a REPL
* `GET /info`, which exposes runner metadata to be able to discover it in a network and allow other tools to display information about it.

The Mumuki Platforms heavily depend on such runners, since all the Mumuki Applications delegate student's code execution to them. That allows them to remain agnostic about the supported technology details, and makes easy to add new technologies to the Platform.

Although the Mumuki Platform does not impose any restriction about how a Runner is implemented, you will normally implement a brand new runner for each technology you want to be support

### Brief introduction to `mumukit`

Implementing a Runner from scratch is a complex task, that requires a deep understanding of the communcation protocol between the Mumuki Applications and the runners. Also, although each runner provides support for a specific technology - like Java, C, Ruby or HTML - there are common problems and solutions that are independent of it.

For that reason, we have created `mumukit`, a Ruby gems that allows you to easily implement runners in, err..., ruby :stuck_out_tongue:. It acts as an abstraction layer between the low-level implementation details and the runner's programmer.

`mumukit` is a framework, and is _hook-oriented_: you will have to implement specific classes called `hook`s in order to support specific runner features. Most of them are optional, which allows you to quickly implement a runner without much effort. However, in order to implement a full-fledged runner, you may need to do more work.

`mumukit` also imposes you a particular folder-structure that you must follow:

* your code goes in `lib`
* your tests go in `spec`
* your Dockefile goes in `worker`
* you must build your project as a gem, so you will need a `.gemspec` file
* and you will be required to start your runner using the `rackup` command, so you must provide a `config.ru` file

Although this is a fairly standard ruby project structure, `mumukit-bootstrap` creates it for you automatically, plus some initial hooks :smile:.

### Make it work

> The rest of this section will assume you are creating a runner for a technology that
> already provides a unit-test framwork, like `JUnit`, `rspec` o `hspec`. If it is not the case, please jump to [Advanced Topics](AdvancedTopics)

#### Implementing the `test_hook`

After creating the project structure with `mumukit-bootstrap`, the first thing you should do it to implement the `test_hook`, located in `lib/test_hook.rb`. This will allow you to run tests for your technology in Mumuki Platform.

A simple `test_hook` will look like this:

```ruby
class YourRunnerTestHook < Mumukit::Templates::FileHook
  mashup
  isolated true

  def tempfile_extension
    '...'
  end

  def command_line(filename)
    "... #{filename}"
  end
end
```

A `test_hook` that inherits from `Mumukit::Templates::FileHook` - more on that later - has two main responsabilities:

* generate a test file that describes a self-contained test in the target techonology - for example, a `*_spec.rb` file in Ruby or a `*Test.java` in Java. It is important that the file must contain not only the test code provided by the teacher but also the code provided by the student.
  * The `mashup` directive, however, does this for you using simple defaults, so we don't have to care about this by now.
* execute that self-contained file using the technology's unit-test framework techonology. For example, the `rspec` command in Ruby makes the trick, and the `mocha` command does it in JavaScript.
  * The `isolated true` directive allows you to make this execution simple and secure, by running it within a Docker container.

Now, you have to do the following:

1. Implement `tempfile_extension`: return the extension for your test files. For example, for ruby it will be `'rb'`, and for java it will be `'java'`
2. Implement `command_line`: this method must return a command line that will be run within the previusly mentioned docker container. Some examples:

  * Ruby:    `rspec #{filename}`
  * Node:    `mocha #{filename}`
  * Haskell: `runhaskell #{filename}`

Perhaps you are wondering _Java or C do not provide such commands for running tests_ :thought_balloon:. In those cases, a simple workaround is to build the command yourself, e.g. in bash. See https://github.com/mumuki/mumuki-java-runner/blob/master/worker/runjunit as example.

#### Implementing the Docker `worker`

TODO

### Make it discoverable

1. Implement metadata

### Make it queriable

1. Implement query runner

### Test it

1. Writing tests

### Tweak it

1. Improving output parsing and error reporting
1. Structuring tests results
1. Add Feedback
1. Add Mulang support
1. Adding security
1. Changing mashup style
1. Overriding compilation entirely
1. Specifying comment type
1. Specifying content type


### Dealing with i18n

### Advanced topics

1. Embedding execution
1. Implementing your own test runner
