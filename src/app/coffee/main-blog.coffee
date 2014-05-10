  $('.link-share').click (e) ->
    e.preventDefault()
    $(this).parents('.share').find('.inp-copy').removeClass('hide')

  $('.inp-copy').click ->
    $(this).select()


