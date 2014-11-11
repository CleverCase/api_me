class TestModel
  def self.create
    @created = true
  end

  def self.created
    @created ||= false
  end

  def initialize(*_args)
  end

  def save!(*_args)
    TestModel.create
  end

  def created
    TestModel.created
  end
end
