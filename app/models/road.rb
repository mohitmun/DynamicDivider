require 'csv'
class Road < ActiveRecord::Base


  def self.create_from_csv
    data = CSV.read("coimbtr_rd.csv")
    data.each do |row|
      Road.create(name: row[2], width: row[3], length: row[4])
    end
  end
  STD_CAR_WIDTH = 1.6

  def self.travel_time(source, destination, key)
    source = source.gsub(" ", "+")
    destination = destination.gsub(" ", "+")
    res1 = `curl "https://maps.googleapis.com/maps/api/directions/json?origin=#{source}&destination=#{destination}&key=#{key}&departure_time=#{Time.now.to_i}"`
    upstream = JSON.parse(res1).routes.last.legs.last.duration_in_traffic.text
    res2 = `curl "https://maps.googleapis.com/maps/api/directions/json?origin=#{destination}&destination=#{source}&key=#{key}&departure_time=#{Time.now.to_i}"`
    downstream = JSON.parse(res2).routes.last.legs.last.duration_in_traffic.text
    return [upstream, downstream]
  end

  def get_lanes
    lanes = width/STD_CAR_WIDTH
    lanes = lanes.floor
  end

  def self.get_lanes_for_goodshed_road()
    s = "11.001481,76.962722"
    d = "10.994353,76.967031"
    road = Road.find(3586)
    lanes = road.get_lanes
    times = travel_time(s,d, "AIzaSyA1g5auAN12CDpfRMWEC8y8yfbSK29fvUA")
    times = times.map(&:to_i)
    upstream_lanes = times[0]*lanes/times.sum
    downstream_lanes = lanes - upstream_lanes
    return [upstream_lanes, downstream_lanes]
  end


end
