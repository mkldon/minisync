class Minisync::BatchUpdater
  attr_reader :table, :target, :ids_with_revisions

  def initialize(table, target, ids_with_revisions)
    @table = table
    @ids_with_revisions = ids_with_revisions
    @target = target
  end

  def call
    return if ids_with_revisions.empty?
    table.connection.execute(update_query)
  end

  def update_query
    <<-SQL
      UPDATE #{table.table_name} AS target_table SET
        #{revision_column} = GREATEST(update_table.revision_column, #{revision_column})
      FROM (
        VALUES #{revision_values}
      ) AS update_table(source_id, revision_column)
      WHERE update_table.source_id = target_table.source_id;
    SQL
  end

  def revision_values
    ids_with_revisions.map do |id, revision|
      "(#{id}, #{revision})"
    end.join(",")
  end

  def revision_column
    "#{target}_revision"
  end
end
