class EnablePgTrgmExtension < ActiveRecord::Migration[7.1]
  def up
    enable_extension 'pg_trgm' unless extension_enabled?('pg_trgm')
  end

  def down
    disable_extension 'pg_trgm'
  end
end
