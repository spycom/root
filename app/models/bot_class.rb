class Bot_class
  def self.index
	
		@bots = Bot.all
		@agressive = Random.rand(4)
		@users = User.all
		@victum_all = User.find(:first, :offset => Random.rand(@users.count))
		
		@bots.each do |bot|
			@bot = bot
			if @bot.exp < 0
				puts "fix"
				@bot.exp = 0
				@bot.exp_all = 0
				@bot.save
			end
			evolve(bot)
		end
    
  end

	def self.evolve(bot) 
		puts "Evolving " + bot.id.to_s
	    #evolve begins
	    if bot.job == 0
	    	bot_job = Job.new name:"idle", id:0, salary:0, exp:0 
			else
	    	bot_job = Job.find_by_id(bot.job)
	    end

	    bot.update_attribute(:money, bot.money + bot_job.salary)

	    exp = Random.rand(5)
	    bot.update_attribute(:exp, bot.exp + exp)
	    bot.update_attribute(:exp_all, bot.exp_all + exp)
	    #give_exp(exp)

	    if bot.exp >= (100 * bot.level) 
				bot.update_attribute(:level, bot.level + 1)
				bot.update_attribute(:exp, bot.exp - (100 * bot.level))
	    end

	    
	    
	    if Random.rand(15) == 5
				bot.job += 1
			end

			if Random.rand(15) == 10
				bot.karma += Random.rand(2) - 1
	    end
		
	    if Random.rand(5) == 2
	    	attack_user
	    end

	    if Random.rand(5) == 3
	    	attack_bot
	    end

	    if @agressive == 1 
				all_attack_one(@victum_all)
			end

			if Random.rand(30) == 10
				generate if Random.rand(10) == 0
	    end

			puts "-success-"
	end 

	def self.evolve_attack
	  @bots = Bot.all
		@bots.each do |bot|
			upgradeSoftware(bot)
		end
	end

	def self.evolve_defense
	    @bots = Bot.all
			@bots.each do |bot|
				upgradeHardware(bot)
			end
	end

	def self.upgradeSoftware(bot) 
		sf = Random.rand(3)
		if bot.money >= sf * 10
			bot.update_attribute(:money, bot.money - sf * 10) 
	   	bot.update_attribute(:sfpts, bot.sfpts + sf) 
	  end
	end 

	def self.upgradeHardware(bot)
		hd = Random.rand(3)
		if bot.money >= hd * 10
			bot.update_attribute(:money, bot.money - hd * 10) 
	    bot.update_attribute(:hdpts, bot.hdpts + hd)
	  end
	end

	def self.generate
		if @bot.money >= 500 
			@bot.money += - 500 
			give_exp(Random.rand(@bot.level))
	    random_name = Random.rand(9).to_s + Random.rand(9).to_s + Random.rand(9).to_s
	    random_job = Random.rand(2).to_s
	    random_continent = Random.rand(5)
	    case random_continent
		    when 0
		    	continent = "Eurasia"
		    when 1
		    	continent = "North America"
		    when 2
		    	continent = "South America"
		    when 3
		    	continent = "Africa"
		    when 4
		    	continent = "Australia"
		    when 5
		    	continent = "Antarctica"
	    end
	    @bot = Bot.new name:random_name, status:"host", exp:0, exp_all:0, progress:0, level:1, money:20, job:random_job, hdpts:1, sfpts:0, continent:continent, karma:0
	    @bot.save

	    @continent = Continent.find(:first, :conditions => [ "name = ?", @user.continent.downcase ])
			@continent.update_attribute(:nodes, @continent.nodes + 1)
		end
	end

	def self.attack_bot
		victum = Bot.find(:first, :offset => Random.rand(@bots.count))
		if (@bot.level * 2) >= victum.level
			fight(@bot, victum)
		end
	end

	def self.attack_user
		@users = User.all

		victum = User.find(:first, :offset => Random.rand(@users.count))
		if (@bot.level * 3) >= victum.level
			fight(@bot, victum)
		end
	end

	def self.all_attack_one(victum)
		if @bot.level >= victum.level
			fight(@bot, victum)
		end
	end

	def self.fight(user, victum)
		puts "attacking all user..." + victum.name
		@victum = victum
		@user = user
		@user.update_attribute(:karma, @user.karma += -1)
		@victum.update_attribute(:karma, @victum.karma += 1)
	    user_power = @user.hdpts + Random.rand(@user.level)
	    victum_power = @victum.hdpts + Random.rand(@victum.level)
	    if user_power > victum_power
	      @result = 'Success! You won.'
	      @msg = "You earned " + (10/(user_power - victum_power)).to_s + " experience and stole " + (@victum.money/2).to_s + " $."
	      @victum.update_attribute(:money, @victum.money/2)
	      @victum.update_attribute(:exp, @victum.exp + (user_power - victum_power))
	      @user.update_attribute(:money, @user.money + @victum.money)
	      give_exp(10/(user_power - victum_power))
  		  #@user.update_attribute(:exp, @user.exp + 10/(user_power - victum_power))
	    else
	      @result = "Defeat! Try again."
	      @msg = "You lost " + (@user.money/4).to_s + " $"
	      @victum.update_attribute(:money, @victum.money + 10)
	      @user.update_attribute(:money, @user.money - @user.money/4)
	      give_exp(1)
  		  #@user.update_attribute(:exp, @user.exp + 1)
  		  @victum.update_attribute(:exp, @victum.exp + 10/(victum_power - user_power + 1))
	    end
	    puts @result
	    puts @msg
	end


	def self.give_exp(exp)

		@bot.exp += exp
		@bot.exp_all += exp
		if @bot.exp.to_i >= 100 * @bot.level
			@bot.exp += - 100 * @bot.level
			@bot.level += 1
		end
		@bot.save
	end
end
