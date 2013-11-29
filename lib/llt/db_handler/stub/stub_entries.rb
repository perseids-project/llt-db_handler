require 'ostruct'

class LLT::DbHandler::Stub::StubEntries
  class << self
    def setup(size = :medium)
      db_stub.stems.clear

      medium_setup
      # not implemented yet
      #case size
      #when :big   then big_setup
      #when :small then small_setup
      #else medium_setup
      #end
    end

    private

    def small_setup
    end

    def medium_setup
      wsr(type: :noun,      nom: "homo",      stem: "homin",      itype: 3, sexus: :m)
      wsr(type: :noun,      nom: "vir",       stem: "vir",        itype: 2, sexus: :m)
      wsr(type: :noun,      nom: "ratio",     stem: "ration",     itype: 3, sexus: :f)
      wsr(type: :noun,      nom: "magnitudo", stem: "magnitudin", itype: 3, sexus: :f)
      wsr(type: :noun,      nom: "libido",    stem: "libidin",    itype: 3, sexus: :f)
      wsr(type: :noun,      nom: "nox",       stem: "noct",       itype: 3, sexus: :f)
      wsr(type: :noun,      nom: "filius",    stem: "fili",       itype: 2, sexus: :m)
      wsr(type: :noun,      nom: "servus",    stem: "serv",       itype: 2, sexus: :m)

      wsr(type: :noun,      nom: "flumen",    stem: "flumin",     itype: 3, sexus: :n)
      wsr(type: :noun,      nom: "arma",      stem: "arm",        itype: 2, sexus: :n) # this might actually be wrong?

      wsr(type: :persona,   nom: "Plato",     stem: "Platon",     itype: 3)
      wsr(type: :persona,   nom: "Solon",     stem: "Solon",      itype: 3)

      wsr(type: :adjective, nom: "communis",  stem: "commun",     itype: 3, number_of_endings: 1)
      wsr(type: :adjective, nom: "diligens",  stem: "diligent",   itype: 3, number_of_endings: 1)
      wsr(type: :adjective, nom: "laetus",    stem: "laet",       itype: 1, number_of_endings: 3)
      wsr(type: :adjective, nom: "ferus",     stem: "fer",        itype: 1, number_of_endings: 3)

      wsr(type: :adjective, nom: "aestivus",  stem: "aestiv",     itype: 1, number_of_endings: 3)
      wsr(type: :adjective, nom: "suavis",    stem: "suav",       itype: 3, number_of_endings: 2)


      wsr(type: :ethnic, stem: "Haedu", inflection_class: 1)
      wsr(type: :ethnic, stem: "Redon", inflection_class: 3)

      wsr(type: :verb, pr: "ita",   pf: "itav",                 pf_composition: "v", itype: 1, dep: false, dir_objs: "", indir_objs: "")
      wsr(type: :verb, pr: "cana",  pf: "canav", ppp: "canat",  pf_composition: "v", itype: 1, dep: false, dir_objs: "", indir_objs: "")
      wsr(type: :verb, pr: "mone",  pf: "monu",  ppp: "monit",  pf_composition: "u", itype: 2, dep: false, dir_objs: "", indir_objs: "")
      wsr(type: :verb, pr: "move",  pf: "movi",  ppp: "mot",    pf_composition: "ablaut", itype: 2, dep: false, dir_objs: "", indir_objs: "")
      wsr(type: :verb, pr: "mitt",  pf: "mis",   ppp: "miss",   pf_composition: "s", itype: 3, dep: false, dir_objs: "", indir_objs: "")
      wsr(type: :verb, pr: "viv",   pf: "vix",   ppp: "-",      pf_composition: "s", itype: 3, dep: false, dir_objs: "", indir_objs: "")
      wsr(type: :verb, pr: "audi",  pf: "audiv", ppp: "audit",  pf_composition: "v", itype: 4, dep: false, dir_objs: "", indir_objs: "")
      wsr(type: :verb, pr: "horta",              ppp: "hortat",                      itype: 1, dep: true , dir_objs: "", indir_objs: "")

      dl(type: :adverb, word: "ita")
      dl(type: :adverb, word: "iam")
      dl(type: :adverb, word: "subito")
    end

    def big_setup
    end

    def db_stub
      LLT::DbHandler::Stub
    end

    def factory(type, args)
      LLT::StemBuilder.build(type, args, "stub")
    end

    # with_single_return
    def wsr(args)
      ret_val = factory(args[:type], args.reject { |k, _| k == :type })
      db_stub.create(ret_val, args)
    end

    # direct_lookup
    def dl(args)
      ret_val = OpenStruct.new(word: args[:word])
      db_stub.create(ret_val, args)
    end
  end
end
