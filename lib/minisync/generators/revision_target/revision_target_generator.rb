require "rails/generators/actions"
require "rails/generators/active_record"

class RevisionTargetGenerator < ActiveRecord::Generators::Base
  source_root File.expand_path("templates", __dir__)

  argument :targets, type: :array, default: [], banner: "target target"

  def create_migration_file
    @base_table_name       = normalize_table_name(ARGV[0])
    @revisions_table_name  = @base_table_name + "_revisions"
    migration_template "revision_target_migration.rb", File.join(db_migrate_path, "#{file_name}.rb")
  end

  private

  def normalize_table_name(table_name)
    (pluralize_table_names? ? table_name.pluralize : table_name.singularize).downcase
  end

  def file_name
    "add_#{targets.join("_")}_to_#{normalize_table_name(ARGV[0])}_revisions"
  end
end
