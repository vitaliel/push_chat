class MessagesController < ApplicationController

  # GET /messages
  # GET /messages.xml
  def index
    @messages = Message.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @messages }
    end
  end

  # POST /messages
  # POST /messages.xml
  def create
    message = {:msg => params[:message], :type => "Chat"}

    publisher_path = request.protocol + request.host_with_port + "/publish" + "?id=1"
    logger.debug publisher_path

    url          = URI.parse(publisher_path)
    http         = Net::HTTP.new(url.host, url.port)
    req      = Net::HTTP::Post.new(url.path + "?" + url.query)
    req.body = message.to_json
    resp = http.request(req)
    logger.debug resp.body.inspect

    render :action => 'message'
  end
end
