require 'csv'
class Road < ActiveRecord::Base
  store_accessor :json_store, :source, :destination

  def self.create_from_csv
    data = CSV.read("coimbtr_rd.csv")
    data.each do |row|
      Road.create(name: row[2], width: row[3], length: row[4])
    end
    road = Road.find(3586)
    road.source = "11.001481,76.962722"
    road.destination =  "10.994353,76.967031"
    road.save
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


  def travel_time
    if source.blank?
      return ["#{Random.rand(10)} mins", "#{Random.rand(10)} mins"]
    end

    Road.travel_time(source,destination, "AIzaSyA1g5auAN12CDpfRMWEC8y8yfbSK29fvUA")
  end

  def all_data
    lanes = get_lanes
    times_raw = travel_time
    times = times_raw.map(&:to_i)
    upstream_lanes = (times[0].to_f*lanes/times.sum.to_f).round
    downstream_lanes = lanes - upstream_lanes
    return {suggested_lanes: [upstream_lanes, downstream_lanes], timings: times_raw}
  end

  def get_suggested_lanes
    return all_data[:suggested_lanes]
  end


end
