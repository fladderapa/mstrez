common = require '../lib/common'
bucket = require("bucket-node").bucket
_      = require "underscore"


exports.loginAdmin = (req, res) ->
  username = req.body.username
  password = req.body.password
  user = bucket.findWhere {type: "adminUser", name: username, password: password}
  if user? && _.contains user.permissions, "ksite"
    req.session.user = user
    res.redirect "/admin/blog"
  else
    res.redirect "/admin/signin"

exports.authenticateAdmin = (req, res, next) ->
  if req.session.user?
    next()
  else
    res.redirect "/admin/signin"

exports.adminSignin = (req, res) ->
  res.render "admin/signin"

exports.adminLogout = (req, res) ->
  req.session.destroy()
  res.redirect "/admin/signin"


