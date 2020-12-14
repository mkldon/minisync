module Minisync::Revision
  extend ActiveSupport::Concern

  included do |base|
    mattr_accessor :revision_class_name, default: "Minisync::Revision::#{base.name}"
    has_one :revision,
            class_name:  revision_class_name,
            foreign_key: :source_id,
            inverse_of:  :source,
            dependent:   :destroy

    scope :with_revision, -> {
      eager_load(:revision)
    }
    scope :without_revision, -> {
      left_outer_joins(:revision).where("#{revision_class.table_name}.source_id IS NULL")
    }
    scope :preload_revision, -> {
      preload(:revision)
    }
  end

  class_methods do
    def revision_class
      revision_class_name.constantize
    end
  end

  def revision_number
    revision.revision
  end
end
