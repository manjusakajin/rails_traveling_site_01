module TripsHelper
  def in_team? trip
    if !user_signed_in? then return false end
    participation = trip.participations.find_by user_id: current_user.id

    if participation&.join_in? then
      return true
    end
    return false
  end
end
