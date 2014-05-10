require("bucket-node").initSingletonBucket 'mami.db', (data) ->
  ###
  Module dependencies
  ###
  coffeescript   = require "coffee-script"
  coffeeMiddleware  = require "coffee-middleware"
  less           = require "less-middleware"
  express        = require "express"
  routes         = require "./routes"
  api            = require "./routes/api"
  login          = require './routes/login'
  blog           = require "./routes/blog"
  user           = require "./routes/user"
  upload         = require "./routes/uploads"
  admin          = require './routes/admin'
  http           = require "http"
  path           = require "path" 
  flash          = require "connect-flash"



  app = express()

  app.configure ->
    app.set "port", process.env.PORT or 3010
    app.set "views", __dirname + "/views"
    app.set "view engine", "jade"
    app.use express.logger("dev")
    app.use express.bodyParser()
    app.use express.methodOverride()
    app.use express.cookieParser("lolcat")
    app.use express.session()
    app.use flash()
    app.use app.router
    app.use express.favicon(__dirname + "/public/img/favicon.ico")

    # Less middleware
    app.use "/css", less(
      src: __dirname + "/app/less"
      dest: __dirname + "/compiled/css"
      paths: [path.join(__dirname, "compiled", "lib")]
    )

    # Coffee middleware
    app.use "/js", coffeeMiddleware({
      src  : __dirname + "/app/coffee"
      dest : __dirname + "/compiled/js"
    })

    app.use "/css", express.static(path.join(__dirname, "compiled/css"))
    app.use "/js", express.static(path.join(__dirname, "compiled/js"))
    app.use "/lib", express.static(path.join(__dirname, "compiled/lib"))
    app.use express.static(path.join(__dirname, "public"), {maxAge:-1})


  app.use express.errorHandler()  if app.get("env") is "development"

  ###
  Routes
  ###

  app.get "/", routes.index

  app.get "/blogg", routes.blog
  app.get "/blogg/:id", routes.singleBlogPost


  app.get "/admin", login.authenticateAdmin, blog.all
  app.get "/admin/signin", login.adminSignin
  app.get "/admin/logout", login.adminLogout
  app.post "/admin/login", login.loginAdmin

  app.get "/admin/blog", login.authenticateAdmin, blog.all
  app.get "/admin/blog/new", login.authenticateAdmin, blog.new
  app.get "/admin/blog/:id", login.authenticateAdmin, blog.single
  app.post "/admin/blog/:id/image", login.authenticateAdmin, upload.saveImage
  app.post "/admin/blog/:id", login.authenticateAdmin, blog.saveBlogPost
  app.post "/admin/blog/delete/:id", login.authenticateAdmin, blog.deleteBlogPost

  app.get "/admin/upload", login.authenticateAdmin, admin.uploads
  app.post "/admin/upload", login.authenticateAdmin, admin.fileUpload
  app.post "/admin/upload/delete", login.authenticateAdmin, admin.deleteFiles

  app.get "/admin/sendmail", login.authenticateAdmin, admin.sendmail
  app.post "/admin/sendmail", login.authenticateAdmin, admin.sendPrMail

  #404
  app.use (req, res, next) ->
    res.status 404
  
    if req.accepts("html")
      res.render "404",
        url: req.url

  ###
  Start Server
  ###

  http.createServer(app).listen app.get("port"), ->
    console.log "Express server listening on port " + app.get("port")

