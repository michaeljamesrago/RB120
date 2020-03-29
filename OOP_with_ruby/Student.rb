class Student
  def initialize(name, grade)
    @name = name
    @grade = grade
  end

  def better_grade_than?(student)
    @grade > student.grade
  end

  def print_grade
    puts grade
  end

  protected

  def grade
    @grade
  end
end

joe = Student.new("Joe", 97)
bob = Student.new("Bob", 95)
puts bob.print_grade
