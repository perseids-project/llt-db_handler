namespace :db do
  namespace :prometheus do
    DUMP_FILE = File.expand_path('../prometheus/db/prometheus_stems.dump', __FILE__)

    desc 'Opens a pry console with a prometheus instance preloaded as db'
    task :console do
      exec %{pry -e "require 'llt/db_handler/prometheus';
                     db = LLT::DbHandler::Prometheus.new;
                     puts 'A Prometheus instance is waiting for you in the variable db\!'; db"}
    end

    desc 'Creates the stem database'
    task :create, :host do |t, args|
      host = args[:host] || 'localhost'
      exec "createdb -U prometheus -h #{host} -T template0 prometheus_stems"
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
    task :seed, :host, :options do |t, args|
      host = args[:host] || 'localhost'
      opts = args[:options]
      exec "pg_restore --verbose --clean --no-acl --no-owner -h #{host} -U prometheus -d prometheus_stems #{DUMP_FILE} #{opts}"
    end
  end
end
