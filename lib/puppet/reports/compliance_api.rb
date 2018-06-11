require 'json'
require 'puppet'
require 'net/http'

Puppet::Reports.register_report(:compliance_api) do
  desc "Sends reports to compliance_api"

  configfile = File.join([File.dirname(Puppet.settings[:config]), "compliance_api.yaml"])
  raise(Puppet::ParseError, "compliance_api report config file #{configfile} not readable") unless File.exist?(configfile)
  config = YAML.load_file(configfile)
  queue  = config['queue'] || 'reports'
  uri    = URI("#{config['uri']}/q/#{queue}")
  CONN   = Net::HTTP.new(uri)

  def process
    # TODO: Use certificate auth

    CONN.post("/q/#{QUEUE}", "value=#{self.to_json}")

  end
end
