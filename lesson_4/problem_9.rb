words = "the flintstones rock"

def titleize(string)
  string.split.map(&:capitalize).join(" ")
end

puts titleize(words)