require "shellwords"
require "figaro/env"
require "figaro/railtie"
require "figaro/tasks"

module Figaro
  extend self

  def vars(custom_environment = nil, file = nil)
    env(custom_environment, file).map { |key, value|
      "#{key}=#{Shellwords.escape(value)}"
    }.sort.join(" ")
  end

  def env(custom_environment = nil, file = nil)
    environment = (custom_environment || self.environment).to_s
    Figaro::Env.from(stringify(flatten(raw(file)).merge(raw.fetch(environment, {}))))
  end

  def raw(file = nil)
    @raw ||= yaml(file) && YAML.load(yaml(file)) || {}
  end

  def yaml(file = nil)
    @yaml ||= File.exist?(path(file)) ? ERB.new(File.read(path(file))).result : nil
  end

  def path(file)
    file ||= "application.yml"
    @path ||= Rails.root.join("config", file)
  end

  def environment
    Rails.env
  end

  private

  def flatten(hash)
    hash.reject { |_, v| Hash === v }
  end

  def stringify(hash)
    hash.inject({}) { |h, (k, v)| h[k.to_s] = v.nil? ? nil : v.to_s; h }
  end
end
