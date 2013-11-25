require 'spec_helper'

describe LLT::DbHandler do
  describe ".use" do
    it "returns a new LLT db handler instance by a given type" do
      LLT::DbHandler.use(:prometheus).should be_an_instance_of LLT::DbHandler::Prometheus
    end

    it "raises an exception when the requested handler is unknown" do
      expect { LLT::DbHandler.use(:undefined_handler) }.to raise_error(ArgumentError)
    end
  end
end
