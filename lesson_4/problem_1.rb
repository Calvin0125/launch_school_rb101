flintstones = ["Fred", "Barney", "Wilma", "Betty", "Pebbles", "BamBam"]

flint_hash = {}
flintstones.each_with_index do |value, index|
  flint_hash[value] = index
end

p flint_hash