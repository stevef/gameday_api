$: << File.expand_path(File.dirname(__FILE__) + "/../lib")

require '../lib/gameday_api/futurelinescore'
require '../lib/gameday_api/pitcher'

game = GamedayApi::FutureLineScore.new
pitcher = GamedayApi::Pitcher.new

game.load_from_id('2014_06_21_tormlb_cinmlb_1')

pitcherid = game.home_pitcher.pid

puts pitcher.load_from_year_id(2014, 502190)