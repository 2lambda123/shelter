class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    can :manage, :all if user.admin?

    # read: show repository on web site
    # update: change attribute of repository
    can [:pull, :read], Repository do |repo|
      repo.is_public? || repo.namespace&.users&.include?(user)
    end
    can [:push, :update, :delete], Repository do |repo|
      repo.namespace&.owners&.include?(user) || repo.namespace&.developers&.include?(user)
    end

    can :read, Namespace do |ns|
      ns.users.include? user
    end
    can [:create, :update], Namespace do |ns|
      ns.owners.include?(user)
    end
  end
end
