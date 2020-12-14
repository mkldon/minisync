module Minisync
  class Railtie < Rails::Railtie
    generators do
      require "minisync/generators/revision_table/revision_table_generator"
      require "minisync/generators/revision_target/revision_target_generator"
    end
  end
end
