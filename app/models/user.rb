class User < ActiveRecord::Base
  acts_as_authentic

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

end
