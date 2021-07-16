# frozen_string_literal: true

namespace :db do
  namespace :schema do
    namespace :load do
      task initial: :environment do
        if ActiveRecord::Base.connection.schema_migration.table_exists?
          puts 'Schema has already been loaded. Skipping initial load.'
          Kernel.exit(0)
        end

        Rake::Task['db:schema:load'].invoke
      end
    end
  end
end
