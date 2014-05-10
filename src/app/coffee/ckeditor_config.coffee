CKEDITOR.editorConfig = (config) ->

  config.extraPlugins = 'justify'

  config.toolbar = [
    [
      "Format"
      "Templates"
      "Bold"
      "Italic"
      "Underline"
    ]
    [
      "JustifyLeft"
      "JustifyCenter"
      "JustifyRight"
      "JustifyBlock"
      "-"
      "NumberedList"
      "BulletedList"
      "-"
      "Outdent"
      "Indent"
    ]
    [
      "Undo"
      "Redo"
      "RemoveFormat"
      "-"
      "Link"
      "Unlink"
      "-"
    ]
    ["Source"]
    ["Maximize"]
  ]
  config.format_tags = "p;h2;h3"
  config.allowedContent = true
  config.language = "sv"
  config.linkShowTargetTab = false
  config.removeDialogTabs = "image:advanced;image:Link;link:advanced;"
  return

