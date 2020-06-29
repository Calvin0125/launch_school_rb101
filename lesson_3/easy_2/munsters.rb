munsters = "The Munsters are creepy in a good way."
puts munsters.swapcase
puts munsters.downcase.capitalize
puts munsters.downcase
puts munsters.upcase

ages = { "Herman" => 32, "Lily" => 30, "Grandpa" => 5843, "Eddie" => 10 }
additional_ages = { "Marilyn" => 22, "Spot" => 237 }
ages.merge!(additional_ages)
p ages