namespace "Program::Main" do
  jmp_to_label :main
  label :main do
    mov :a, 0
    adi :a, 2
    mov :b, :a
    hlt
  end
end
jmp_to_label "Program::Main.main"