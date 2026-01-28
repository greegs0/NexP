class AddSearchFieldsToSkills < ActiveRecord::Migration[7.1]
  def change
    add_column :skills, :aliases, :text, array: true, default: []
    add_column :skills, :users_count, :integer, default: 0
    add_column :skills, :popularity_score, :integer, default: 0

    add_index :skills, :users_count
    add_index :skills, :popularity_score

    # Index trigram pour fuzzy search
    execute <<-SQL
      CREATE INDEX index_skills_on_name_trgm ON skills USING gin (name gin_trgm_ops);
    SQL
  end
end
