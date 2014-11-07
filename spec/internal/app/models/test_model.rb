class TestModel
  def self.create
    @created = true
  end

  def self.created
    @created ||= false
  end

  def initialize(*args)
  end

  def save!(*args)
    TestModel.create
  end

  def created
    TestModel.created
  end
end
