# Logstash MQTT Output Plugin

This is an output plugin for [Logstash](https://github.com/elastic/logstash).

## Installation

Build the plugin for offline use as described below.

Then, in Logstash's home directory:

```
bin/logstash-plugin install file:///plugin/pkg/logstash-output-mqttx-8.9.0.zip
```

## Usage

See [mqtt.rb](lib/logstash/outputs/mqtt.rb) file for plugin usage.

## Development setup (macOS)

This plugin targets **Logstash 8.9.0** as shipped in
`opensearchproject/logstash-oss-with-opensearch-output-plugin:8.9.0`,  
which runs:

- **JRuby 9.3.10.0 (Ruby 2.6.8)**
- **Java 17**

Your local development environment should match these versions.

### 1. Install Java 17

```bash
brew install openjdk@17
```

### 2. Install rbenv

```bash
brew install rbenv
```

Initialize rbenv:

```bash
echo 'eval "$(rbenv init - bash)"' >> ~/.bashrc

# For zsh:
echo 'eval "$(rbenv init - zsh)"' >> ~/.zshrc
```

Run `exec $SHELL -l` or restart your terminal.

### 3. Install JRuby 9.3.10.0

```bash
rbenv install jruby-9.3.10.0
rbenv local jruby-9.3.10.0
```

Verify:

```bash
ruby -v
# => jruby 9.3.10.0 (ruby 2.6.8)
```

### 4. Install Bundler and dependencies

```bash
gem install bundler
bundle install
```

### 5. Build the plugin

```bash
docker run --rm -it \
  -v "$PWD":/plugin \
  -w /plugin \
  -e JAVA_HOME=/usr/share/logstash/jdk \
  -e JAVA_OPTS="--add-opens=java.base/java.security=ALL-UNNAMED" \
  opensearchproject/logstash-oss-with-opensearch-output-plugin:8.9.0 \
  bash -lc '
    set -e
    mkdir -p pkg
    /usr/share/logstash/vendor/jruby/bin/jruby -S gem build logstash-output-mqttx.gemspec
    mv logstash-output-mqttx-*.gem pkg/
  '
```

### 6. Bundle for install

```bash
docker run --rm -it \
  -v "$PWD":/plugin \
  opensearchproject/logstash-oss-with-opensearch-output-plugin:8.9.0 \
  bash -lc '
    set -e
    export JAVA_HOME=/usr/share/logstash/jdk

    # 1. Install Gem, let Logstash pull dependencies
    bin/logstash-plugin install /plugin/pkg/logstash-output-mqttx-*.gem

    # 2. Sanity check install
    bin/logstash-plugin list --verbose | grep mqtt

    # 3. Build an offline plugin pack that includes logstash-output-mqttx and deps
    bin/logstash-plugin prepare-offline-pack \
      --overwrite \
      --output /plugin/pkg/logstash-output-mqttx-8.9.0.zip \
      logstash-output-mqttx
  '
```

### 7. Test install

```bash
docker run --rm -it \
  -v "$PWD":/plugin \
  opensearchproject/logstash-oss-with-opensearch-output-plugin:8.9.0 \
  bash -lc '
    set -e
    export JAVA_HOME=/usr/share/logstash/jdk

    bin/logstash-plugin install file:///plugin/pkg/logstash-output-mqttx-8.9.0.zip
    bin/logstash-plugin list --verbose | grep mqtt
  '
```

### 8. Run a test pipeline

```bash
docker run --rm -it \
  -v "$PWD:/plugin" \
  -v "$PWD/test/pipeline.conf:/pipeline.conf" \
  -v "$PWD/test/pipelines.yml:/usr/share/logstash/config/pipelines.yml" \
  opensearchproject/logstash-oss-with-opensearch-output-plugin:8.9.0 \
  bash -lc "
    set -e
    export JAVA_HOME=/usr/share/logstash/jdk
    bin/logstash-plugin install file:///plugin/pkg/logstash-output-mqttx-8.9.0.zip
    bin/logstash
  "
```
