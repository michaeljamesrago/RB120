#Create a class called MyCar. When you initialize a new instance or object of
#the class, allow the user to define some instance variables that tell us the
#year, color, and model of the car. Create an instance variable that is set to
#0 during instantiation of the object to track the current speed of the car as
#well. Create instance methods that allow the car to speed up, brake, and shut
#the car off.
class MyCar
  attr_reader :year, :model, :miles_to_e, :gallons_in_tank
  attr_accessor :speed, :color

  def self.mpg(car)
    car.miles_to_e / car.gallons_in_tank
  end

  def initialize(year, color, model)
    @year = year
    @color = color
    @model = model
    @speed = 0
    @miles_to_e = 225
    @gallons_in_tank = 15.0
  end

  def description
    "#{color} #{year} #{model} going #{speed} miles an hour"
  end

  def speed_up
    self.speed += 5
    self.miles_to_e -= 1
  end

  def brake
    self.speed -= 5
  end

  def shut_off
    self.speed = 0
  end

  def spray_paint(color)
    self.color = color
  end
end

#my_car = MyCar.new('2019', 'blue', 'sedan')
