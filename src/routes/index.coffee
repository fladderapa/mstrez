bucket = require("bucket-node").bucket
query = require "../data/query"
utils = require "../lib/utils"
async = require 'async'
_ = require "underscore"

exports.blog = (req, res) ->
  startPost = req.query.pId ? '0'
  numberOfPosts= req.query.pNum ? '4'
  numberOfLatestPosts = req.query.pLatest ? '15'
  selectedTag = req.query.tag
  startPost = parseInt(startPost)
  numberOfPosts = parseInt(numberOfPosts)
  numberOfLatestPosts = parseInt(numberOfLatestPosts)
  blogPosts = query.getBlogPosts(startPost, numberOfPosts, numberOfLatestPosts, selectedTag)
  res.render "blog",
    blogPosts: blogPosts.posts
 
exports.what = (req, res) ->
  res.render "what"

exports.clients = (req, res) ->
  res.render "clients"

exports.products = (req, res) ->
  res.render "products"

exports.kondensator = (req, res) ->
  res.render "kondensator"

exports.campaign = (req, res) ->
  res.render "campaign"

exports.contact = (req, res) ->
  res.render "contact"

exports.project = (req, res) ->
  res.render "project"

exports.index = (req, res) ->
  startPost = req.query.pId ? '0'
  numberOfPosts= req.query.pNum ? '4'
  numberOfLatestPosts = req.query.pLatest ? '15'
  selectedTag = req.query.tag
  startPost = parseInt(startPost)
  numberOfPosts = parseInt(numberOfPosts)
  numberOfLatestPosts = parseInt(numberOfLatestPosts)
  blogPosts = query.getBlogPosts(startPost, numberOfPosts, numberOfLatestPosts, selectedTag)


  res.render "index",
    blogPosts: blogPosts.posts
    next: blogPosts.next
    prev: blogPosts.prev
    latestPosts: blogPosts.latest
    archive: query.getBlogArchive()
    tags: query.getAllTags()

exports.singleBlogPost = (req, res) ->

  blogId = req.params.id
  numberOfLatestPosts = req.query.pLatest ? '15'
  blogPost = query.getBlogPost blogId, numberOfLatestPosts

  if blogPost?
    res.render "singleBlogPost",
      blogPost: blogPost.post
      latestPosts: blogPost.latest
      archive: query.getBlogArchive()
      tags: query.getAllTags()
  else 
    res.status(404)
    res.render "404",
      url: req.url


