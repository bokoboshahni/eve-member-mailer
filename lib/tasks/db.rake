# frozen_string_literal: true

namespace :db do
  namespace :migrate do
    task :helm do
      begin
        Rake::Task['db:migrate'].invoke
      rescue ActiveRecord::NoDatabaseError
        puts 'Database does not exist yet. Run db:schema:load after PostgreSQL is ready.'
      end
    end
  end
end
