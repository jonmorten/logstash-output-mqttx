Gem::Specification.new do |s|
  s.name = "logstash-output-mqttx"
  s.version = "1.0.0"
  s.licenses = ["Apache-2.0"]
  s.summary = "This is Logstash output plugin for the http://mqtt.org/[MQTT] protocol"
  s.description = "This gem is a plugin for Logstash, and is not a stand-alone program."
  s.authors = ["Jon-Morten Kristiansen"]
  s.email = "jon.morten.kristiansen@gmail.com"
  s.homepage = "https://github.com/jonmorten/logstash-output-mqttx"
  s.require_paths = ["lib"]

  # Files
  s.files = Dir['lib/**/*','spec/**/*','vendor/**/*','*.gemspec','*.md','Gemfile','LICENSE']
  
  # Tests
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  # Special flag to let us know this is actually a logstash plugin
  s.metadata = {
    "logstash_plugin" => "true",
    "logstash_group" => "output"
  }

  # Gem dependencies
  s.add_runtime_dependency "logstash-core-plugin-api", "~> 2.0"
  s.add_runtime_dependency "mqtt", "~> 0.7.0"
  # Do NOT pin logstash-codec-json.
  # Logstash ships and manages its own codec versions.
  # Pinning here can cause version conflicts inside the Logstash runtime.
  s.add_runtime_dependency "logstash-codec-json"

  s.add_development_dependency "logstash-devutils"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rubocop"
end
