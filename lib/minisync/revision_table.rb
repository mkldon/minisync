module Minisync::RevisionTable
  extend ActiveSupport::Concern

  included do
    scope :unsynced, ->(target) { where("revision IS DISTINCT FROM #{target}_revision") }
  end
end
