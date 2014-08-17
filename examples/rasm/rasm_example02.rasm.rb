namespace "SlateAssembly" do
  label "set0" do
    mvi :a, 0
    ret
  end
  label "set1" do
    mvi :a, 1
    ret
  end
  label "set2" do
    mvi :a, 2
    ret
  end
end
namespace "SlateAssembly::Program" do
  label "prog_entry" do
    mvi :b, 22
    ret
  end
end
# exposes all labels in the namespace SlateAssembly::Program to the current level
using "SlateAssembly::Program"
# tells the assembler that this instruction is outside the current sourcefile
extern "SlateAssembly::Helper.blak"
label "something" do
  nop # does nothing
end
namespace "SlateAssembly::Program" do
  label "main" do
    mvi :a, 0   # ensure that the accumulator is empty
    adi 2       # add 2 to the accumulator
    mov :b, :a  # move the value of the accumulator to the
    ret         # return I think?
  end
end
jmp "SlateAssembly::Program.main"
hlt
