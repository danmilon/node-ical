/**
    BEGIN:VEVENT
    DTSTART:20111206T150000Z
    DTEND:20111206T180000Z
    DTSTAMP:20120217T005926Z
    UID:3v454h0dqpe7m0kbqds4rca32g@google.com
    ATTENDEE;CUTYPE=INDIVIDUAL;ROLE=REQ-PARTICIPANT;PARTSTAT=ACCEPTED;CN=danmyl
     onakis@gmail.com;X-NUM-GUESTS=0:mailto:danmylonakis@gmail.com
    CREATED:20111206T013929Z
    DESCRIPTION:
    LAST-MODIFIED:20111206T013929Z
    LOCATION:
    SEQUENCE:1
    STATUS:TENTATIVE
    SUMMARY:557 με δαμον
    TRANSP:OPAQUE
    CATEGORIES:http://schemas.google.com/g/2005#event
    BEGIN:VALARM
    ACTION:DISPLAY
    DESCRIPTION:This is an event reminder
    TRIGGER:-P0DT0H10M0S
    END:VALARM
    END:VEVENT
 */

var Element = require('./element').Element
  , util    = require('util')

var DELIM = '\r\n'

function Event(data) {
  this.summary = data.summary
  this.location = data.location
  this.description = data.description
}

util.inherits(Event, Element)

Event.prototype.toICal = function () {
  var x = 'BEGIN:VEVENT' + DELIM
  for (var k in this) {
    if (this.hasOwnProperty(k)) {
      x += k.toUpperCase() + ':' + this[k] + DELIM
    }
  }
  x += 'END:VEVENT' + DELIM
  return x
}

exports.Event = Event