require "spec_helper"

describe DBMigrator do
  subject(:migrator) { DBMigrator.new(db) }

  let(:db) do
    instance_double(
      "db",
      connect: :success,
      close_connection: :success,
      exec: :success,
    )
  end

  it "doesn't raise any error calling #migrate" do
    expect do
      migrator.migrate
    end.not_to raise_exception
  end

  it "doesn't raise any error adding migration" do
    expect do
      migrator.add_migration("migration")
    end.not_to raise_exception
  end

  it "applies added migrations on DB" do
    migrator.add_migration("migration 1")
    migrator.add_migration("migration 2")
    migrator.migrate

    expect(db).to have_received(:exec).with("INSERT INTO migrations (id) VALUES '1';")
    expect(db).to have_received(:exec).with("migration 1")
    expect(db).to have_received(:exec).with("INSERT INTO migrations (id) VALUES '2';")
    expect(db).to have_received(:exec).with("migration 2")
  end

  it "invokes only not created migrations" do
    allow(db).to receive(:exec).with("INSERT INTO migrations (id) VALUES '1';").and_return :record_already_exists

    migrator.add_migration("migration 1")
    migrator.add_migration("migration 2")
    migrator.migrate

    expect(db).to have_received(:exec).with("INSERT INTO migrations (id) VALUES '1';")
    expect(db).not_to have_received(:exec).with("migration 1")
    expect(db).to have_received(:exec).with("INSERT INTO migrations (id) VALUES '2';")
    expect(db).to have_received(:exec).with("migration 2")
  end
end
