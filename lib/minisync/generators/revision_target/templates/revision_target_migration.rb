class <%= migration_class_name %> < ActiveRecord::Migration[<%= ActiveRecord::Migration.current_version %>]
  REVISIONS_TABLE = "<%= @revisions_table_name %>"

  def up
  <% targets.each do |target| %>
  add_column REVISIONS_TABLE, :<%=target%>_revision, :bigint
  add_index REVISIONS_TABLE,
            :source_id,
            where: "revision IS DISTINCT FROM <%=target%>_revision",
            name:  "index_#{REVISIONS_TABLE}_<%=target%>"
  <% end %>
  end


  def down
  <% targets.each do |target| %>
    remove_index "index_#{REVISIONS_TABLE}_<%=target%>"
    remove_column REVISIONS_TABLE, :<%=target%>_revision
  <% end %>
  end
end
