require 'llt/db_handler/prometheus/db_to_lemma'

module StemDatabase
  class Db < ActiveRecord::Base
    self.abstract_class = true
    db = YAML::load(File.open(File.expand_path("../database.yml", __FILE__)))

    # this is generally not needed, but when deploying the app through
    # warbler and tomcat the program gets confused and wants the pg gem...
    db['adapter'].append('jdbc') if RUBY_PLATFORM == 'java'

    establish_connection(db)

    include LLT::DbHandler::Prometheus::DbToLemma

    def type
      self.class.name.match(/Db(.*)/)[1].downcase.to_sym
    end
  end

  class DbAdjective < Db
    attr_accessible :inflectable_class, :nom, :number_of_endings, :stem, :number
    validates_presence_of :nom, :stem, :number_of_endings, :inflectable_class
    validates :stem, uniqueness: { scope: %i{ nom number_of_endings inflectable_class number } }

    def base_lemma
      nom
    end
  end

  class DbAdverb    < Db
    attr_accessible :double, :word

    validates_presence_of :word
    validates :word, uniqueness: true

    def base_lemma
      word
    end
  end

  class DbEthnic    < Db
    attr_accessible :inflectable_class, :stem
    validates_presence_of :stem, :inflectable_class
    validates :stem, uniqueness: { scope: :inflectable_class }

    def base_lemma
      "#{stem}#{lemma_ending}"
    end

    private

    def lemma_ending
      case inflectable_class
      when 1 then 'us'
      when 3 then 'is'
      end
    end
  end

  class DbPersona   < Db
    attr_accessible :defective, :inflectable_class, :nom, :sexus, :stem
    validates_presence_of :stem, :inflectable_class
    validates :stem, uniqueness: { scope: %i{ nom inflectable_class sexus } }

    def base_lemma
      nom
    end
  end

  class DbPlace     < Db
    attr_accessible :defective, :inflectable_class, :nom, :sexus, :stem
    validates_presence_of :stem, :inflectable_class
    validates :stem, uniqueness: { scope: %i{ nom inflectable_class sexus } }

    def base_lemma
      nom
    end
  end

  class DbNoun      < Db
    attr_accessible :defective, :inflectable_class, :nom, :sexus, :stem
    validates_presence_of :stem, :inflectable_class
    validates :stem, uniqueness: { scope: %i{ nom inflectable_class sexus } }

    def base_lemma
      nom
    end
  end

  class DbVerb      < Db
    attr_accessible :pr_stem, :pf_stem, :ppp, :inflectable_class, :dir_objs,
                    :indir_objs, :deponens, :number
    validates_presence_of :pr_stem, :inflectable_class
    validates :pr_stem, uniqueness: { scope: %i{ pf_stem ppp deponens inflectable_class } }

    def pr; pr_stem; end
    def pf; pf_stem; end
    def extension; tempus_sign; end

    def base_lemma
      "#{lemma_stem}#{lemma_ending}"
    end

    private

    def lemma_stem
      inflectable_class == 1 ? pr_stem.chop : pr_stem
    end

    def lemma_ending
      ending = inflectable_class == 5 ? 'io' : 'o'
      deponens ? (ending + 'r') : ending
    end
  end
end
