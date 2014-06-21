$: << File.expand_path(File.dirname(__FILE__) + "/../lib")

require '../lib/gameday_api/futurelinescore'
require '../lib/gameday_api/pitcher'

game = GamedayApi::FutureLineScore.new
pitcher_home = GamedayApi::Pitcher.new
pitcher_away = GamedayApi::Pitcher.new

game.load_from_id('2014_06_21_tormlb_cinmlb_1')

pitcherid = game.home_pitcher.pid
pitcher_away_id = game.away_pitcher.pid

pitcher_home.load_from_year_id(2014, pitcherid)
pitcher_away.load_from_year_id(2014, pitcher_away_id)

puts pitcher_home.fip
puts pitcher_away.fip

if pitcher_home.fip > pitcher_away.fip
	puts "Away pitcher has the advantage"
else
	puts "Home pitcher has the advantage"
end