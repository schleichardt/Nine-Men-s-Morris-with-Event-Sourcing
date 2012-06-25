mergeJson = (defaultValues, newJson) ->
  result = {}
  $.extend result, defaultValues, newJson
  result

contains = (haystack, needle) -> haystack.indexOf(needle) != -1