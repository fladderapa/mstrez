bucket = require("bucket-node").bucket
query = require "../data/query"
_ = require "underscore"
fs = require "fs"


exports.all = (req, res) ->
  res.render "admin/blog/all",
    blogPosts: bucket.where {type: "blogPost"}
    message: req.flash('info')

exports.single = (req, res) ->
  blogId = req.params.id
  blogPost = bucket.getById(blogId)
  blogImage = bucket.getById(blogPost.image) if blogPost.image?
  users = bucket.where {type: 'user'}

  res.render "admin/blog/single",
    {blogPost: blogPost, blogImage: blogImage, users: users}

exports.new = (req, res) ->
  users = bucket.where {type: 'user'}
  blogPost = {type: "blogPost", date: Date.now(), title: "Title", text: "lorem ipsum...", tags: []}
  res.render "admin/blog/single",
    blogPost: blogPost
    users: users

exports.deleteBlogPost = (req, res) ->
  id = req.params.id
  if id?
    bucket.deleteById(id);
    bucket.store (err) ->
      if err?
        req.flash('info', 'Something went wrong when deleting blog post.')
      else
        req.flash('info', 'Deleted.')
      exports.all req, res

uploadFile = (image, callback) ->
  tmp_path = "./" + image.path
  name = image.name.replace /\s/g, "_"
  target_path = "./public/uploads/#{name}"

  fs.rename tmp_path, target_path, (err) ->
    unless err?
      imageId = bucket.set {type: "file", url: "/uploads/#{name}"}
      bucket.store (err)->
        callback(err, imageId)
    else
      callback(err)

storeBlogPost = (text, title, author, id, image, url, callback) ->
    blogPost = {}
    if id != "new"
      blogPost = bucket.getById(id)
    else
      blogPost = {type: "blogPost", date: Date.now() }
    blogPost = _.extend(blogPost, {title: title, text: text, author: author, image:image, url: url})
    bucket.set(blogPost)
    bucket.store (err) ->
      callback(err)

exports.saveImage = (req, res) ->
  if req.files.file?
    uploadFile req.files.file, (err, imageId) ->
      unless err?
        res.end(imageId)
      else
        res.end('FAILED UPLOAD')
  else
    res.end('FAILED NO IMAGE')

exports.saveBlogPost = (req, res) ->
  text = req.body.text
  title = req.body.title
  #tags = exports.separateTags req.body.tags
  author = req.body.author
  imageId = req.body.imageid
  id = req.params.id
  url = req.body.url
  console.log "Image id: #{imageId}"

  storeBlogPost text, title, author, id, imageId, url, (err) ->
    if err?
      req.flash('info', 'Something went wrong when saving blog post.')
    else
      req.flash('info', 'Saved.')
    exports.all req, res

exports.separateTags = (tagsString) ->
  result = []
  for tag in tagsString.split(/[,; ]/)
    trim = tag.trim()
    if (trim != "")
      result.push trim;
  result