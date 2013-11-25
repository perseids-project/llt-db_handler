require 'forwardable'
require 'llt/db_handler/common_db'
require 'llt/helpers'
require 'llt/stem_builder'

module LLT
  module DbHandler
    class Prometheus < CommonDb
      extend Forwardable

      require 'llt/db_handler/prometheus/stats'

      include Helpers::Constantize
      include Helpers::PrimitiveCache

      def_delegators :stats, :all_entries, :count, :lemma_list

      def initialize(cache: false)
        @db_type = :prometheus
        enable_cache if cache
        connect
      end

      def connect
        load_prometheus unless loaded?
      end

      def load_prometheus
        begin
          require 'active_record'
          # this is where the actual connection is established
          require 'llt/db_handler/prometheus/db/models'
        rescue LoadError => e
          puts "DbHandler::Prometheus failed to connect: #{e}"
        end
      end

      def loaded?
        self.class.loaded?
      end

      def load_status(status)
        self.class.loaded = status
      end

      def direct_lookup(table, string)
        query_db(table, string)
      end

      def look_up_stem(args)
        cached(args) { new_lookup(args) }
      end

      def stats
        @stats ||= Stats.new
      end

      private

      def self.loaded?
        if defined?(StemDatabase)
          StemDatabase::Db.connection
        end
      end

      def new_lookup(args)
        table  = args[:type]
        column = args[:stem_type]
        column = (column.to_s << "_stem").to_sym if column == :pr || column == :pf
        stem   = args[:stem]
        restrictions = args[:restrictions]

        entries = query_db(table, stem, column)

        if restrictions
          restr_type = normalized(restrictions[:type])
          valids     = restrictions[:values]
          entries.keep_if { |entry| valids.include?(entry.send(restr_type)) }
        end

        stemify(entries)
      end

      def query_db(table, string, column = :word)
        # I tried to make an sql string out of this, but it's a lot slower actually...
        constant_by_type(table, prefix: :Db, namespace: StemDatabase).where(column => string)
      end

      def stemify(entries)
        entries.flat_map do |entry|
          type = entry.type
          args = case type
                 when :noun      then hashify(entry, :nom, :stem, :inflectable_class, :sexus)
                 when :persona   then hashify(entry, :nom, :stem, :inflectable_class, :sexus)
                 when :place     then hashify(entry, :nom, :stem, :inflectable_class, :sexus)
                 when :adjective then hashify(entry, :nom, :stem, :inflectable_class, :number_of_endings)
                 when :ethnic    then hashify(entry, :stem, :inflectable_class)
                 when :verb      then hashify(entry, :pr, :pf, :ppp, :inflectable_class, :pf_composition, :deponens, :dir_objs, :indir_objs)
                 end

          args ? StemBuilder.build(type, args, @db_type) : []
        end
      end

      def hashify(entry, *args)
        h = {}
        args.each { |arg| h[arg] = entry.send(arg) }
        h[:lemma_key] = entry.id
        h
      end

      def normalized(restr_type)
        case restr_type.to_sym
        when :inflection_class then :inflectable_class
        else restr_type
        end
      end
    end
  end
end
