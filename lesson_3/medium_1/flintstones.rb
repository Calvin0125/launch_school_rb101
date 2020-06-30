string = "The Flintstones Rock!"
10.times do |i|
  puts string.rjust(string.length + i)
end