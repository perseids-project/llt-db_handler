module LLT
  module DbHandler
    class Prometheus
      module DbToLemma
        # to be included by Db classes, the module
        # is tightly coupled to them

        def to_lemma(detailed = false)
          if detailed
            "#{base_lemma}##{number_attr}, #{category}#{str_helper(:inflectable_class, 'iclass')}#{str_helper(:sexus)}"
          else
            base_lemma
          end
        end

        private

        def category
          # DbVerb to 'verb'
          self.class.name[2..-1].downcase
        end

        def str_helper(meth, appearance = meth)
          val = guarded(meth)
          (val ? ", #{appearance}: #{val}" : '')
        end

        def base_lemma
          raise NoMethodError.new("Has to be overwritten by class that includes the module DbToLemma")
        end

        def number_attr
          guarded(:number, 1)
        end

        def guarded(meth, default_return = nil)
          if respond_to?(meth)
            send(meth)
          else
            default_return
          end
        end
      end
    end
  end
end
