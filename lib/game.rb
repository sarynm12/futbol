class Game
  attr_reader :game_id,
              :season,
              :type,
              :date_time,
              :away_team_id,
              :home_team_id,
              :away_goals,
              :home_goals

  def initialize(info)
    @game_id = info[:game_id]
    @season = info[:season]
    @type = info[:type]
    @date_time = info[:date_time]
    @away_team_id = info[:away_team_id]
    @home_team_id = info[:home_team_id]
<<<<<<< HEAD
    @away_goals = info[:away_goals]
    @home_goals = info[:home_goals]
=======
    @away_goals = info[:away_goals].to_i
    @home_goals = info[:home_goals].to_i
    @venue = info[:venue]
    @venue_link = info[:venue_link]
>>>>>>> 85f7446f04d68bdd2496bec0e0b33a0c3250019c
  end
end
