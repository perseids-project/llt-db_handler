require 'spec_helper'

describe LLT::DbHandler::Prometheus do
  let(:db) { LLT::DbHandler::Prometheus.new }

  describe "#type" do
    it "returns :prometheus as its type" do
      db.type.should == :prometheus
    end
  end

  describe "#connect" do
    it "connects to the Prometheus ActiveRecord environment" do
      db.stub(loaded?: false)
      db.connect
      StemDatabase::Db.connection.should be_true
    end

    it "does nothing if connection is already established" do
      # actually the stub wouldn't be needed, connection status is tracked
      # on the class level atm
      db.stub(loaded?: true)
      db.should_not_receive(:load_prometheus)
      db.connect
    end
  end

  describe "#look_up_stem" do
    let(:query)  { { type: :noun, stem: "ros", stem_type: :stem} }
    let(:query2) { { type: :verb, stem: "ama", stem_type: :pr} }

    let(:failing_query) { { type: :verb, stem: "ama", stem_type: :ppp} }

    it "searches the db - with a noun" do
      db.look_up_stem(query).should_not be_empty
    end

    it "searches the db - with a verb" do
      db.look_up_stem(query2).should_not be_empty
    end

    it "returns an empty array when nothing is found" do
      db.look_up_stem(failing_query).should be_empty
    end

    # bypassing the query in the two following specs, we're only interested in the
    # conversion process

    let(:fake_entry1) do
      f = double(nom: "rosa", stem: "ros", inflectable_class: 1, sexus: "f", id: 2)
      f.stub(:type) { :noun }
      f
    end

    let(:fake_entry2) do
      f = double(nom: "rosa", stem: "ros", inflectable_class: 2, sexus: "f", id: 1)
      f.stub(:type) { :noun }
      f
    end

    it "returns stem packs" do
      db.stub(:query_db) { [fake_entry1] }

      result = db.look_up_stem(query)
      result.should have(1).item
      result.first.should be_a LLT::Stem::NounPack
    end

    it "returns only valid entries if a restriction hash is passed" do
      restrictions = { type: :inflection_class, values: [1] }
      db.stub(:query_db) { [fake_entry1, fake_entry2] }

      result = db.look_up_stem(query.merge(restrictions: restrictions))
      result.should have(1).item
      result.first.should be_a LLT::Stem::NounPack
    end
  end

  describe "#direct_lookup" do
    it "searches the db with a simplistic lookup, only a type and a string needed" do
      db.direct_lookup(:adverb, "iam").should have(1).item
    end
  end

  describe "#stats" do
    it "returns a stats object" do
      db.stats.should_not be_nil
    end
  end

  %i{ all_entries count lemma_list }.each do |delegated_method|
    describe "##{delegated_method}", :slow do
      it "is delegated to the stats object" do
        db.stats.should_receive(delegated_method)
        db.send(delegated_method)
      end
    end
  end
end
