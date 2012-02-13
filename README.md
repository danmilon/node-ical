# node-ical
  Provides a streaming Parser for the iCalendar format as specified by [RFC2445](http://www.ietf.org/rfc/rfc2445.txt).

## Quick Start
    var Parser = require('ical').Parser,
        fs     = require('fs');

    var p = new Parser();
    p.on('error', function (err) {
        console.log(err);
    });

    p.on('end', function () {
        console.log(p.calendars);
    });

    fs.createReadStream('file.ics').pipe(p);

## License
(The MIT License)

Copyright (c) 2009-2012 Dan Milon <danmilon@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.