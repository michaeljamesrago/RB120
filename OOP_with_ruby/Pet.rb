class Pet
  def run
    'running!'
  end

  def jump
    'jumping!'
  end
end

class Dog < Pet
  def speak
    "bark!"
  end
  def swim
    'swimming!'
  end
  def fetch
    'fetching!'
  end
end

class Cat < Pet
  def speak
    "meow!"
  end
end

class Bulldog < Dog
  def swim
    "can't swim."
  end
end
frank = Dog.new
puts frank.run
puts frank.jump
puts frank.fetch
puts frank.swim
puts frank.speak
fred = Cat.new
puts fred.run
puts fred.jump
puts fred.speak
bud = Bulldog.new
puts bud.run
puts bud.jump
puts bud.fetch
puts bud.swim
puts bud.speak
