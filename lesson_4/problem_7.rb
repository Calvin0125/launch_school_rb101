statement = "The Flintstones Rock"
frequency = statement.chars.each_with_object(Hash.new(0)) { |letter, hash| hash[letter] += 1 }
p frequency