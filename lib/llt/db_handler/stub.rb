require 'llt/db_handler/common_db'

module LLT
  module DbHandler
    class Stub < CommonDb
      require 'llt/db_handler/stub/stub_entries'

      @stems = {}

      class << self
        include Helpers::Normalizer

        attr_reader :stems

        def create_stem_stub(return_val, args)
          args = normalize_args(args)
          @stems[args] = return_val
        end
        alias :create :create_stem_stub

        def setup
          StubEntries.setup
        end
      end

      def type
        :stub
      end

      def look_up_stem(args)
        super
        stems.select do |stored_args|
          if stored_args.merge(args_to_query) == stored_args
            if restr = @args[:restrictions]
              restr[:values].include?(stored_args[restr[:type]])
            end
          end
        end.values
      end

      def direct_lookup(type, string)
        args = dl_to_query(type, string)
        stems.select do |stored|
          stored.merge(args) == stored
        end.values
      end

      def dl_to_query(type, string)
        { type: type, word: string}
      end

      def args_to_query
        {type: @args[:type], @args[:stem_type] => @args[:stem] }
      end

      def stems
        self.class.stems
      end
    end
  end
end
