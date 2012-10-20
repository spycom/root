class Continent_class
  def self.index

		@continents = Continent.all
		@continents.each do |continent|
			
			@i = 0
			@p = 0
			@k = 0
			
			@users = User.find_all_by_continent(continent.name.downcase)
			@users.each do |user|
				@i += 1
				@p += user.hdpts + user.sfpts
				@k += user.karma
			end
			
			@bots = Bot.find_all_by_continent(continent.name.downcase)
			@bots.each do |bot|
				@i += 1
				@p += bot.hdpts + bot.sfpts
				@k += bot.karma
			end

			continent.nodes = @i
			continent.power = @p
			continent.karma = @k
			continent.save
		end
    
  end
end

