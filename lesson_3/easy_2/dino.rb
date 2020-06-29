advice = "Few things in life are as important as house training your pet dinosaur."
puts advice.include?("Dino")

return_value = advice.slice!(0, advice.index('house'))
puts return_value
puts advice