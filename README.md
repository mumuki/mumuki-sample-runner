# mumukit-bootstrap

> A quick way to create a runner project using [mumukit](https://github.com/mumuki/mumukit)

## Getting Started

1. Clone this project in a clean directory, e.g. `~/projects/mumuki`
2. In a terminal, `cd` to the clone repository, run `./create.sh` and follow instructions.

## Developing

After you have created your runner, you are ready to the actual development.

### Introduction


### Make it work

> The rest of this section will assume you are creating a runner for a technology that
> already provides a test framwork, like `JUnit`, `rspec` o `hspec`. If it is not the case, please jump to [Advanced Topics](AdvancedTopics)

The first thing you should do it to implement `lib/test_hook.rb`. This will allow you to run your technology in Mumuki.
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

At least your have to do the following:

1. Implement `tempfile_extension`: return the extension for your test files. For example, for ruby it will be `'rb'`, and for java it will be `'java'`
2. Implement `command_line`: this method must return a command line that will be run within a docker container.

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
