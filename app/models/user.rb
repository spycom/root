class User < ActiveRecord::Base
  attr_accessible :id, :exp, :exp_all, :hdpts, :job, :level, :money, :name, :sfpts, :continent, :progress, :status, :karma, :cpu, :intrusion, :stockman, :menial, :sociology, :stealth, :telepresence, :memory, :storage, :power, :network, :hosts
end
