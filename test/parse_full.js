var should = require('should'),
    fs     = require('fs'),
    ical   = require('../');

describe('Parser', function () {
  var parser, full_ics_stream
  var full_ics = fs.readFileSync(__dirname + '/resources/full.ics')
  beforeEach(function (done) {
    parser = new ical.Parser()
    full_ics_stream = fs.createReadStream(__dirname + '/resources/full.ics')
    done()
  })
  describe('parses correctly tests', function () {
    it('must parse full.ics', function (done) {
      parser.on('end', done)
      parser.write(full_ics)
    })
    it('must parse full.ics streamed', function (done) {
      parser.on('end', function () {
        debugger;
        done()
      });
      full_ics_stream.pipe(parser)
    })
  })
})
