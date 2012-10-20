class Service < ActiveRecord::Base
  attr_accessible :botnet, :dhcp, :dns, :hosting, :id, :loic, :smtp, :spam, :uid, :nat
end
