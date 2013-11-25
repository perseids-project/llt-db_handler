require 'rubygems/dependency_installer'
installer = Gem::DependencyInstaller.new
begin
  if RUBY_PLATFORM == 'java'
    installer.install 'activerecord-jdbcpostgresql-adapter'
  else
    installer.install 'pg', '~> 0.15'
  end
rescue
  exit(1)
end

File.open(File.join(File.dirname(__FILE__), "Rakefile"), "w") do   # create dummy rakefile to indicate success
  f.write("task :default\n")
end
