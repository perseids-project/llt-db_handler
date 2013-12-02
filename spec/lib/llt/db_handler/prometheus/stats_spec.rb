require 'spec_helper'

describe LLT::DbHandler::Prometheus::Stats do
  let(:stats) { LLT::DbHandler::Prometheus::Stats.new }

  describe "#count" do
    it "returns the total number of db entries" do
      stats.count.should be_kind_of Fixnum
    end

    it "returns the number 40000+ entries" do
      # stupid to test a concrete count, but let it scream
      # if we have strangly few entries
      stats.count.should > 40000
    end
  end

  describe "#all_entries", :slow do
    it "returns an Array of all db objects" do
      stats.all_entries.should be_kind_of Array
    end

    it "takes a block to be executed on each entry" do
      mapped_entries = stats.all_entries { |entry| entry.kind_of?(Object)}
      uniq_for_easier_test = mapped_entries.uniq
      uniq_for_easier_test.should have(1).item
      uniq_for_easier_test.first.should be_true
    end
  end

  describe "#lemma_list", :slow do
    let(:lemma_list_entry)  { stats.lemma_list.first}
    let(:lemma_format) { '\p{L}[a-z]*' }

    it "returns an Array of lemma strings" do
      stats.lemma_list.count.should == stats.count
    end

    it "lemmas are represented with their base form" do
      stats.lemma_list.first.should =~ /^#{lemma_format}$/
    end

    it "returns a more detailed lemma string with a truthy param" do
      stats.lemma_list(true).first.should =~ /^#{lemma_format}#\d.+$/
    end
  end
end
