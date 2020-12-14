class <%= migration_class_name %> < ActiveRecord::Migration[<%= ActiveRecord::Migration.current_version %>]
  BASE_TABLE = "<%= @base_table_name %>"
  REVISIONS_TABLE = "<%= @revisions_table_name %>"
  START = "<%= @start %>"

  def up
    create_table REVISIONS_TABLE, primary_key: :source_id do |t|
      t.bigint :revision, null: false, default: START
    end
    add_foreign_key REVISIONS_TABLE, BASE_TABLE, column: :source_id

    execute <<-SQL
      CREATE OR REPLACE FUNCTION upsert_#{REVISIONS_TABLE}() RETURNS trigger
        LANGUAGE plpgsql AS
        $$BEGIN
          INSERT INTO #{REVISIONS_TABLE} AS rt (source_id, revision) values (NEW.id, #{START})
          ON CONFLICT (source_id) DO UPDATE SET revision = rt.revision + 1;
          RETURN NULL;
      END;$$;
      CREATE TRIGGER touch_#{REVISIONS_TABLE}
        AFTER INSERT OR UPDATE ON #{BASE_TABLE} FOR EACH ROW
        EXECUTE PROCEDURE upsert_#{REVISIONS_TABLE}();
    SQL

    <% targets.each do |target| %>
    add_column REVISIONS_TABLE, :<%=target%>_revision, :bigint
    add_index REVISIONS_TABLE,
              :source_id,
              where: "revision IS DISTINCT FROM <%=target%>_revision",
              name:  "index_#{REVISIONS_TABLE}_<%=target%>"

    <% end %>
  end


  def down
    execute "DROP TRIGGER touch_#{REVISIONS_TABLE} ON #{BASE_TABLE}"
    execute "DROP FUNCTION upsert_#{REVISIONS_TABLE}()"
    drop_table REVISIONS_TABLE
  end
end
