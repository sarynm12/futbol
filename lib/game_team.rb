require 'csv'
require_relative './helpable'

class GameTeam
  include Helpable

  attr_reader :game_id,
              :team_id,
              :hoa,
              :result,
              :settled_in,
              :head_coach,
              :goals,
              :shots,
              :tackles
  @@all_game_teams = []

  attr_accessor :season

  def initialize(data)
    @game_id = data[:game_id]
    @team_id = data[:team_id]
    @hoa = data[:hoa]
    @result = data[:result]
    @settled_in = data[:settled_in]
    @head_coach = data[:head_coach]
    @goals = data[:goals].to_i
    @shots = data[:shots].to_i
    @tackles = data[:tackles].to_i
    @season = nil
  end

  def generate_season(game_id)
    "#{game_id.slice(0, 4)}#{(game_id.slice(0, 4)).to_i + 1}"
  end

  def self.create(game_team_path)
    CSV.foreach(game_team_path, headers: true, header_converters: :symbol) do |row|
      game_team = GameTeam.new(row.to_h)
      @@all_game_teams << game_team
      game_team.season = game_team.generate_season(game_team.game_id)
    end
  end

  def self.all 
    @@all_game_teams
  end 

  def self.total_home_wins
    @@all_game_teams.find_all do |game_team|
      game_team.hoa == "home" && game_team.result == "WIN"
    end.size
  end

  def self.total_goals_per_team_for_season(season_id)
    @@all_game_teams.reduce(Hash.new(0)) do |result, game_team|
      result[game_team.team_id] += game_team.goals if game_team.season == season_id
      result
    end
  end

  def self.total_shots_per_team_for_season(season_id)
    @@all_game_teams.reduce(Hash.new(0)) do |result, game_team|
      result[game_team.team_id] += game_team.shots if game_team.season == season_id
      result
    end
  end

  def self.shots_to_goals_ratio_per_team_for_season(season_id)
    total_shots_per_team_for_season(season_id).merge(total_goals_per_team_for_season(season_id)){|team_id, shots, goals| (goals == 0) ? 0 : (shots.to_f / goals).round(3)}
  end

  def self.game_teams_by_coach_for_season(season_id)
    @@all_game_teams.reduce(Hash.new { |h,k| h[k] = [] }) do |result, game_team|
      result[game_team.head_coach] << game_team if game_team.season == season_id
      result
    end
  end

  def self.number_of_games_by_coach_for_season(season_id)
    game_teams_by_coach_for_season(season_id).transform_values do |game_teams|
      game_teams.length
    end
  end

  def self.find_all_wins_by_coach_for_season(season_id)
    game_teams_by_coach_for_season(season_id).transform_values do |game_teams|
      (game_teams.find_all {|game| game.result == "WIN"}).length
    end
  end

  def self.percent_wins_by_coach_for_season(season_id)
     find_all_wins_by_coach_for_season(season_id).merge(number_of_games_by_coach_for_season(season_id)) do |head_coach, wins, games|
      (wins.to_f / games).round(2)
    end
  end

  def self.winningest_coach(season_id)
    percent_wins_by_coach_for_season(season_id).max_by do |coach, percent_wins|
      percent_wins
    end[0]
  end

  def self.worst_coach(season_id)
    percent_wins_by_coach_for_season(season_id).min_by do |coach, percent_wins|
      percent_wins
    end[0]
  end

  def self.goals_per_game_per_team
    @@all_game_teams.reduce(Hash.new { |h,k| h[k] = [] }) do |result, game_team|
      result[game_team.team_id] << game_team.goals
      result
    end
  end

  def self.games_won_per_team_for_season(season_id)
    @@all_game_teams.reduce(Hash.new(0)) do |result, game_team|
      result[game_team.team_id] += 1 if game_team.season == season_id &&  game_team.result == "WIN"
      result
    end
  end

  def self.total_games_per_team_per_season(season_id)
    @@all_game_teams.reduce(Hash.new(0)) do |result, game_team|
      result[game_team.team_id] += 1 if game_team.season == season_id
      result
    end
  end
end