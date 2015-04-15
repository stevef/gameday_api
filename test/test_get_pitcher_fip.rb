$: << File.expand_path(File.dirname(__FILE__) + "/../lib")

require '../lib/gameday_api/pitcher'

pitcher = GamedayApi::Pitcher.new
pitcher.load_from_id('2014_06_18_cinmlb_pitmlb_1', 445156)

puts pitcher.get_fip
