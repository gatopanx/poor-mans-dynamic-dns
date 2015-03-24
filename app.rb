#!/usr/bin/env ruby
require 'aws-sdk'

# Poor man's dynamic dns
# requires env vars:
# - AWS_REGION
# - AWS_ACCESS_KEY_ID
# - AWS_SECRET_ACCESS_KEY
# - DOMAIN
# - SUBDOMAIN

domain = ENV["DOMAIN"]
subdomain = ENV["SUBDOMAIN"]

full_subdomain = "#{subdomain}.#{domain}"
current_public_ip = `curl http://whatismyip.akamai.com 2>/dev/null`

r53 = Aws::Route53::Client.new

hosted_zones = r53.list_hosted_zones.hosted_zones
target_hosted_zone = hosted_zones.select{ |hz| hz.name == "#{domain}." }.first

resource_record_sets = r53.list_resource_record_sets(hosted_zone_id: target_hosted_zone.id).resource_record_sets
target_resource_record_set = resource_record_sets.select{|rrs| rrs.name == "#{full_subdomain}."}.first

last_known_ip = target_resource_record_set.resource_records.first.value

unless current_public_ip == last_known_ip
  change = {
    :action => 'UPSERT',
    :resource_record_set => {
      :name => full_subdomain,
      :type => "A",
      :ttl => 60,
      :resource_records => [{:value => current_public_ip}]
  }}

  r53.change_resource_record_sets({
    :hosted_zone_id => target_hosted_zone.id,
    :change_batch => {
      :changes => [change]
    }
  })
end
