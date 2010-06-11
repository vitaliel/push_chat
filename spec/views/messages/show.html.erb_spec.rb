require 'spec_helper'

describe "/messages/show.html.erb" do
  include MessagesHelper
  before(:each) do
    assigns[:message] = @message = stub_model(Message)
  end

  it "renders attributes in <p>" do
    render
  end
end
