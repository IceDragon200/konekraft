Sadie - Reaktor Library
=======================
# VERSION 3.x
  Coming soon!

# VERSION 2.x

# VERSION 1.x
# How do Reaktors work? [V1.0.0]
Reaktors will #emit a signal to their output ports, in which the other
connected Reaktor's will #react.

# How to make a Reaktor
1. All reaktors are a SubClass of Sadie::ReaktorBase.
```ruby
class MyReaktor < Sadie::ReaktorBase
  # insert your reaktor code here
end
```

2. Reaktors must initialize their data members, variables using the init super method.
```ruby
def init
  super
  # initialize_your_stuff_here
end
```

3. Overwrite #setup_ports to initialize all I/O ports you plan to use with the Reaktor (initialize them to nil)
```ruby
def setup_ports
  @input_id[INPUT_ID] = nil
  @output_id[OUTPUT_ID] = nil
end
```

4. Create a custom reaction using the following format:
```ruby
def react(input_id, energy)
  if connection = @input[input_id]
    # do_something_with_the_connection
  end
  super(input_id, energy)
end
```ruby

## OPTIONAL
5. Add a VERSION constant to your Reaktor, VERSION is done in the format of MAJOR.MINOR.PATCH
```ruby
class MyReaktor < Sadie::ReaktorBase
  VERSION = "1.0.0".freeze
end
```
