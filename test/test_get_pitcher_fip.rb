$: << File.expand_path(File.dirname(__FILE__) + "/../lib")

require '../lib/gameday_api/pitcher'
#require 'pitcher'
#require 'team'

# team = Team.new('cin')
# #games = team.current_year
# games = team.games_for_date('2014', '06', '19')
# games.each do |game|
# 	# starters = game.get_starting_pitchers
# 	# if game.home_team_abbrev == 'cin'
# 	# 	puts 'Home: ' + starters[1]
# 	# else
# 	# 	puts 'Visitors: ' + starters[0]
# 	# end
# 	puts game.print_linescore
# end

pitcher = GamedayApi::Pitcher.new
pitcher.load_from_id('2014_06_19_cinmlb_pitmlb_1', 430580)

puts pitcher.get_fip('season')