require 'net/http'
require 'json'

current_valuation = 0
current_karma = 0

SCHEDULER.every '2s' do
  uri = URI.parse('https://drone.digital.homeoffice.gov.uk/api/repos/UKHomeOffice/docker-node-hello-world/builds')
  drone_results = Net::HTTP.get(uri)
  parsed_results = JSON.parse(drone_results)
  latest_builds_per_branch = get_latest_build_for_each_branch(parsed_results)

  display_text = latest_builds_per_branch.map{|b| b["branch"] + " " + b["status"]}

  send_event('welcome', {text: display_text})

  # last_valuation = current_valuation
  # last_karma     = current_karma
  # current_valuation = rand(100)
  # current_karma     = rand(200000)
  #
  # send_event('valuation', { current: current_valuation, last: last_valuation })
  # send_event('karma', { current: current_karma, last: last_karma })
  # send_event('synergy',   { value: rand(100) })
end

def get_latest_build_for_each_branch(json)
  json.group_by{|b| b['branch']}.map{|branch| branch[1].max_by{|build| build['started_at']}}
end