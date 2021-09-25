nmachine
============

Nanoscopic Finite State Machine

Description
-----------
I wrote this gem for fun.

It's heavily inspired by [micromachine](https://github.com/soveran/micromachine).

Actually, this is just what happened after I read the micromachine repository.

The idea is to get most of the same functionality with less code.

The implementation is around 30 lines, but including all the other Ruby code in
this repository (mostly tests), you're looking at about 80 lines.

You can use the only class in this project to create Finite State Machines:

```ruby
require 'nmachine'

m = NMachine.new(:new) # :new is the machine's initial state, this can be anything
m.when(:submit, new: :pending) do # define a new event and the associated transitions
  puts "Submitted, the state is now #{m.state}" # pass an optional block for callbacks
end
m.when(:approve, pending: :approved) do
  puts "Approved, the state is now #{m.state}"
end
m.when(:reject, pending: :rejected) do
  puts "Rejected, the state is now #{m.state}"
end
m.when(:pause, approved: :paused, rejected: :paused, new: :paused, pending: :paused) do
  puts "Paused, the state is now #{m.state}"
end
m.when(:reset, approved: :new, rejected: :new, paused: :new) do
  puts "Reset, the state is now #{m.state}"
end

m.state #=> :new

m.submit.state
#=> Submitted, the state is now pending
#=> :pending

m.pause
#=> Paused, the state is now paused

m.reject
#=> NMachine::InvalidEventError (reject not valid from paused)

m.reset.pause.reset.approve.state
#=> Reset, the state is now paused
#=> Paused, the state is now paused
#=> Reset, the state is now paused
#=> Approved, the state is now approved
#=> :approved
```

Installation
------------

```sh
gem install nmachine
```
