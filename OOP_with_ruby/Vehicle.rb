module Towable
  def can_tow?(gvw)
    gvw < 2000
  end
end

class Vehicle
  attr_reader :year, :model
  attr_accessor :speed, :color
  @@vehicle_count = 0

  def self.total_vehicles
    "The number of vehicles instantiated by this program is #{@@vehicle_count}"
  end

  def initialize(year = 2010, color = "purple", model = "Fart Motors Buttmobile")
    @year = year
    @color = color
    @model = model
    @speed = 0
    @@vehicle_count += 1
  end

  def to_s
    "#{color} #{year} #{model} going #{speed} miles an hour"
  end

  def speed_up
    self.speed += 5
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

  def self.gas_mileage(gallons, miles)
    puts "#{miles / gallons} miles per gallon of gas"
  end

  def age
    "This vehicle is #{private_age_method} years old."
  end

  private

  def private_age_method
    Time.now.year - year
  end
end

class MyCar < Vehicle
  NUMBER_OF_DOORS = 4

  def to_s
    "This car is a #{super.to_s}"
  end
end

class MyTruck < Vehicle
  include Towable
  NUMBER_OF_DOORS = 2
  def to_s
    "This truck is a #{super.to_s}"
  end
end

car1 = MyCar.new
truck1 = MyTruck.new(1995, "red", "Toyota Tacoma")
car2 = MyCar.new(1996, "yellow", "Ferrari Testarossa")
30.times do
  car2.speed_up
end

puts car1
puts car1.age
puts car2
puts car2.age
car1.spray_paint("red")
puts car1
