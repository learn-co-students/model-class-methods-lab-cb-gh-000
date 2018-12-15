class Captain < ActiveRecord::Base
  has_many :boats
  has_many :classifications, through: :boats
  def self.catamaran_operators
  	by_boat_class("Catamaran")
  end

  def self.sailors
  	by_boat_class("Sailboat")
  end

  def self.talented_seafarers
  	# Ruby way
  	# all.map do |captain|
  	# 	result = captain.classifications.where(name: ['Sailboat', 'Motorboat']).pluck(:name).uniq

  	# 	if result.include?('Sailboat') && result.include?('Motorboat')
  	# 		captain
  	# 	end

  	# end.compact
  	
  # 	query = "SELECT classifications.name, boats.id , classifications.id FROM boats JOIN boat_classifications ON boats.id = boat_classifications.boat_id
		# JOIN classifications ON boat_classifications.classification_id = classifications.id
		# WHERE captain_id = 2"

#   	sql = <<-SQL
# SELECT DISTINCT captains.*  FROM captains
# INNER JOIN boats ON boats.captain_id = captains.id
# iNNER JOIN boat_classifications ON boat_classifications.boat_id = boats.id
# INNER JOIN classifications ON classifications.id = boat_classifications.classification_id
# WHERE  classifications.name = 'Sailboat'  AND EXISTS (
# SELECT DISTINCT(boats.captain_id) FROM boats JOIN boat_classifications ON boat_classifications.boat_id = boats.id
# JOIN classifications ON boat_classifications.classification_id = classifications.id
# WHERE boats.captain_id = captains.id AND classifications.name = 'Motorboat'
# )
#   	SQL

    by_boat_class('Sailboat')
    .where(Boat.joins(:classifications)
      .where("boats.captain_id = captains.id AND classifications.name = 'Motorboat'")
      .distinct.exists
    )
    
  	end

  def self.by_boat_class(classification)
  	joins(:classifications).where("classifications.name = ?", classification).distinct
  end

  def self.non_sailors
    where.not(id: sailors)
  end
end