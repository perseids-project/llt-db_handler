require 'spec_helper'
require 'llt/db_handler/prometheus/db_to_lemma'

describe LLT::DbHandler::Prometheus::DbToLemma do
  class DummyDbClass
    include LLT::DbHandler::Prometheus::DbToLemma
  end

  let(:dummy) { DummyDbClass.new }

  # private stuff, just to be safe
  describe "#number_attr" do
    it "returns the entries number attribute" do
      dummy.stub(:number) { 2 }
      dummy.send(:number_attr).should == 2
    end

    it "defaults to one when number attribute is not present" do
      dummy.send(:number_attr).should == 1
    end
  end

  describe "#base_lemma" do
    it "raises an error when the including class doesn't overwrite this method" do
      expect { dummy.send(:base_lemma) }.to raise_error NoMethodError, /overwritten/
    end

    it "returns whatever base_lemma returns when implemented by the including class" do
      dummy.stub(:base_lemma) { 1 }
      dummy.send(:base_lemma).should == 1
    end
  end

  describe "#category" do
    it "returns the category name" do
      dummy.stub_chain(:class, :name).and_return('DbSomething')
      dummy.send(:category).should == 'something'
    end
  end
end
