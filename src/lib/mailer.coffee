mandrill = require('node-mandrill')('qF0m9geYhKRpMflgq9xydA')
fs = require 'fs'
jade = require 'jade'
_ = require 'underscore'
path = require 'path'

sendMail = (from, to, subject, html, cb) ->
  to = _.map to, (email) ->
    email: email
    name: ''

  mailOptions = 
    message: 
      from_email: from
      from_name: "Kondensator"
      to: to
      subject: subject
      html: html

  mandrill "/messages/send", mailOptions, (err,response)->
    if err?
        console.dir err
        cb(err,null)
    else
        console.log "Message sent: "
        console.dir response
        cb(null,response)

exports.sendPrMail = (to,subject,content,cb) ->
  from = "tomas@kondensator.se"
  
  fs.readFile path.join(__dirname, '../mailtemplates/mail.jade'), 'utf8', (err, template) ->
    if err?
      console.dir err
    else
      fn = jade.compile template
      html = fn {content: content }
      sendMail from, _.flatten([to]), subject, html, (err,result) ->
        if err?
          cb(err,null)
        else
          cb(null,result)