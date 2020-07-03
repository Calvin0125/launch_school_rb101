# I think I was supposed to use an iterative method but my first thought was that if there's a random number generator
# there must be a random hexadecimal generator.

require 'securerandom'
def uuid
  "#{SecureRandom.hex(4)}-#{SecureRandom.hex(2)}-#{SecureRandom.hex(2)}-#{SecureRandom.hex(2)}-#{SecureRandom.hex(6)}"
end
puts uuid
