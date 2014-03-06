Sadie - Reaktor Library
=======================
# How to create a custom Reaktor?
## VERSION 3.x
What I'd like to do with 3.x is setup a polling system, which would allow
solving across multiple ports.
In addition, the removal of the annoying VERSION constants all over the reaktor.


## VERSION 2.x
Most of 1.x rules still apply to 2.x Reaktors
2.x Reaktors allow different port types (currently 3)
```
:in
  Input-only port
:out
  Output-only port
:bi
  Input/Output port
```

### Guide
1. All Reaktors are a SubClass of ```Sadie::Reaktor::Base```
2. Reaktors can initialize their internals through the use of the #init method
3. Unlike 1.x, 2.x reaktors will init their ports automatically.
4. Write a #react_port method to change the Reaktor's behaviour (be sure to call the super)
5. Add a VERSION constant if you need to.

### Example
```ruby
class MyReaktor < Sadie::Reaktor::Base

  VERSION = "1.0.0".freeze

  # register_port(type, id, name)
  #   When naming a port, it usually helps to name the port the same as the ID
  #   not necessary but name the constant the same as the ID, if possible.
  #   One naming convention (not final)
  #     INPUT_*_ID for input ports
  #     OUTPUT_*_ID for output ports
  #     CONTACT_*_ID for bi-directional ports
  register_port(:in,  INPUT_COMMON_ID  = :common, "common")
  register_port(:in,  INPUT_SIDE_ID    = :side,   "side")
  register_port(:out, OUTPUT_COMMON_ID = :output, "output")

  def init
    super
    @side = 0
  end

  ##
  # react_port(Port port, Energy energy)
  #   react_port is called by react if only the port in question exists
  def react_port(port, energy)
    super(port, energy)
    case port.id
    when INPUT_COMMON_ID
      emit(OUTPUT_COMMON_ID, energy + @side)
    when INPUT_SIDE_ID
      @side = energy.value
    end
  end

  register('my_reaktor')

end
```

## VERSION 1.x
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
