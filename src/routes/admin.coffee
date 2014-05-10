bucket = require("bucket-node").bucket
fs = require "fs"
_ = require "underscore"
mailer = require "../lib/mailer"

exports.uploads = (req, res) ->
  files = bucket.where {type: "file"}
  res.render "admin/uploads/uploads", {files: files}


exports.fileUpload = (req, res) ->
  console.dir req.files
  tmp_path = "./" + req.files.image.path
  name = req.files.image.name.replace /\s/g, "_"
  target_path = "./public/uploads/#{name}"

  fs.rename tmp_path, target_path, (err) ->
    unless err?
      bucket.set {type: "file", url: "/uploads/#{name}"}
      bucket.store (err)->
        unless err?
          res.redirect "/admin/upload"
        else
          console.log "Failed to store to bucket"
          console.dir err
          res.send err
    else
      console.log "Failed to save file"
      console.dir err
      res.send err

exports.deleteFiles = (req, res) ->
  fileIds = _.flatten [req.body.fileIds]
  files = []
  for id in fileIds
    files.push (bucket.getById(id))
    bucket.deleteById(id)
  bucket.store (err) ->
    unless err?
      for file in files
        fs.unlink "./public" + file.url, (err) ->
          if err?
            console.log "Failed to remove file"
            console.dir err
      res.redirect "/admin/upload"

exports.sendmail = (req, res) ->
  res.render "admin/sendmail/"


exports.sendPrMail = (req,res) ->
  to = req.body.email
  subject = req.body.subject
  content = req.body.content

  mailer.sendPrMail to, subject, content, (err,result) ->
    if err?
      console.dir err
      res.json { status: 'error', response: 'Mailet kunde inte skickas, vänligen försök igen' }
    else
      console.dir result
      res.json { status: 'ok', response: "Mail har skickats." }
