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

Perhaps you are wondering _Java or C do not provide such commands for running tests_ :thought_balloon:. If that is the case, continue reading. 

#### Implementing the Docker `worker`

Implementing a Docker `worker` is quite easy: 

1. Place your Dockerfile in `worker/`
2. Build it: `docker build .`
3. Tag it: `docker build -t <TAG> .`
4. Push it `docker push <TAG>`

Then register it in your `<runner>_runner.rb` file: 

```ruby
Mumukit.configure do |config|
  config.docker_image = 'mumuki/mumuki-<RUNNER>-worker'
end
```

If you have created the `create.sh` script, we have already done it for you :wink:

But, what should contain your dockerfile? Simple put, it needs to provide a complete environment to run your technology and their tests. In other words, your docker container must be able to execute the command line returned by `command_line(filename)` in your `test_hook.rb`. 

For example, this is a `Dockerfile` that allows you to execute `ruby` + `rspec` technology:  

```Dockerfile
FROM ruby:2.2
MAINTAINER Franco Leonardo Bulgarelli
RUN gem install rspec --version '=3.5'
```

Simple, huh? :smile:

There are some cases where more work is involved. For example, there may not be a simple command to run your tests, like `rspec` or `mocha`, but a more complex sequence of steps that require code generation, compilation, creating a proper buildpath, etc. In those cases, a simple workaround is to build the command yourself, e.g. as bash script. See the following examples:

* https://github.com/mumuki/mumuki-java-runner/blob/master/worker/runjunit
* https://github.com/mumuki/mumuki-cpp-runner/blob/master/bin/runcppunit.sh

Then place this file in `worker/<CUSTOM_COMMAND>`, and add it to your Dockerfile:

```Dockerfile
...
COPY <CUSTOM_COMMAND> /bin/<CUSTOM_COMMAND>
RUN chmod u+x /bin/<CUSTOM_COMMAND>
```

### Testing it

Now you are ready to start testing your runner! :tada:. Simply run: 

```bash
bundle exec rspec
```

This will run a default integration case in `spec/` directory. You can obviusly add more examples and specs. Please notice that all hooks are easy to unit test, too, since they expose a default constructor - you can just do `MyTestHook.new` and have no other dependencies. 

### Make it discoverable

Although your runner works, you should implement metadata in order to make it a good citizen in the Mumuki Platform. Just edit the `metadata_hook` in `lib/metadata_hook.rb`: 

```ruby
class YourRunnerMetadataHook < Mumukit::Hook
  def metadata
    {language: {
        name: '...',
        version: '...',
        extension: '...',
        ace_mode: '...'
    },
     test_framework: {
         name: '...',
         version: '...',
         test_extension: '...'
     }}
  end
end
```

Please provide at least the above fields. Notice that every information provided here - plus some other generated data - will be publicly available under `GET /info`, so you can augment it with custom attributes.  

Also, be sure to keep the runner version updated in `lib/version_hook.rb`: 

```ruby
module YourRunnerVersionHook
  VERSION = '1.0.0'
end
```

### Make it queriable

1. Implement query runner
2. Making it stateful

### Tweak it

Here there are listed some common problems and solutions:

#### Improving output parsing and error reporting

It is quite common that the output of the command you are using to run the tests is not human-friendly. For example: 

* it may contain too detailed information, you will like to hide to the user
* it may not behave like a good unix command that returns 0 when command succeed, non-zero otherwise. This is a problem, since by default `mumukit` maps return codes to test and query status: `0` to `:passed`, non-zero to `:errored`, and some special return codes to `aborted`.

In those cases, you should override in the `test_hook` and/or the `query_hook` the `post_process_file` method: 

```ruby
  def post_process_file(file, result, status)
    [result, status]
  end
```

This method takes the raw output of your command - `result` - the raw return code `status` and the original self-contained test-file contents - `file` - and returns the output that will be displayed to the user, and its status. Status can be any of the following: 

* `passed`: test or query succeeded
* `failed`: test was propertly executed, but there are broken tests. 
* `errored`: test or query finished with and error - for example a compilation error or an unhandled exeception
* `aborted`: test or query was cancelled by the runner because of a memory, time or cpu limits reached. `mumukit` will in fact try to detect those conditions and stop the docker container. 

For example, the following code removes verbose details from a ruby stack trace within a ruby a `query_runner`: 

```ruby
class RubyQueryHook < Mumukit::Templates::FileHook
  ...
  def post_process_file(_file, result, status)
    if status == :failed && error_output?(result)
      [sanitize_error_output(result), status]
    else
      super
    end
  end


  def error_output?(result)
    error_regexp =~ result
  end

  def sanitize_error_output(result)
    result.gsub(error_regexp, '').strip
  end

  def error_regexp
    # Matches lines like:
    # * from /tmp/mumuki.compile20170404-3221-1db8ntk.rb:17:in `<main>'
    # * /tmp/mumuki.compile20170404-3221-1db8ntk.rb:17:in `respond_to?':
    /(from )?(.)+\.rb:(\d)+:in `([\w|<|>|?|!|+|*|-|\/|=]+)'(:)?/
  end
end
```


#### Adding (some sort of) security

Sometimes yo ur technology may expose specific keywords or constructs that you would like to disable completly. A simply approach to this is to implement a `validation_hook` in `lib/validation_hook.rb`. For example, this prevents Haskell runner to execute code that referencies the module `System.IO.Unsafe`: 

```haskell
class HaskellValidationHook < Mumukit::Hook
  def validate!(request)
    raise Mumukit::RequestValidationError, 'you can not use unsafe io' if unsafe?(request)
  end

  def unsafe?(request)
    [
        request.content,
        request.test,
        request.extra,
        request.query
    ].compact.any? { |it| it.include? 'System.IO.Unsafe' }
  end
end
```

A `validation_hook` takes a `request` object that represents the raw `POST /test` or `/POST query` request. It expo ses the following methods:

* `content`: the student's solution. 
  * `nil` on `/query` requests. 
* `test`: the teacher's test. 
  * `nil` on `/query` requests. 
* `query`: the student's query. 
  * `nil` on `/test` requests. 
* `extra`: extra code provided by the teacher, that may or may not be visible to the student
  * `nil` if teacher has not provided extra code
  
Then require this file in your `<runner>_runner.rb` file. E.g: 

```ruby
require 'mumukit'

...

require_relative './validation_hook'
```

#### Structuring tests results
#### Add Feedback
#### Add Mulang support
#### Changing mashup style
#### Overriding compilation entirely
#### Specifying comment type
#### Specifying content type
#### Dealing with i18n
#### Embedding execution
#### Implementing your own test runner
