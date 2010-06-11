// defined variables
// activity_url, join_url, leave_url, publish_url

var Subscriber = function() {
  var max_retries        = 3;
  var connection_retries = 0;
  var last_modified      = null;
  var last_etag          = null;

  return {
    listen : function(opts) {
      opts = opts || {'head' : {}};
      new Ajax.Request(activity_url,
      {
        method : 'get',
        requestHeaders: opts['head'],
        onSuccess: function(transport) {
          var response = eval_json(transport.responseText);
          eval(response["type"]).show(response);
          var modified = transport.getHeader("Last-Modified");
          var etag     = transport.getHeader("Etag");
          Subscriber.listen({'head': {'If-Modified-Since': modified, 'If-None-Match': etag}});
          last_modified = modified;
          last_etag     = etag;
        },
        onFailure: function() {
          if(connection_retries == max_retries) {
            var time = new Date();
            time     = time.format("mmm dd, hh:MM TT");
            Error.show(time, "Connection imploded. Please refresh your page to try again.");
          }
          else {
            connection_retries++;
            Subscriber.listen({'head': {'If-Modified-Since': last_modified, 'If-None-Match': last_etag}});
          }
        }
      });
    }
  };
}();

var Publisher = function() {
  return {
    join : function() {
      new Ajax.Request(join_url,
      {
        method:'get',
        onFailure: function() {
          var time = new Date();
          time     = time.format("mmm dd, hh:MM TT");
          Error.show(time, "Can not join chat. Please refresh your page to try again.");
        }
      });
    },

    leave : function() {
      new Ajax.Request(leave_url, {method:'get'});
    },

    publish : function(message, random_id) {
      new Ajax.Request(publish_url,
      {
        method:'post',
        parameters: {'message' : message, 'random_id' : random_id},
        onFailure: function() {
          var time = new Date();
          time     = time.format("mmm dd, hh:MM TT");
          Error.show(time, "[" + message +"] was not delivered. Please try again");
        }
      });
    }
  };
}();

var IEFixes = function() {
  var create_trim_method = function() {
    if(!(String.prototype.trim)) {
      String.prototype.trim = function() {
        return this.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
      }
    }
  };

  return {
    init : function() {
      create_trim_method();
    }
  }
}();

document.observe("dom:loaded", function() {
  IEFixes.init();
  //Publisher.join();
  Subscriber.listen();
});

var eval_json = function(data) {
  return eval("(" + data + ")");
};

/**
* Not all browsers implement ecmascript 1.5 So they may not have trim()
* Lets check, and add our own if not.
*/
if (typeof String.prototype.trim !== 'function') {
    String.prototype.trim = function() {
        return this.replace(/^\s+|\s+$/g, '');
    }
}
