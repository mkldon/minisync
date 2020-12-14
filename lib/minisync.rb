require "active_support"
require "dry-initializer"
require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.ignore("#{__dir__}/minisync/generators")
loader.ignore("#{__dir__}/minisync/railtie.rb")
loader.setup

module Minisync
end

# loader.eager_load

require "minisync/railtie" if defined?(::Rails::Railtie)
