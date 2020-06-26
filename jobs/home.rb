require 'pg'

# db_conn = PGconn.connect( :hostaddr=>"192.168.1.124", :port=>5432, :dbname=>"weather_data", :user=>"postgres", :password=>'')
db_conn = PG::Connection.open( :hostaddr=>"192.168.1.124", :port=>5432, :dbname=>"weather_station", :user=>"postgres", :password=>'')

# :first_in sets how long it takes before the job is first run. In this case, it is run immediately

SCHEDULER.every '5s', :first_in => 0 do |job|
  # wind_speed = rand(400)
  data = db_conn.exec("SELECT * FROM weather_data ORDER BY date DESC LIMIT 1")

  wind_speed = data[0]["speed"]
  wind_direction = data[0]["direction"]
  rain_qty = data[0]["rain_qty"]

  puts wind_speed
  puts wind_direction
  puts rain_qty

  send_event('wind_speed', { value: wind_speed })
  send_event('wind_direction', { value: wind_direction })
  send_event('rain_qty', { value: rain_qty })
end