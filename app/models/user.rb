# == Schema Information
# Schema version: 20100830153925
#
# Table name: users
#
#  id                :integer(4)      not null, primary key
#  created_at        :datetime        
#  updated_at        :datetime        
#  login             :string(255)     not null
#  crypted_password  :string(255)     not null
#  password_salt     :string(255)     not null
#  persistence_token :string(255)     not null
#  login_count       :integer(4)      default(0), not null
#  last_request_at   :datetime        
#  last_login_at     :datetime        
#  current_login_at  :datetime        
#  last_login_ip     :string(255)     
#  current_login_ip  :string(255)     
#  active            :boolean(1)      not null
#  perishable_token  :string(255)     not null
#  email             :string(255)     not null
#

class User < ActiveRecord::Base
  acts_as_authentic
  has_friendly_id :login, :use_slug => true

  def activate!
    self.active = true
    save
  end

  def deliver_activation_instructions!
    reset_perishable_token!
    Notifier.deliver_activation_instructions(self)
  end

  def deliver_welcome!
    reset_perishable_token!
    Notifier.deliver_welcome(self)
  end

  def is_admin?
    true  ## making it true for development, will be changed later
    not global_admin.blank?
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!  
    Notifier.deliver_password_reset_instructions(self)
  end
end
