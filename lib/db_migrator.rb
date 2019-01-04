class DBMigrator
  def initialize(db)
    @db = db
    @migrations = []
  end

  def migrate
    @db.connect
    @migrations.each_with_index do |m, i|
      next unless @db.exec("INSERT INTO migrations (id) VALUES '#{i + 1}';") == :success
      @db.exec(m)
    end
    @db.close_connection
  end

  def add_migration(migration)
    @migrations << String(migration)
  end
end
