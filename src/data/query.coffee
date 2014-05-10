bucket  = require("bucket-node").bucket
_       = require "underscore"
utils   = require("../lib/utils")
moment  = require 'moment'
_.str   = require 'underscore.string'
_.mixin _.str.exports()



getImage = (imgId) ->
  bucket.getById imgId

exports.getBlogPost = (id, nr) ->
  allPosts = getAllBlogPostsSorted()
  post = bucket.getById id
  unless post?
    post = bucket.findWhere { url: id }
  if post
    post = extendWidthAuthor(post)
    post.imageObj = getImage post.image
    post.date = utils.getFormattedDate post.date 
    _.each allPosts, (apost) ->
      apost.date = utils.getFormattedDate(apost.date)
      apost.imageObj = getImage apost.image

    { post: post, latest: _.first(allPosts, nr) }
  else
    null

exports.getBlogPosts = (startPost, nrOfPosts, nrOfLatestPosts, selectedTag) ->
  allPosts = getAllBlogPostsSorted()

  if selectedTag?
    allPosts = _.filter allPosts, (post) ->
      _.contains post.tags, selectedTag

  _.each allPosts, (post) ->
    post.date = utils.getFormattedDate(post.date)
    post.imageObj = getImage post.image

  blogPosts = _.rest allPosts, startPost
  next = if (allPosts.length > startPost + nrOfPosts) then startPost+nrOfPosts else 0
  prev = startPost - nrOfPosts
  if  prev <= 0
    if startPost == 0
      prev = -1 #Already at zero, shouldn't be able to go back further
    else
      prev = 0 #Should be able to go back to 0
  {posts: _.first(blogPosts, nrOfPosts), next: next, prev: prev, latest: _.first(allPosts, nrOfLatestPosts) }

exports.getBlogArchive = () ->
  allPosts = getAllBlogPostsSorted()
  currentYearAndMonth = {}
  result = {}
  for blogPost, index in allPosts
    postYearAndMonth = getYearAndMonthForDate(blogPost.date)
    unless _.isEqual(postYearAndMonth, currentYearAndMonth)
      yearArray = result[postYearAndMonth.year] ? []
      yearArray.push {month: postYearAndMonth.month, firstPost: index}
      result[postYearAndMonth.year] = yearArray
      currentYearAndMonth = postYearAndMonth
  resultArray = _.map result, (archiveObjects, year) ->
    {year: year, archiveObjects: archiveObjects}
  resultArray = _.sortBy resultArray, (obj) -> -obj.year
  console.dir resultArray
  resultArray

exports.getAllTags = ->
  posts = bucket.where {type: "blogPost"}
  _.uniq _.flatten _.map posts, (post) ->
    post.tags

getAllBlogPostsSorted = ->
  allPosts = bucket.where {type: "blogPost"}
  temp = _.sortBy allPosts, (blogPost) -> 0 - blogPost.date
  _.map temp, (post) ->
    extendWidthAuthor(post)

extendWidthAuthor = (blogPost) ->
  blogPost.author = bucket.getById(blogPost.author)
  blogPost

getYearAndMonthForDate = (timestamp) ->
  date = new Date(timestamp)
  {year: date.getFullYear(), month: utils.getSwedishMonthName(date.getMonth())}





