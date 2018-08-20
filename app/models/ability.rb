class Ability
  include CanCan::Ability

  def initialize user
    can :read, Review
    if user.present?
      can :update, User, id: user.id
      can :manage, Review, user_id: user.id
      can :manage, Comment, user_id: user.id
      can :manage, Trip, user_id: user.id
      can :read, Trip 
      can :destroy, Participation, user_id: user.id
      cannot :destroy, Participation do |participation|
        participation.trip.owner == participation.user
      end
      if user.admin?
        can :manage, :all
        cannot :destroy, User, id: user.id
      end
    end
  end
end
