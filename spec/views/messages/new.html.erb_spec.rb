require 'spec_helper'

describe "/messages/new.html.erb" do
  include MessagesHelper

  before(:each) do
    assigns[:message] = stub_model(Message,
      :new_record? => true
    )
  end

  it "renders new message form" do
    render

    response.should have_tag("form[action=?][method=post]", messages_path) do
    end
  end
end
