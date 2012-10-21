class Bot
  def self.index
  	@user = User.new name:"cron", exp:0, level:1, money:20, job:0, hdpts:1, sfpts:0
   	@user.save
  end
end
