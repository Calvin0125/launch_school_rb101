ages = { "Herman" => 32, "Lily" => 30, "Grandpa" => 5843, "Eddie" => 10, "Marilyn" => 22, "Spot" => 237 }
smallest = ages.values.reduce { |memo, value| memo < value ? memo : value }
puts smallest