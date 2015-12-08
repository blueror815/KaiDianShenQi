class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= Employee.new

    if user.user_type == 'Owner'
      can :manage, :all
    else
      Employee::PERMISSION_MODULES.each do |permission_module|
        can :manage, eval(permission_module) if user.can_access?(permission_module, 'can_manage')
      end
    end
  end
end
