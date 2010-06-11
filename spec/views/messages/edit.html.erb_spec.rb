require 'spec_helper'

describe "/messages/edit.html.erb" do
  include MessagesHelper

  before(:each) do
    assigns[:message] = @message = stub_model(Message,
      :new_record? => false
    )
  end

  it "renders the edit message form" do
    render

    response.should have_tag("form[action=#{message_path(@message)}][method=post]") do
    end
  end
end
