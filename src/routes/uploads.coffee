bucket = require("bucket-node").bucket
_ = require "underscore"
fs = require "fs"

exports.saveImage = (req, res) ->
  if req.files.file?
    console.log 'save image'
    uploadFile req.files.file, (err, imageId) ->
      unless err?
        res.end(imageId)
      else
        console.dir err
        res.end('FAILED UPLOAD')
  else
    res.end('FAILED NO IMAGE')


uploadFile = (image, callback) ->
  #tmp_path = "./" + image.path
  tmp_path = image.path
  name = image.name.replace /\s/g, "_"
  target_path = "./public/uploads/#{name}"
  console.log tmp_path
  console.log target_path

  fs.rename tmp_path, target_path, (err) ->
    unless err?
      imageId = bucket.set {type: "file", url: "/uploads/#{name}"}
      bucket.store (err)->
        callback(err, imageId)
    else
      callback(err)