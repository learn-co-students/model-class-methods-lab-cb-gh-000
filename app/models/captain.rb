class Captain < ActiveRecord::Base
  has_many :boats
  has_many :classifications, through: :boats

  def self.catamaran_operators
    joins(:classifications).where("classifications.name = 'Catamaran'")
  end

  def self.sailors
    joins(:classifications).where("classifications.name = 'Sailboat'").group('captains.name')
  end

  def self.motorboaters
    includes(boats: :classifications).where(classifications: {name: "Motorboat"})
  end

  def self.talented_seafarers
    where("captains.id IN (?)", self.sailors.pluck(:id) & self.motorboaters.pluck(:id))
  end

  def self.non_sailors
    where("id NOT IN (?)", self.sailors.pluck(:id))
  end
end
