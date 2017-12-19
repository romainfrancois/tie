
#' @export
tie <- structure( NA, class = "tie_proxy")

#' @importFrom rlang quos quo_name quo_is_missing
#' @importFrom assertthat assert_that
#' @export
`[<-.tie_proxy` <- function(x, ..., value){
  dots <- quos(...)
  assert_that( length(value) >= length(dots) )
  env <- parent.frame()

  for( i in seq_along(dots) ){
    dot <- dots[[i]]
    if( !quo_is_missing(dot) ){
      assign( quo_name(dot), value[[i]], envir = env)
    }
  }
  invisible(x)
}
