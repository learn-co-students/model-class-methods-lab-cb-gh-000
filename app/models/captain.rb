class Captain < ActiveRecord::Base
  has_many :boats
  has_many :classifications, through: :boats
  def self.catamaran_operators
  	by_boat_class("Catamaran")
  end

  def self.sailors
  	by_boat_class("Sailboat")
  end

  def self.motor_operators
    by_boat_class("Motorboat")
  end

  def self.talented_seafarers
    where(id: sailors.pluck(:id) & motor_operators.pluck(:id))
  end

  def self.by_boat_class(classification)
  	joins(:classifications).where(classifications: { name: classification }).distinct
  end

  def self.non_sailors
    where.not(id: sailors.pluck(:id))
  end
end