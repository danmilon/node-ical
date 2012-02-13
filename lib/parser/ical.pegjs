start
  = icalstream

icalstream
  = icalobject+

icalobject
  = "BEGIN" ":" "VCALENDAR" CRLF
    icalbody
    "END" ":" "VCALENDAR" CRLF

icalbody = calprops component

calprops
  = prodid
  / version
  / calscale
  / method
  / x_prop
  / iana_prop

component = (eventc / todoc / journalc / freebusyc / timezonec / iana_comp / x_comp)+
iana_comp = "BEGIN" ":" iana_token CRLF contentline+
            "END" ":" iana_token CRLF
x_comp = "BEGIN" ":" x_name CRLF
          contentline+
         "END" ":" x_name CRLF
todoc = "BEGIN" ":" "VTODO" CRLF todoprop alarmc* "END" ":" "VTODO" CRLF

todoprop   = (
dtstamp / uid /
class / completed / created / description /
dtstart / geo / last_mod / location / organizer /
percent / priority / recurid / seq / status /
summary / url /
rrule /
due / duration /
attach / attendee / categories / comment / contact /
exdate / rstatus / related / resources /
rdate / x_prop / iana_prop
)*

journalc = "BEGIN" ":" "VJOURNAL" CRLF jourprop "END" ":" "VJOURNAL" CRLF
jourprop   = (
dtstamp / uid /
class / created / dtstart /
last_mod / organizer / recurid / seq /
status / summary / url /
rrule /
attach / attendee / categories / comment /
contact / description / exdate / related / rdate /
rstatus / x_prop / iana_prop
)*
freebusyc = "BEGIN" ":" "VFREEBUSY" CRLF fbprop "END" ":" "VFREEBUSY" CRLF
fbprop = ( dtstamp / uid /
contact / dtstart / dtend /
organizer / url /
attendee / comment / freebusy / rstatus / x_prop /
iana_prop
)*

timezonec
  = "BEGIN" ":" "VTIMEZONE" CRLF
  ( tzid / last_mod / tzurl / standardc / daylightc / x_prop / iana_prop )
  "END" ":" "VTIMEZONE" CRLF
percent = "PERCENT-COMPLETE" pctparam ":" integer CRLF
pctparam   = (";" other_param)*
due        = "DUE" dueparam ":" dueval CRLF
dueparam   = (
(";" "VALUE" "=" ("DATE-TIME" / "DATE")) /
(";" tzidparam) /
(";" other_param)
)*
freebusy = "FREEBUSY" fbparam ":" fbvalue CRLF
fbparam = (
(";" fbtypeparam) /
(";" other_param)
)*
tzoffsetfrom = "TZOFFSETFROM" frmparam ":" utc_offset CRLF
frmparam   = (";" other_param)*
tzname     = "TZNAME" tznparam ":" text CRLF
tznparam   = ( (";" languageparam) / (";" other_param) )*
name          = iana_token / x_name
x_name        = "X-" [vendorid "-"] (ALPHA / DIGIT / "-")+
vendorid      = (ALPHA / DIGIT) (ALPHA / DIGIT) (ALPHA / DIGIT)+
param         = param_name "=" param_value *("," param_value)
param_name    = iana_token / x_name
param_value   = paramtext / quoted_string
paramtext     = SAFE_CHAR*

fbvalue    = period ("," period)*
tzid       = "TZID" tzidpropparam ":" [tzidprefix] text CRLF
tzidpropparam = (";" other_param)*
tzurl = "TZURL" tzurlparam ":" uri CRLF
tzurlparam = (";" other_param)*
tzoffsetto = "TZOFFSETTO" toparam ":" utc_offset CRLF
utc_offset = time_numzone
time_numzone = ("+" / "-") time_hour time_minute time_second?
toparam    = (";" other_param)*
dueval     = date_time / date
standardc  = "BEGIN" ":" "STANDARD" CRLF tzprop "END" ":" "STANDARD" CRLF
daylightc  = "BEGIN" ":" "DAYLIGHT" CRLF tzprop "END" ":" "DAYLIGHT" CRLF
tzprop     = ( dtstart / tzoffsetto / tzoffsetfrom / rrule / comment / rdate / tzname / x_prop / iana_prop )*
contentline = name (";" param )* ":" value CRLF
completed  = "COMPLETED" compparam ":" date_time CRLF
compparam  = (";" other_param)*
prodid = "PRODID" pidparam ":" pidvalue CRLF
pidvalue = text
pidparam   = (";" other_param)*
other_param = iana_param / x_param
iana_param = iana_token "=" param_value ("," param_value)*
x_param = x_name "=" param_value ("," param_value)*
x_name = "X-" [vendorid "-"] (ALPHA / DIGIT / "-")?
iana_token = (ALPHA / DIGIT / "-")?
param_value = paramtext / quoted_string
paramtext = SAFE_CHAR*
version = "VERSION" verparam ":" vervalue CRLF
verparam = (";" other_param)*
vervalue = "2.0" / maxver / (minver ";" maxver)
maxver = "" minver = ""
calscale = "CALSCALE" calparam ":" calvalue CRLF
calparam = (";" other_param)*
calvalue = "GREGORIAN"
method = "METHOD" metparam ":" metvalue CRLF
metparam = (";" other_param)*
metvalue = iana_token
x_prop = x_name (";" icalparameter)* ":" value CRLF
value = VALUE_CHAR*
iana_prop = iana_token (";" icalparameter)* ":" value CRLF
quoted_string = DQUOTE QSAFE_CHAR DQUOTE*
icalparameter = altrepparam
              / cnparam
              / cutypeparam
              / delfromparam
              / deltoparam
              / dirparam
              / encodingparam
              / fmttypeparam
              / fbtypeparam
              / languageparam
              / memberparam
              / partstatparam
              / rangeparam
              / trigrelparam
              / reltypeparam
              / roleparam
              / rsvpparam
              / sentbyparam
              / tzidparam
              / valuetypeparam
              / other_param

altrepparam = "ALTREP" "=" DQUOTE uri DQUOTE
cal_address = uri
uri = ""
fmttypeparam = ""
cnparam = "CN" "=" param_value
cutypeparam
  = "CUTYPE" "="
    ("INDIVIDUAL"
    / "GROUP"
    / "RESOURCE"
    / "ROOM"
    / "UNKNOWN"
    / x_name
    / iana_token)

delfromparam
  = "DELEGATED-FROM" "=" DQUOTE cal_address DQUOTE
    ("," DQUOTE cal_address DQUOTE)*
deltoparam
  = "DELEGATED-TO" "=" DQUOTE cal_address DQUOTE
    ("," DQUOTE cal_address DQUOTE)*

dirparam = "DIR" "=" DQUOTE uri DQUOTE
encodingparam
  = "ENCODING" "=" ("8BIT" / "BASE64")

fbtypeparam
  = "FBTYPE" "="
    ("FREE"
    / "BUSY"
    / "BUSY-UNAVAILABLE"
    / "BUSY-TENTATIVE"
    / x_name
    / iana_token)

languageparam = "LANGUAGE" "=" language
language = Language_Tag
Language_Tag = ""

memberparam
  = "MEMBER" "=" DQUOTE cal_address
    DQUOTE ("," DQUOTE cal_address DQUOTE)*

partstatparam
  = "PARTSTAT" "="
    (partstat_event
    / partstat_todo
    / partstat_jour)

partstat_event
  = ("NEEDS-ACTION"
    / "ACCEPTED"
    / "DECLINED"
    / "TENTATIVE"
    / "DELEGATED"
    / x_name
    / iana_token)

partstat_todo
  = ("NEEDS-ACTION"
    / "ACCEPTED"
    / "DECLINED"
    / "TENTATIVE"
    / "DELEGATED"
    / "COMPLETED"
    / "IN-PROCESS"
    / x_name
    / iana_token)

partstat_jour
  = ("NEEDS-ACTION"
    / "ACCEPTED"
    / "DECLINED"
    / x_name
    / iana_token)

rangeparam = "RANGE" "=" "THISANDFUTURE"

trigrelparam = "RELATED" "=" ("START" / "END")

reltypeparam
  = "RELTYPE" "="
  ("PARENT"
  / "CHILD"
  / "SIBLING"
  / iana_token
  / x_name)

roleparam
  = "ROLE" "="
    ("CHAIR"
    / "REQ-PARTICIPANT"
    / "OPT-PARTICIPANT"
    / "NON-PARTICIPANT"
    / x_name
    / iana_token)

rsvpparam = "RSVP" "=" ("TRUE" / "FALSE")

sentbyparam
  = "SENT-BY" "=" DQUOTE cal_address DQUOTE

tzidparam = "TZID" "=" tzidprefix? paramtext
tzidprefix = "/"

valuetypeparam = "VALUE" "=" valuetype
valuetype
  = ("BINARY"
    / "BOOLEAN"
    / "CAL-ADDRESS"
    / "DATE"
    / "DATE-TIME"
    / "DURATION"
    / "FLOAT"
    / "INTEGER"
    / "PERIOD"
    / "RECUR"
    / "TEXT"
    / "TIME"
    / "URI"
    / "UTC-OFFSET"
    / x_name
    / iana_token)

eventc
  = "BEGIN" ":" "VEVENT" CRLF
    eventprop alarmc*
    "END" ":" "VEVENT" CRLF

eventprop
  = (dtstamp
    / uid
    / dtstart
    / class
    / created
    / description
    / geo
    / last_mod
    / location
    / organizer
    / priority
    / seq
    / status
    / summary
    / transp
    / url
    / recurid
    / rrule
    / dtend
    / duration
    / attach
    / attendee
    / categories
    / comment
    / contact
    / exdate
    / rstatus
    / related
    / resources
    / rdate
    / x_prop
    / iana_prop)*

alarmc
  = "BEGIN" ":" "VALARM" CRLF
    (audioprop / dispprop / emailprop)
    "END" ":" "VALARM" CRLF

audioprop
  = (action
    / trigger
    / duration
    / repeat
    / attach
    / x_prop / iana_prop)*

dispprop
  = (action
    / description
    / trigger
    / duration
    / repeat
    / x_prop
    / iana_prop)*

emailprop
  = (action
    / description
    / trigger
    / summary
    / attendee
    / duration
    / repeat
    / attach
    / x_prop
    / iana_prop)*

dtstamp = "DTSTAMP" stmparam ":" date_time CRLF
stmparam = (";" other_param)*
uid = "UID" uidparam ":" text CRLF
uidparam   = (";" other_param)*
dtstart = "DTSTART" dtstparam ":" dtstval CRLF
dtstparam
  = (
  (";" "VALUE" "=" ("DATE-TIME" / "DATE"))
  / (";" tzidparam)
  / (";" other_param)
  )*
dtstval = date_time / date
class = "CLASS" classparam ":" classvalue CRLF
classparam = (";" other_param)*
classvalue
  = "PUBLIC"
  / "PRIVATE"
  / "CONFIDENTIAL"
  / iana_token
  / x_name
created = "CREATED" creaparam ":" date_time CRLF
creaparam = (";" other_param)*
description = "DESCRIPTION" descparam ":" text CRLF
descparam
  = (
      (";" altrepparam)
      / (";" languageparam)
      / (";" other_param)
    )*
geo = "GEO" geoparam ":" geovalue CRLF
geoparam = (";" other_param)*
geovalue = float ";" float
float = ("+"? / "-") DIGIT? ("." DIGIT?)?
last_mod = "LAST-MODIFIED" lstparam ":" date_time CRLF
lstparam = (";" other_param)*
location = "LOCATION"  locparam ":" text CRLF
locparam
  = (
      (";" altrepparam)
      / (";" languageparam)
      / (";" other_param)
    )*
organizer= "ORGANIZER" orgparam ":" cal_address CRLF
orgparam
  = (
      (";" cnparam)
      / (";" dirparam)
      / (";" sentbyparam)
      / (";" languageparam)
      / (";" other_param)
    )*
priority = "PRIORITY" prioparam ":" priovalue CRLF
prioparam = (";" other_param)*
priovalue = integer
seq = "SEQUENCE" seqparam ":" integer CRLF
seqparam = (";" other_param)*
status = "STATUS" statparam ":" statvalue CRLF
statparam= (";" other_param)*
statvalue
  = (statvalue_event
    / statvalue_todo
    / statvalue_jour)
statvalue_event
  = "TENTATIVE"
  / "CONFIRMED"
  / "CANCELLED"

statvalue_todo
  = "NEEDS-ACTION"
  / "COMPLETED"
  / "IN-PROCESS"
  / "CANCELLED"
summary = "SUMMARY" summparam ":" text CRLF
summparam
  = (
      (";" altrepparam) / (";" languageparam)
      / (";" other_param)
    )*
transp = "TRANSP" transparam ":" transvalue CRLF
transparam = (";" other_param)*
transvalue = "OPAQUE" / "TRANSPARENT"
url = "URL" urlparam ":" uri CRLF
urlparam = (";" other_param)*
recurid = "RECURRENCE-ID" ridparam ":" ridval CRLF
ridparam
  = (
      (";" "VALUE" "=" ("DATE-TIME" / "DATE"))
      / (";" tzidparam) / (";" rangeparam)
      / (";" other_param)
    )*
ridval = date_time / date
rrule = "RRULE" rrulparam ":" recur CRLF
rrulparam = (";" other_param)*
dtend = "DTEND" dtendparam ":" dtendval CRLF
dtendparam
  = (
      (";" "VALUE" "=" ("DATE-TIME" / "DATE"))
      / (";" tzidparam)
      / (";" other_param)
    )*
dtendval = date_time / date
duration = "DURATION" durparam ":" dur_value CRLF
durparam = (";" other_param)*
attach
  = "ATTACH" attachparam ( ":" uri )
  / (";" "ENCODING" "=" "BASE64"
     ";" "VALUE" "=" "BINARY"
     ":" binary) CRLF
attachparam
  = (
      (";" fmttypeparam) /
      (";" other_param)
    )*
attendee = "ATTENDEE" attparam ":" cal_address CRLF

attparam
  = (
      (";" cutypeparam)
      / (";" memberparam)
      / (";" roleparam)
      / (";" partstatparam)
      / (";" rsvpparam)
      / (";" deltoparam)
      / (";" delfromparam)
      / (";" sentbyparam)
      / (";" cnparam)
      / (";" dirparam)
      / (";" languageparam)
      / (";" other_param)
    )*
categories
  = "CATEGORIES" catparam ":" text *("," text) CRLF

catparam
  = (
      (";" languageparam )
      / (";" other_param)
    )*
comment = "COMMENT" commparam ":" text CRLF
commparam
  = (
      (";" altrepparam)
      / (";" languageparam)
      / (";" other_param)
    )*
contact = "CONTACT" contparam ":" text CRLF
contparam 
  = (
      (";" altrepparam)
      / (";" languageparam)
      / (";" other_param)
)*
exdate = "EXDATE" exdtparam ":" exdtval *("," exdtval) CRLF
exdtparam 
  = (
      (";" "VALUE" "=" ("DATE-TIME" / "DATE"))
      / (";" tzidparam)
      / (";" other_param)
    )*
exdtval = date_time / date
rstatus
  = "REQUEST-STATUS" rstatparam ":"
    statcode ";" statdesc (";" extdata)?
rstatparam
  = (
      (";" languageparam)
      / (";" other_param)
    )*
statdesc = text
extdata = text
related = "RELATED-TO" relparam ":" text CRLF
relparam
  = (
      (";" reltypeparam)
      / (";" other_param)
    )*
resources = "RESOURCES" resrcparam ":" text *("," text) CRLF

resrcparam
  = (
      (";" altrepparam)
      / (";" languageparam)
      / (";" other_param)
    )*
exdate = "EXDATE" exdtparam ":" exdtval *("," exdtval) CRLF
exdtparam
  = (
      (";" "VALUE" "=" ("DATE-TIME" / "DATE"))
      / (";" tzidparam)
      / (";" other_param)
    )*
exdtval = date_time / date
rdate      = "RDATE" rdtparam ":" rdtval *("," rdtval) CRLF

rdtparam
  = (
      (";" "VALUE" "=" ("DATE-TIME" / "DATE" / "PERIOD"))
      / (";" tzidparam)
      / (";" other_param)
    )*
rdtval = date_time / date / period
action = "ACTION" actionparam ":" actionvalue CRLF

actionparam = (";" other_param)*
actionvalue = "AUDIO" / "DISPLAY" / "EMAIL" / iana_token / x_name
trigger = "TRIGGER" (trigrel / trigabs) CRLF
trigrel
  = (
      (";" "VALUE" "=" "DURATION") /
      (";" trigrelparam) /
      (";" other_param)
    )* ":"  dur_value

trigabs
  = (
      (";" "VALUE" "=" "DATE-TIME") /
      (";" other_param)
    )* ":" date_time
repeat = "REPEAT" repparam ":" integer CRLF
repparam = (";" other_param)*
date_time = date "T" time
text = (TSAFE_CHAR / ":" / DQUOTE / ESCAPED_CHAR)*
date = date_value
date_value         = date_fullyear date_month date_mday
date_fullyear      = DIGIT DIGIT DIGIT DIGIT
date_month         = DIGIT DIGIT
date_mday          = DIGIT DIGIT
integer = (["+"] / "-") DIGIT
statvalue_jour  = "DRAFT" / "FINAL" / "CANCELLED"
recur = recur_rule_part ( ";" recur_rule_part )*
dur_value  = (["+"] / "-") "P" (dur_date / dur_time / dur_week)
dur_date   = dur_day [dur_time]
dur_time   = "T" (dur_hour / dur_minute / dur_second)
dur_week   = DIGIT+ "W"
dur_hour   = DIGIT+ "H" [dur_minute]
dur_minute = DIGIT+ "M" [dur_second]
dur_second = DIGIT+ "S"
dur_day    = DIGIT+ "D"
binary = (b_char b_char b_char b_char)* b_end?
b_char = ALPHA / DIGIT / "+" / "/"
b_end      = (b_char b_char "==") / (b_char b_char b_char "=")
b_char = ALPHA / DIGIT / "+" / "/"
statcode   = DIGIT+ ("." DIGIT+) ("." DIGIT+)?
statdesc   = text
extdata    = text
period     = period_explicit / period_start
period_explicit = date_time "/" date_time
period_start = date_time "/" dur_value
time         = time_hour time_minute time_second time_utc?
time_hour    = DIGIT DIGIT
time_minute  = DIGIT DIGIT
time_second  = DIGIT DIGIT
time_utc     = "Z"
TSAFE_CHAR = WSP / [\u0021] / [\u0023-\u002B] / [\u002D-\u0039] / [\u003C-\u005B] / [\u005D-\u007E] / NON_US_ASCII
ESCAPED_CHAR = ("\\" / "\;" / "\," / "\N" / "\n")
recur_rule_part
  = ( "FREQ" "=" freq )
    / ( "UNTIL" "=" enddate )
    / ( "COUNT" "=" DIGIT+ )
    / ( "INTERVAL" "=" DIGIT+ )
    / ( "BYSECOND" "=" byseclist )
    / ( "BYMINUTE" "=" byminlist )
    / ( "BYHOUR" "=" byhrlist )
    / ( "BYDAY" "=" bywdaylist )
    / ( "BYMONTHDAY" "=" bymodaylist )
    / ( "BYYEARDAY" "=" byyrdaylist )
    / ( "BYWEEKNO" "=" bywknolist )
    / ( "BYMONTH" "=" bymolist )
    / ( "BYSETPOS" "=" bysplist )
    / ( "WKST" "=" weekday )
freq  = "SECONDLY" / "MINUTELY" / "HOURLY" / "DAILY" / "WEEKLY" / "MONTHLY" / "YEARLY"
enddate     = date / date_time
byseclist   = ( seconds ("," seconds)* )
seconds     = DIGIT DIGIT?
byminlist   = ( minutes ("," minutes)* )
minutes     = DIGIT DIGIT?
byhrlist    = ( hour ("," hour)* )
hour        = DIGIT DIGIT?
bywdaylist  = ( weekdaynum ("," weekdaynum)* )
weekdaynum  = ((plus / minus)? ordwk)? weekday
plus        = "+"
minus       = "-"
ordwk       = DIGIT DIGIT?
weekday     = "SU" / "MO" / "TU" / "WE" / "TH" / "FR" / "SA"
bymodaylist = ( monthdaynum *("," monthdaynum) )
monthdaynum = [plus / minus] ordmoday
ordmoday    = DIGIT DIGIT?
byyrdaylist = ( yeardaynum ("," yeardaynum)* )
yeardaynum  = [plus / minus] ordyrday
ordyrday    = DIGIT DIGIT? DIGIT?
bywknolist  = ( weeknum ("," weeknum)* )
weeknum     = [plus / minus] ordwk
bymolist    = ( monthnum ("," monthnum)* )
monthnum    = DIGIT DIGIT?
bysplist    = ( setposday ("," setposday)* )
setposday   = yeardaynum

DQUOTE = [\u0022]

QSAFE_CHAR
  = WSP
  / [\u0021]
  / [\u0023-\u007E]
  / NON_US_ASCII

SAFE_CHAR
  = WSP
  / [\u0021]
  / [\u0023-\u002B]
  / [\u002d-\u0039]
  / [\u003c-\u007e]
  / NON_US_ASCII

NON_US_ASCII
  = UTF8_2
  / UTF8_3
  / UTF8_4

UTF8_2 = [\u00c2-\u00df] UTF8_tail

UTF8_3
  = [\u00E0] [\u00A0-\u00BF] UTF8_tail
  / [\u00E1-\u00EC] UTF8_tail UTF8_tail
  / [\u00ED] [\u0080-\u009F] UTF8_tail
  / [\u00EE-\u00EF] UTF8_tail UTF8_tail

UTF8_4
  = [\u00F0] [\u0090-\u00BF] UTF8_tail UTF8_tail
  / [\u00F1-\u00F3] UTF8_tail UTF8_tail UTF8_tail
  / [\u00F4] [\u0080-\u008F] UTF8_tail UTF8_tail

UTF8_tail = [\u0080-\u00BF]

VALUE_CHAR
  = WSP
  / [\u0021-\u007E]
  / NON_US_ASCII

WSP = SP / HTAB
HTAB = [\u0009]
SP = [\u0020]
CRLF = "\r\n"
ALPHA
  = [a-z]
  / [A-Z]

DIGIT = [0-9]