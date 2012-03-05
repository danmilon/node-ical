var Element = require('./element').Element
  , util    = require('util')
  , Event   = require('./event').Event

var DELIM = '\r\n'

function Calendar(data) {
  this.prodid = data.prodid
  this.version = data.version || '2.0'
  this.events = data.events
}

util.inherits(Calendar, Element)

Calendar.prototype.addEvent = function (event) {
  this.events.push(event)
}

Calendar.prototype.toICal = function () {
  var x = 'BEGIN:VCALENDAR' + DELIM
  for (var k in this) {
    if (this.hasOwnProperty(k)) {
      var prop = this[k]
      debugger
      if (Array.isArray(prop)) {
        for (var i = 0; i < prop.length; i++) {
          var p = prop[i]
          if (p instanceof Element) {
            x += p.toICal()
          }
          else {
            x += k.toUpperCase() + ':' + this[k] + DELIM
          }
        }
      }
      if (prop instanceof Element) {
        x += prop.toICal()
      }
      else {
        x += k.toUpperCase() + ':' + this[k] + DELIM
      }
    }
  }
  x += 'END:VCALENDAR'
  return x
}

exports.Calendar = Calendar