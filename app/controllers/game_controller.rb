class GameController < ApplicationController
  def index
	
		# initialization
	  if params[:task] == "start"
		  @name = params[:name]

		  if User.find(:first, :conditions => [ "name = ?", @name.downcase ]) != nil
			
			  @user = User.find(:first, :conditions => [ "name = ?", @name.downcase ])
				
				if @user.job == 0 
					@job = Job.new name:"idle", id:0, salary:0, exp:0 
				else	
					@job = Job.find_by_id(@user.job)
				end

			  if @user.cpu?

			  else
			  	@user.cpu = 1
			  	@user.save
			  end

			  @current_job = @job.name
			  @current_task = "thinking"

			  @download = Random.rand(1024)
			  @upload = Random.rand(1024)

			  @hdpts = @user.hdpts
			  @sfpts = @user.sfpts

			  @attack = 0
			  @progress = @user.progress
          session[:current_user_id] = @user.id
          #redirect_to :action => :index
			else
			  @current_job = "idle"
			  @current_task = "idle"

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

			  @download = Random.rand(1024)
			  @upload = Random.rand(1024)
			  @attack = 0

			  @user = User.new name:@name, status:"host", exp:0, exp_all:0, progress:0, level:1, money:20, job:0, hdpts:1, sfpts:0, continent:continent, karma:0, cpu:1, memory:0, storage:0, power:0, network:0, menial:1, intrusion:0, stockman:0, sociology:0, stealth:0, telepresence:0, hosts:1
	 		  @user.save
	 		  @job = Job.new name:"Wasting power", id:0, salary:0, exp:0

			  @continent = Continent.find(:first, :conditions => [ "name = ?", @user.continent.downcase ])
			  @continent.update_attribute(:nodes, @continent.nodes + 1)
				session[:current_user_id] = @user.id
			end
 		  
	  else
		  @id = session[:current_user_id]
		  	
			find_user
			
			if @user.job != 0 
				@current_task = "working"
				@job = Job.find_by_id(@user.job)
			else
				@job = Job.new name:"idle", id:0, salary:0, exp:0 
			end
		  
	  end

	  if Service.find(:first, :conditions => [ "uid = ?", @user.id ]) != nil
		  		@service_bla = Service.find(:first, :conditions => [ "uid = ?", @user.id ])
		  	else
		  		@service_bla = Service.new uid:@user.id
		  		
		  	end

	  @download = @user.level + Random.rand(@user.hdpts + @user.sfpts) #- Random.rand(@user.karma)
		@upload = @user.level + Random.rand(@user.hdpts + @user.sfpts) #- Random.rand(@user.karma)
	  @continents = Continent.all(:order => 'power DESC')
	  calc_salary
  end

  def job 
		find_user
		@jobs = Job.all

		if params[:task] == "new"
		  	
		  #@user.karma += 1
			@job = Job.find_by_id(params[:id])
			calc_salary
			work(@salary)
			make_exp(2 * params[:id].to_i)

			@user.update_attribute(:job, params[:id])

			redirect_to :action => :index
		
		end

		if params[:task] == "add"
			#@job = Job.new name:"Game developer", salary:120, exp:10000
		 	#@job.save
		 	#@job = Job.new name:"Sniffing", salary:140, exp:15000
		 	#@job.save
		 	#@job = Job.new name:"Fishing", salary:170, exp:25000
		 	#@job.save
		end
  end

  def hard 
		find_user
		if @user.memory?
			#@cpu_pool = @user.cpu - @user.menial - @user.intrusion - @user.stockman - @user.sociology - @user.stealth - @user.telepresence
		else
			@user.memory = 1
			@user.network = 0
			@user.storage = 0
			@user.power = 0
			@user.save
		end

		if params[:task] == "new"
			@user.hdpts += params[:id].to_i
			@hardware = Hardware.find_by_id(params[:id])
			#@user.money = @user.money.to_i - @hardware.price
			pay(@hardware.price)

			env = @hardware.name
			if env.scan("CPU").size >= 1
				@user.cpu += 1
			end
			if env.scan("Memory").size >= 1
				@user.memory += 1
			end
			if env.scan("Storage").size >= 1
				@user.storage += 1
			end
			if env.scan("UPS").size >= 1
				@user.power += 1
			end
			

			make_exp(3*params[:id].to_i)

			redirect_to :action => :index
			
		end
		
		if params[:task] == "add"
			#@hardware = Hardware.new name:"", price:50, exp:40
		 	#@hardware.save
		end

		@hardwares = Hardware.all
  end

  def soft 
  	find_user

		if params[:task] == "new"
			
			@software = Software.find_by_id(params[:id])
			@user.sfpts += @software.id
			#@user.money += -@software.price
			pay(@software.price)
			

			@uid = @user.id
			if Service.find(:first, :conditions => [ "uid = ?", @uid ]) != nil
		  		@service_bla = Service.find(:first, :conditions => [ "uid = ?", @uid ])
		  	else
		  		@service_bla = Service.new uid:@uid
		  end

			env = @software.name
			if env.scan("SPAM").size >= 1
				
		  	if @service_bla.spam
		  		@service_bla.spam += 1
		  	else
		  		@service_bla.spam = 1
		  	end
		  	@user.menial += 1
			end

			if env.scan("Low Orbit Ion Cannon").size >= 1
				
		  	if @service_bla.loic
		  		@service_bla.loic += 1
		  	else
		  		@service_bla.loic = 1
		  	end
		  	@user.intrusion += 1
			end

			if env.scan("Hosting").size >= 1
				
		  	if @service_bla.hosting
		  		@service_bla.hosting += 1
		  	else
		  		@service_bla.hosting = 1
		  	end
		  	@user.menial += 1
			end

			if env.scan("Host Controller").size >= 1
				
		  	if @service_bla.botnet
		  		@service_bla.botnet += 1
		  	else
		  		@service_bla.botnet = 1
		  	end
		  	@user.stockman += 1

			end

			if env.scan("Botnet").size >= 1
				
		  	if @service_bla.botnet
		  		@service_bla.botnet += 1
		  	else
		  		@service_bla.botnet = 1
		  	end
		  	@user.intrusion += 1
		  	@user.stockman += 1
		  	@user.telepresence += 1
			end

			if env.scan("logins database").size >= 1
				
		  	if @service_bla.botnet
		  		@service_bla.botnet += 1
		  	else
		  		@service_bla.botnet = 1
		  	end
		  	@user.stockman += 1
		  	@user.intrusion += 1
			end

			if env.scan("white").size >= 1
				
		  	
		  	@user.sociology += 1
		  	@user.stealth += 1
			end

			if env.scan("Matrix").size >= 1
				
		  	
		  	@user.sociology += 1
		  	@user.stealth += 1
			end

			@service_bla.save
			make_exp(3*params[:id].to_i)

			redirect_to :action => :index
			
		end
		#$money = $money.to_i - 25
		#$exp += 10
		if params[:task] == "add"
			#@software = Software.new name:"SPAM generator", price:10, exp:0
		 	#@software.save
		end
		@softwares = Software.all
  end
  
  def show
  end

  def db
	  @users = User.all
	  find_user
  end

  def quests
  end

  def uplink
	  if params[:task] == "connect"
		  redirect_to :action => :index
	  end
  end

  def ip
  end

  def domain
	  if params[:task] == "connect"
		  redirect_to :action => :index
		end
  end

  def attack 
	  if params[:task] == "attack"
		  @attack += @hdpts.to_i
		  #params[:task] = "idle"
		  #redirect_to :action => :attack
	  end
  end

  def attack_user
    find_user
	  if params[:task] == "fight"
	    @victum = User.find_by_id(params[:id])
	    @user.update_attribute(:karma, @user.karma += -1)
	    user_power = @user.hdpts + Random.rand(@user.level)
	    victum_power = @victum.hdpts + Random.rand(@victum.level)
	    if user_power > victum_power
	      @result = 'Success! You won.'
	      @msg = "You earned " + (10/(user_power - victum_power)).to_s + " experience and stole " + (@victum.money/2).to_s + " $."
	      @victum.update_attribute(:money, @victum.money/2)
	      @victum.update_attribute(:exp, @victum.exp + (user_power - victum_power))
	      @user.update_attribute(:money, @user.money + @victum.money)
	      make_exp(10/(user_power - victum_power))
  		  #@user.update_attribute(:exp, @user.exp + 10/(user_power - victum_power))
	    else
	      @result = "Defeat! Try again."
	      @msg = "You lost " + (@user.money/4).to_s + " $"
	      @victum.update_attribute(:money, @victum.money + 10)
	      @user.update_attribute(:money, @user.money - @user.money/4)
	      make_exp(1)
  		  #@user.update_attribute(:exp, @user.exp + 1)
  		  @victum.update_attribute(:exp, @victum.exp + 10/(@victum.hdpts - @user.hdpts + 1))
	    end
	    
	    #@victum.update_attribute(:money, @victum.money - 10)
		  #@user.update_attribute(:money, @user.money + 5)
		  #@user.update_attribute(:exp, @user.exp + 2)
	  else
	    
	    @victum = User.find_by_id(params[:id])
	    
	  if params[:id] == "fight"
	      
		  if @user.hdpts > @victum.hdpts
	      #@result = "Success! You won. <br> You earned " + (10/(@user.hdpts - @victum.hdpts)).to_s + " experience."
	      #@victum.update_attribute(:money, @victum.money - 10)
	      #@user.update_attribute(:money, @user.money + 5)
  		  #@user.update_attribute(:exp, @user.exp + 10/(@user.hdpts - @victum.hdpts))
	    else
	      #@result = "Defeat! Try again."
	      #@victum.update_attribute(:money, @victum.money + 10)
	      #@user.update_attribute(:money, @user.money - 5)
  		  #@user.update_attribute(:exp, @user.exp + 1)
  		  #@victum.update_attribute(:exp, @victum.exp + 10/(@victum.hdpts - @user.hdpts + 1))
	    end
	  else
		  if params[:id] != 0
			  @victum = User.find_by_id(params[:id])
		  else
			  @victum = @user
		  end
	  end 
	  end 
  end

  def infect 
  	find_user
  	@victum = User.find_by_id(params[:id])
  	@user.update_attribute(:karma, @user.karma += -1)
  	if @user.sfpts > @victum.sfpts
  		@victum.update_attribute(:karma, @victum.karma += 1)
  		@victum.update_attribute(:hdpts, @victum.hdpts += -1)
  		make_exp(Random.rand(@user.level))
  	end
  	redirect_to :action => :db
  end

  def infect_bot 
  	find_user
  	@victum = Bot.find_by_id(params[:id])
  	@user.update_attribute(:karma, @user.karma += -1)
  	if @user.sfpts > @victum.sfpts
  		@victum.update_attribute(:karma, @victum.karma += 1)
  		@victum.update_attribute(:hdpts, @victum.hdpts += -1)
  		make_exp(Random.rand(@user.level))
  	end
  	redirect_to :action => :bots
  end

	# select user by session id

	def find_user
		@user = User.find(:first, :conditions => [ "id = ?", session[:current_user_id] ])
	end

	# simulating fight between 2 players
	def simulate_fight(agressor, victum)
		user_power = agressor.hdpts + agressor.sfpts + Random.rand(agressor.level)
		victum_power = victum.hdpts + victum.sfpts + Random.rand(victum.level)
	    if user_power > victum_power
	      @result = 'Success! You won.'
	      @msg = "You earned " + (10/(user_power - victum_power)).to_s + " experience."
	      victum.update_attribute(:money, victum.money/2)
	      victum.update_attribute(:exp, victum.exp + (user_power - victum_power))
	      agressor.update_attribute(:money, agressor.money + victum.money)
  		  agressor.update_attribute(:exp, agressor.exp + 10/(user_power - victum_power))
	    else
	      @result = "Defeat! Try again."
	      @msg = "Victum earned " + 10/(victum.hdpts - agressor.hdpts + 1) + " experience."
	      victum.update_attribute(:money, victum.money + 10)
	      agressor.update_attribute(:money, agressor.money - agressor.money/4)
  		  agressor.update_attribute(:exp, agressor.exp + 1)
  		  victum.update_attribute(:exp, victum.exp + 10/(victum.hdpts - agressor.hdpts + 1))
	    end
	end

	# make money
	def work(money)
		@user.money = @user.money + money
		@user.save
	end

	#give some experience
	def make_exp(exp)
		@user.exp += exp
		@user.exp_all += exp
		if @user.exp.to_i >= 100 * 2 ** (@user.level - 1)
			@user.exp += - (100 * 2 ** (@user.level - 1))
			@user.level += 1
		end
		@user.save
	end

	def evolve 
		find_user

		if params[:task] == "evolve"
			upgrade = Upgrade.find_by_id(params[:id])

			case params[:id].to_i
			when 1
				if @user.hosts
					@user.hosts += 1
				else
					@user.hosts = 1
				end
				
			when 2
				@user.hdpts += 	@user.hdpts/10
			when 3
				@user.karma += 2
			end	
			@user.save
			pay(upgrade.price)
			make_exp(40 * params[:id].to_i)
			redirect_to :action => :index
		end
			
		if params[:id] == "add"
			#@upgrade = Upgrade.new name:"Add 1 new host", price:500, exp:500
		 	#@upgrade.save
		 	#@upgrade = Upgrade.new name:"Upgrade cooling system", price:1000, exp:900
		 	#@upgrade.save
		 	#@upgrade = Upgrade.new name:"Backup", price:2000, exp:1700
		 	#@upgrade.save
		end

		@upgrades = Upgrade.all


	end

	def calc_salary
		@salary = @job.salary + (@user.hdpts + @user.sfpts)/2
		
	end

	def bots 
		find_user
		@bots = Bot.all
	end

	def attack_bot
		find_user

	  if params[:task] == "fight"
	    @victum = Bot.find_by_id(params[:id])
	    @user.update_attribute(:karma, @user.karma += -1)
	    user_power = @user.hdpts + Random.rand(@user.level)
	    victum_power = @victum.hdpts + Random.rand(@victum.level)
	    if user_power > victum_power
	      @result = 'Success! You won.'
	      @msg = "You earned " + (10/(user_power - victum_power)).to_s + " experience and stole " + (@victum.money/2).to_s + " $."
	      @victum.update_attribute(:money, @victum.money/2)
	      @victum.update_attribute(:exp, @victum.exp + (user_power - victum_power))
	      @user.update_attribute(:money, @user.money + @victum.money)
	      make_exp(10/(user_power - victum_power))
  		  #@user.update_attribute(:exp, @user.exp + 10/(user_power - victum_power))
	    else
	      @result = "Defeat! Try again."
	      @msg = "You lost " + (@user.money/4).to_s + " $"
	      @victum.update_attribute(:money, @victum.money + 10)
	      @user.update_attribute(:money, @user.money - @user.money/4)
	      make_exp(1)
  		  #@user.update_attribute(:exp, @user.exp + 1)
  		  @victum.update_attribute(:exp, @victum.exp + 10/(@victum.hdpts - @user.hdpts + 1))
	    end
	    
	    #@victum.update_attribute(:money, @victum.money - 10)
		  #@user.update_attribute(:money, @user.money + 5)
		  #@user.update_attribute(:exp, @user.exp + 2)
	  else
	    
	    #@victum = Bot.find_by_id(params[:id])
	    
			if params[:id] != 0
				  @victum = Bot.find_by_id(params[:id])
			else
				  @victum = @user
			end
	  end 
	end

	def research
		find_user
		if @user.menial?
			@cpu_pool = @user.cpu - @user.menial - @user.intrusion - @user.stockman - @user.sociology - @user.stealth - @user.telepresence
		else
			@user.menial = 1
			@user.intrusion = 0
			@user.stockman = 0
			@user.sociology = 0
			@user.stealth = 0
			@user.telepresence = 0
			@user.save
			@cpu_pool = 0
		end

		if params[:id]
			if @cpu_pool > 0
				case params[:id].to_i 
					when 1 
						if @user.menial
							@user.menial += 1
						else
							@user.menial = 1
						end
					when 2
						if @user.intrusion
							@user.intrusion += 1
						else
							@user.intrusion = 1
						end
					when 3 
						if @user.stockman
							@user.stockman += 1
						else
							@user.stockman = 1
						end
					when 4 
						if @user.sociology
							@user.sociology += 1
						else
							@user.sociology = 1
						end
					when 5 
						if @user.stealth
							@user.stealth += 1
						else
							@user.stealth = 1
						end
					when 6 
						if @user.telepresence
							@user.telepresence += 1
						else
							@user.telepresence = 1
						end
				end
				@user.save
			end
			
			
			redirect_to :action => :research, :id => nil
		end
	end

	def services
		find_user

		if params[:id]
			@service = ServiceStore.find_by_id(params[:id])
			@user.sfpts += @service.id
			#@user.money += -@service.price
			pay(@service.price)
			
			@uid = @user.id
			if Service.find(:first, :conditions => [ "uid = ?", @uid ]) != nil
		  		@service_bla = Service.find(:first, :conditions => [ "uid = ?", @uid ])
		  	else
		  		@service_bla = Service.new uid:@uid
		  end

			env = @service.name
			if env.scan("DHCP").size >= 1
				#@user.cpu += 1
				
		  	if @service_bla.dhcp
		  		@service_bla.dhcp += 1
		  	else
		  		@service_bla.dhcp = 1
		  	end
			end

			if env.scan("SMTP").size >= 1
				if @service_bla.smtp
		  		@service_bla.smtp += 1
		  	else
		  		@service_bla.smtp = 1
		  	end
			end

			if env.scan("NAT").size >= 1
				if @service_bla.nat
		  		@service_bla.nat += 1
		  	else
		  		@service_bla.nat = 1
		  	end
			end

			if env.scan("DNS").size >= 1
				if @service_bla.dns
		  		@service_bla.dns += 1
		  	else
		  		@service_bla.dns = 1
		  	end
			end

			if env.scan("Botnet").size >= 1
				if @service_bla.botnet
		  		@service_bla.botnet += 1
		  	else
		  		@service_bla.botnet = 1
		  	end
			end
			if env.scan("Hosting").size >= 1
				if @service_bla.hosting
		  		@service_bla.hosting += 1
		  	else
		  		@service_bla.hosting = 1
		  	end
			end
			if env.scan("LOIC").size >= 1
				if @service_bla.loic
		  		@service_bla.loic += 1
		  	else
		  		@service_bla.loic = 1
		  	end
			end
			if env.scan("Spam").size >= 1
				if @service_bla.spam
		  		@service_bla.spam += 1
		  	else
		  		@service_bla.spam = 1
		  	end
			end
			@service_bla.save
			make_exp(5*params[:id].to_i)

			redirect_to :action => :index
		end

		if params[:task] == "add"
			#@service = ServiceStore.new name:"Spam", price:50000, exp:100000
		 	#@service.save
		 	
		end

		@services = ServiceStore.all


	end

	def pay(cash) 
		@user.money += -cash
		@user.save
	end
end
