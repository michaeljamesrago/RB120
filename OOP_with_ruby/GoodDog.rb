class GoodDog
  @@number_of_dogs = 0
  attr_accessor :name, :weight, :height
  def initialize(n, w, h)
    @name = n
    @weight = w
    @height = h
    @@number_of_dogs += 1
  end
  def speak
    "#{name} says Arf!"
  end

  def change_info(n, w, h)
    self.name = n
    self.weight = w
    self.height = h
  end

  def self.total_dogs
    @@number_of_dogs
  end
  #def name
  #  @name
  #end
  #def name=(name)
  #  @name = name
  #end
end
#sparky = GoodDog.new("Sparky", "14 lbs", "15 inches")
#puts sparky.speak
#puts sparky.name
#fido = GoodDog.new("Fido", "16 lbs", "18 inches")
#puts fido.speak
#puts fido.name
#sparky.name = "Sparky Jones"
#fido.name = "Fido Johnson"
#puts sparky.name
#puts fido.speak
#sparky.change_info("Sparky W. Jones", "17 lbs", "19 inches")
#puts sparky.name, sparky.weight, sparky.height
