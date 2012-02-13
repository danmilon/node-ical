var Stream = require('stream').Stream,
    util   = require('util');

function Parser(opts) {
  Stream.call(this);
  this._stages = ['init'];
  this.buffer = '';
  this.writable = true;
  this.calendars = [];
  this._handles = [];
}
util.inherits(Parser, Stream);
exports.Parser = Parser;

Parser.parseLine = function (line) {
  /*
   * Here maybe we need to take into acount
   * :'s in quotes also
   */
  var obj = { };
  var valueSplitter = line.indexOf(':');
  if (valueSplitter === -1) {
    throw new Error('this line has no ":"!');
  }
  var paramSplitter = line.indexOf(';');
  if (paramSplitter === -1) {
    paramSplitter = valueSplitter + 1;
  }
  var haveParams = (paramSplitter < valueSplitter);
  var nameSplitter = haveParams ? paramSplitter : valueSplitter;
  obj.name = line.substr(0, nameSplitter).toLowerCase();
  if (haveParams) {
    var params = line.slice(paramSplitter + 1, valueSplitter);
    params = params.split(';');
    obj.params = { };
    for (var i = 0; i < params.length; i++) {
      params[i] = params[i].split('=');
      var paramKey = params[i][0];
      var paramValue = params[i][1];
      obj.params[paramKey.toLowerCase()] = paramValue;
    }
  }
  var value = line.substr(valueSplitter + 1);
  obj.value = value;
  return obj;
};

Parser.parseDateTime = function (dt, tzid) {
  var year = parseInt(dt.slice(0, 4), 10);
  var month = parseInt(dt.slice(4, 6), 10);
  var day = parseInt(dt.slice(6, 8), 10);
  var hours, minutes, seconds;
  if (dt.length > 8) {
    hours = parseInt(dt.slice(9, 11), 10);
    minutes = parseInt(dt.slice(11, 13), 10);
    seconds = parseInt(dt.slice(13, 15), 10);
  }
  else {
    // then it is type 'date'
    if ((year === NaN) || (month === NaN) || (day === NaN)) {
      throw new Error('misformatted date' + dt);
    }
    return {
      type: 'date',
      date: new Date(year, month - 1, day)
    };
  }
  if ((year === NaN) || (month === NaN) || (day === NaN)|| 
      (hours === NaN) || (minutes === NaN || seconds === NaN)) {
    // then some are NaN
    throw new Error('misformatted date ' + dt);
  }

  var date = new Date(year, month - 1, day, hours, minutes, seconds);
  if (dt.lastIndexOf('Z') === dt.length - 1) {
    return {
      type: 'utc',
      date: date
    };
  }
  else if (tzid) {
    return {
      type: 'utc+tzid',
      tzid: tzid,
      date: date
    };
  }
  else {
    return {
      type: 'local',
      date: date
    };
  }
};

Parser.prototype.write = function (data) {
  var self = this;
  if (data instanceof Buffer) {
    data = data.toString();
  }
  data = data.replace(/\r\n[ \t]/g, '');
  self.buffer += data;
  process.nextTick(function () {
    self._dispatch();
  });
};

Parser.prototype._dispatch = function () {
  /*
   * Need to take into
   * account \r\n in quotes here
   */
  var content = this.buffer.substr(0, this.buffer.lastIndexOf('\r\n'));
  this.buffer = this.buffer.substr(2);
  var contentLines = content.split('\r\n');
  for (var i = 0; i < contentLines.length; i++) {
    var line = contentLines[i];
    line = Parser.parseLine(line);
    var fn = this.handlers[line.name];
    if (!fn) {
      console.log('dont know how to handle ' + line.name + ' will use dummy handler');
      this.handlers._onlyCopy.call(this, line);
    }
    else {
      fn.call(this, line);
    }
  }
};

Parser.prototype.end = function () {
  this.emit('end');
};

Parser.prototype.stage = function () {
  return this._stages[this._stages.length - 1];
};

Parser.prototype._stripBuffer = function (end) {
  this.buffer = this.buffer.substr(end.length);
};

Parser.prototype._error = function (err) {
  if (this.listeners('error').length === 0) {
    throw err;
  }
  else {
    this.emit('error', err);
  }
};

Parser.prototype._lastHandle = function () {
  if (this._handles.length === 0) {
    return this._error('no handles stored');
  }
  return this._handles[this._handles.length - 1];
};

Parser.prototype.handlers = { };

Parser.prototype.handlers.begin = function (cmd) {
  this._stages.push(cmd.value);
  switch (cmd.value) {
  case 'VCALENDAR':
    var newCal = {
      events: []
    };
    this._handles.push(newCal);
    this.calendars.push(newCal);
    break;
  case 'VEVENT':
    var newEvent = {
      alarms: []
    };
    this._lastHandle().events.push(newEvent);
    this._handles.push(newEvent);
    break;
  case 'VTIMEZONE':
    break;
  case 'VALARM':
    var newAlarm = { };
    this._lastHandle().alarms.push(newAlarm);
    this._handles.push(newAlarm);
    break;
  default:
    return this._error('dont know how to handle ' + cmd.value);
  }
};

Parser.prototype.handlers.end = function (cmd) {
  var value = this._stages.pop();
  if (value !== cmd.value) {
    return this._error(new Error('BEGINS and ENDS are fucked up'));
  }
  this._handles.pop();
};

var onlyCopy = Parser.prototype.handlers._onlyCopy = function (cmd) {
  var handle = this._lastHandle();
  var nameLower = cmd.name.toLowerCase();
  if (typeof handle[nameLower] === 'undefined') {
    if (cmd.params) {
      this._lastHandle()[nameLower] = {
        params: cmd.params,
        value: cmd.value
      };
    }
    else {
      this._lastHandle()[cmd.name.toLowerCase()] = cmd.value;
    }
  }
  else {
    throw new Error(cmd.name + ' is already set');
  }
};

Parser.prototype.handlers.prodid = onlyCopy;
Parser.prototype.handlers.version = onlyCopy;
Parser.prototype.handlers.calscale = onlyCopy;
Parser.prototype.handlers.method = onlyCopy;
Parser.prototype.handlers.uid = onlyCopy;

Parser.prototype.handlers.dtstart = function (cmd) {
  var tzid;
  if (cmd.params && cmd.params.tzid) {
    tzid = cmd.params.tzid;
  }
  var date = Parser.parseDateTime(cmd.value, tzid);
  this._lastHandle().dtstart = date;
};

Parser.prototype.handlers.dtend = function (cmd) {
  var tzid;
  if (cmd.params && cmd.params.tzid) {
    tzid = cmd.params.tzid;
  }
  var date = Parser.parseDateTime(cmd.value, tzid);
  this._lastHandle().dtend = date;
}

Parser.prototype.handlers.dtstamp = function (cmd) {
  var tzid;
  if (cmd.params && cmd.params.tzid) {
    tzid = cmd.params.tzid;
  }
  var date = Parser.parseDateTime(cmd.value, tzid);
  this._lastHandle().dtstamp = date;
}