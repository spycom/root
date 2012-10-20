class Continent < ActiveRecord::Base
  attr_accessible :name, :nodes, :power, :karma
end
