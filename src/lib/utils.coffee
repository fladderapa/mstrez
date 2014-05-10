bitly = require('bitly')

months = "januari_februari_mars_april_maj_juni_juli_augusti_september_oktober_november_december".split "_"

bitlyOptions = {
  format: 'json',
  api_url: 'api.bit.ly',
  api_version: 'v3',
  domain: 'j.mp'
};

exports.getSwedishMonthName = (nr) ->
  return months[nr]

exports.getFormattedDate = (timestamp) ->
  d = new Date(timestamp)
  y = d.getFullYear()

  return [d.getDate(),months[d.getMonth()],d.getFullYear()].join " "

exports.shortenLink = (link, cb) ->

  link = 'http://www.primamat.se/blog'+link
  b = new bitly 'o_3mgh34644v','R_b930365c63d9fc6ba958a135483514b3',bitlyOptions
  url = ''
  b.shorten link, (err,res) ->
    if err?
      cb(err,res)
    else
      if res.data.length == 0
        cb('error',res)
      else
        cb(null,res.data.url)


