require "spec_helper"

describe DBMigrator do
  subject(:migrator) { DBMigrator.new }

  it "doesn't raise any error calling #migrate" do
    expect do
      migrator.migrate
    end.not_to raise_exception
  end
end
