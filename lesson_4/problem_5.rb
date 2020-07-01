flintstones = %w(Fred Barney Wilma Betty BamBam Pebbles)
puts flintstones.index { |value| value[0, 2] == "Be" }