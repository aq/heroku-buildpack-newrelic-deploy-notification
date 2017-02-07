#!/usr/bin/env ruby

require 'json'

release_version, release_user, release_description = nil, nil, nil

begin
  releases = `curl -H "Accept: application/json" -u :#{ENV['HEROKU_API_KEY']} -X GET https://api.heroku.com/apps/#{ENV['HEROKU_APP_NAME']}/releases`
  last_release = JSON.parse(releases).last
  release_version = last_release['name']
  release_user = last_release['user']
  release_description = last_release['descr']
rescue => e
  puts "Skipping releases: #{e.name} #{e.message}"
end

params = {
  deployment: {
    revision: release_version || Time.now.to_s,
    description: release_description
  }
}

cmd = <<-CMD.gsub("\s+", ' ')
curl -X POST 'https://api.newrelic.com/v2/applications/#{ENV['NEW_RELIC_APP_ID']}/deployments.json' 
     -H 'X-Api-Key:#{ENV['NEW_RELIC_LICENSE_KEY']}' -i 
     -H 'Content-Type: application/json' 
     -d 
     '#{params.to_json}'
CMD
puts cmd
system cmd
