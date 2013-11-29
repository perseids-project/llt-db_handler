namespace :db do
  namespace :prometheus do
    DUMP_FILE = 'lib/llt/db_handler/prometheus/db/prometheus_stems.dump'

    desc 'Opens a pry console with a prometheus instance preloaded as db'
    task :console do
      exec %{pry -e "require 'llt/db_handler/prometheus';
                     db = LLT::DbHandler::Prometheus.new;
                     puts 'A Prometheus instance is waiting for you in the variable db\!'; db"}
    end

    desc 'Creates the stem database'
    task :create do
      exec 'createdb -U prometheus -T template0 prometheus_stems'
    end

    desc 'Opens the psql console'
    task :db_console do
      exec 'psql -U prometheus prometheus_stems'
    end

    desc "Dumps the stem databases' contents to a psql dump file"
    task :dump do
      exec "pg_dump -U prometheus -Fc prometheus_stems > #{DUMP_FILE}"
    end

    desc 'Loads the seed data - UNDUMPED CHANGES WILL BE LOST!'
    task :seed do
      exec "pg_restore --verbose --clean --no-acl --no-owner -h localhost -U prometheus -d prometheus_stems #{DUMP_FILE}"
    end
  end
end
