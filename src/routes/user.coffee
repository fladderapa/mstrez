bucket = require("bucket-node").bucket
query = require "../data/query"
_ = require "underscore"
fs = require "fs"


exports.all = (req, res) ->
  res.render "admin/user/all",
    users: bucket.where {type: "user"}
    message: req.flash('info')

exports.single = (req, res) ->
  userId = req.params.id
  user = bucket.getById(userId)

  res.render "admin/user/single",
    {user: user}

exports.new = (req, res) ->
  user = {name: "namn", email: "namn@domain.com", imgClass: "klass"}
  res.render "admin/user/single",
    {user: user}

exports.deleteUser = (req, res) ->
  id = req.params.id
  if id?
    bucket.deleteById(id);
    bucket.store (err) ->
      if err?
        req.flash('info', 'Something went wrong when deleting user.')
      else
        req.flash('info', 'Deleted.')
      exports.all req, res

storeUser = (name,email,imgClass,id,callback) ->
  user = {}
  if id != "new"
    user = bucket.getById(id)
  else
    user = {type: "user", date: Date.now() }
  user = _.extend(user, {name: name, email: email, imgClass:imgClass})
  bucket.set(user)
  bucket.store (err) ->
    callback(err)

exports.saveUser = (req, res) ->
  name = req.body.name
  email = req.body.email
  imgClass = req.body.imgClass
  id = req.params.id

  storeUser name,email,imgClass,id,(err) ->
    if err?
      req.flash('info', 'Something went wrong when saving blog post.')
    else
      req.flash('info', 'Saved.')
    exports.all req, res