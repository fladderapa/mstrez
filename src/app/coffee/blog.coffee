$(document).ready ->

  editor = new wysihtml5.Editor('txt-editor', {
    toolbar: 'txt-editor-toolbar',
    parserRules: wysihtml5ParserRules
  })
  
  
  $('#dropZone').imageUploader({
      fileField     : '#files',
      urlField      : '#url',
      hideFileField : true,
      hideUrlField  : true,
      url           : window.location + '/image',
      thumbnails    : {
          crop: 'zoom',
          width: 480,
          height: 320,
          div:$("#thumbnails")
      },
      afterUpload: (data) ->
        $("#dropZone").hide()
        $("#deleteImage").css('display', 'block')
        $('#imageid').attr('value', data)
  })
  $('#deleteImage').click () ->
    $('#imageid').attr('value', "")
    $("#dropZone").show()
    $("#deleteImage").css('display', 'none')
    $("#thumbnails").html("")
