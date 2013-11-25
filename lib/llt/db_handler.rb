require "llt/db_handler/version"
require 'llt/db_handler/common_db'

module LLT
  module DbHandler
    def self.use(db)
      db = db.capitalize
      raise ArgumentError, "No database handler called #{db} defined" unless const_defined?(db)
      const_get(db.capitalize).new
    end
  end
end
