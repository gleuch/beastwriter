
require 'yaml'

# jdubs simple magma dump stuff..
# FIXME: should grab application name dynamically
namespace :db do
  namespace :migrate do
    desc "Rollback the database schema to the previous version"
    task :rollback => :environment do
      ActiveRecord::Migrator.rollback("db/migrate/", 1)
    end
  end
end