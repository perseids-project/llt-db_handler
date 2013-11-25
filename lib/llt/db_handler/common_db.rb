require 'llt/helpers/normalizer'

module LLT
  module DbHandler
    class CommonDb
      include Helpers::Normalizer

      require 'llt/db_handler/prometheus'

      def look_up_stem(args)
        @args = normalize_args(args)
      end
    end
  end
end
