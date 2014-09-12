// Generated by CoffeeScript 1.8.0
var Client, CozyInstance, async;

async = require('async');

Client = require('request-json').JsonClient;

CozyInstance = require('../models/cozy_instance');

module.exports.main = function(req, res, next) {
  return async.parallel([
    function(cb) {
      return CozyInstance.getLocale(cb);
    }, function(cb) {
      var dataSystem;
      dataSystem = new Client("http://localhost:9101/");
      return dataSystem.get('tags', function(err, response, body) {
        err = err || body.error;
        return cb(err, body);
      });
    }
  ], (function(_this) {
    return function(err, results) {
      var locale, tags;
      if (err) {
        return next(err);
      } else {
        locale = results[0], tags = results[1];
        return res.render('index.jade', {
          imports: "window.locale = \"" + locale + "\";\nwindow.tags = \"" + tags + "\".split(',');"
        });
      }
    };
  })(this));
};
