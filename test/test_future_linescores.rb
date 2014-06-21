$: << File.expand_path(File.dirname(__FILE__) + "/../lib")

require '../lib/gameday_api/futurelinescore'

game = GamedayApi::FutureLineScore.new

game.load_from_id('2014_06_21_tormlb_cinmlb_1')

puts game.home_pitcher.pid