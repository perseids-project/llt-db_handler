require 'spec_helper'
require 'llt/db_handler/stub'

describe LLT::DbHandler::Stub do
  let(:db_stub) { LLT::DbHandler::Stub }

  describe ".create_stem_stub" do
    it "creates a new stem stub" do
      db_stub.stems.clear
      db_stub.create_stem_stub("test", test: "val")
      db_stub.stems.should have(1).item
    end

    it "has alias create" do
      db_stub.stems.clear
      db_stub.create("test", test: "val")
      db_stub.stems.should have(1).item
    end
  end

  describe "#look_up_stem" do
    it "returns an array of db entries" do
      db_stub.create_stem_stub("test", type: :noun, nom: "rosa", stem: "ros", inflection_class: 1)
      result  = db_stub.new.look_up_stem(type: :noun, stem_type: :stem, stem: "ros", restrictions: { type: :inflection_class, values: [1] })
      result2 = db_stub.new.look_up_stem(type: :noun, stem_type: :stem, stem: "ros", restrictions: { type: :inflection_class, values: [2] })
      result.should have(1).item
      result.first.should == "test"

      result2.should be_empty
    end
  end

  describe "#direct_lookup" do
    it "returns an array of db entries" do
      db_stub.create(:success, type: :adverb, word: "ita")
      result = db_stub.new.direct_lookup(:adverb, "ita")
      result.should have(1).item
      result.first.should == :success
    end
  end

  describe ".setup" do
    it "creates stub entries as defined in stub_entries.rb" do
      db_stub.stems.clear
      db_stub.setup
      db_stub.stems.should_not be_empty
    end
  end
end
