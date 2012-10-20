class Environment < ActiveRecord::Base
  attr_accessible :cpu, :id, :memory, :network, :power, :storage, :uid
end
