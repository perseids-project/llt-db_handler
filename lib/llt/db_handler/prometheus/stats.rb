module LLT
  module DbHandler
    class Prometheus
      class Stats
        include Enumerable

        CATEGORIES = %i{ noun adjective adverb verb persona ethnic place }
        TABLES = CATEGORIES.map { |cat| cat.to_s.capitalize.prepend('Db').to_sym }

        def count
          @count ||= compute_count
        end

        def all_entries
          @all_entries ||= flat_map(&:all)

          if block_given?
            @all_entries.map { |entry| yield(entry) }
          else
            @all_entries
          end
        end

        def lemma_list(detailed = false)
          all_entries.map { |entry| entry.to_lemma(detailed) }
        end

        private

        def compute_count
          map(&:count).inject(:+)
        end

        def each(&blk)
          TABLES.map { |table| as_const(table) }.each(&blk)
        end

        def as_const(symbol)
          StemDatabase.const_get(symbol)
        end
      end
    end
  end
end
