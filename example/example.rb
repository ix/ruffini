require 'ruffini'

EXAMPLE = <<~TEXT 
  I like apples and strawberries.
  I like cheese and ham.
  I like tea and coffee.
  I like sunsets and rainy days.
TEXT

# first parameter denotes the 'depth' of the database
database = Ruffini::Markov.new(1)

database.parse! EXAMPLE

# generate up to 10 words at random
puts database.generate(10)

# provide an initial string to start generating from!
puts database.generate(10, "I")

# we could save the database for later use! 
# database.save! "my_database.markov"

# then load it like this
# database = Ruffini::Markov.new(1, "my_database.markov")
# depth must remain the same!
