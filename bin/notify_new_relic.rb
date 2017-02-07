#!/usr/bin/env ruby

require 'json'

release_version, release_user, release_description = nil, nil, nil

env_dir = ENV['ENV_DIR']
puts env_dir
puts Dir.glob("#{env_dir}/*").inspect
heroku_api_key = `cat #{env_dir}/HEROKU_API_KEY`
heroku_app_name = `cat #{env_dir}/HEROKU_APP_NAME`
new_relic_license_key = `cat #{env_dir}/NEW_RELIC_LICENSE_KEY`
new_relic_app_id = `cat #{env_dir}/NEW_RELIC_APP_ID`

begin
  cmd = "curl -s -H \"Accept: application/json\" -u :#{heroku_api_key} -X GET https://api.heroku.com/apps/#{heroku_app_name}/releases"
  puts cmd
  releases = %x(#{cmd})
  last_release = JSON.parse(releases).last
  release_version = last_release['name']
  release_user = last_release['user']
  release_description = last_release['descr']
rescue => e
  puts "Skipping releases: #{e.class.name} #{e.message}"
end

params = {
  deployment: {
    revision: release_version || Time.now.to_s,
    description: release_description
  }
}

cmd = <<-CMD.gsub("\s+", ' ')
curl -X POST 'https://api.newrelic.com/v2/applications/#{new_relic_app_id}/deployments.json' 
     -H 'X-Api-Key:#{new_relic_license_key}' -i 
     -H 'Content-Type: application/json' 
     -d 
     '#{params.to_json}'
CMD
puts cmd
system cmd
