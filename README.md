# ProgressTracker

ProgressTracker is a very simple API for logging and retreiving the progress of
a given background task. It lets you track the progress / status of multiple
objects, and retrieve them as a single set.

## Installation

Add this line to your application's Gemfile:

    gem 'progress_tracker'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install progress_tracker

## Usage

Track objects associated with a simple name, or emable the user of a class / id pair

    pt = ProgressTracker.new(:thing)
    pt = ProgressTracker.new(:billing_cycle, id)

    # Sane Defaults
    pt = ProgressTracker.new(:foo, 10)
    pt.to_hash # => { progress: 0, message: "" }


Update the progess / messages on the base object

    pt.progress 50
    pt.message "String"
    pt.status "BAD"

Or, just chuck anything you want in there

    pt.update progress: 50, message: "Strang.", status: "BAD", herpy: "derpy"

Alternatviely, track seperate, named sub-objects, again with name or class / id pair

    pt.track :cycle
    pt.track :bill, 10
    pt.track :bill, 11
    pt.track :bill, 13

    # update progress percentage
    pt.cycle.progress 34
    pt.bill(34).progress 92

    # update status message
    pt.cycle.message "Message"
    pt.bill(34).message "Message"

    # or, update them both at the same time
    pt.cycle.update progress: 14, message: "Message"
    pt.bill(34).update progress: 14, message: "Message"

Then, in an new context, re-initialise and retreive a complete overview:

    pt = ProgressTracker.new(:billing_cycle, id)
    pt.to_hash # => {
      _base: { progress: 19, message: "Message" },
      cycle: { progress: 19, message: "Message" },
      bill_10: { progress: 19, message: "Message" },
      bill_11: { progress: 19, message: "Message" },
      bill_13: { progress: 19, message: "Message" },
    }

And easily convert it to JSON as needed:

    pt.to_json

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
