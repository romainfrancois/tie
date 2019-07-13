
#' @importFrom rlang quos
#' @export
tie <- quos

#' @importFrom rlang quo_get_expr quo_get_env is_symbol as_string is_missing
#' @importFrom rlang sym new_quosure enquo eval_tidy quo_expr quo
#' @importFrom purrr map_chr map pluck simplify keep
#' @importFrom dplyr summarise mutate select
#' @importFrom assertthat assert_that
#' @importFrom magrittr %>% set_names
tie_separate <- function(x){
  expr <- quo_get_expr(x)
  env  <- quo_get_env(x)

  # test that this of form `bow( tie() :=  )`
  assert_that( identical(expr[[1]], sym(":=") ) )
  assert_that( identical(expr[[2]][[1]], sym("tie") ) )

  lhs <- new_quosure(expr[[2]], env)

  bits <- map_chr( eval_tidy(lhs, env = env), function(q){
    xp <- quo_expr(q)
    if( is_missing(xp) ){
      ""
    } else if( is_symbol(xp) ){
      as_string(xp)
    } else {
      eval_tidy( xp, env = env )
    }
  })

  rhs <- quo( list(!!new_quosure(expr[[3]], env) ) )

  exprs <- map(seq_along(bits), ~ quo(simplify(map(..tmp.., !!.x))) ) %>%
    set_names(bits) %>%
    keep( bits != "" )

  list(rhs=rhs, exprs=exprs)
}



#' Classy neckwears
#'
#' `bow` and `neck` can be combined to `tie` to do something similar to `dplyr::summarise` and `dplyr::mutate`, but allowing to express how to redistribute parts of the results to their own column.
#'
#' @importFrom dplyr summarise mutate select
#' @importFrom rlang enquo
#'
#' @examples
#' library(dplyr)
#'
#' iris %>%
#'   group_by(Species) %>%
#'   bow( tie(min, max) := range(Sepal.Length) )
#'
#' iris %>%
#'   group_by(Species) %>%
#'   neck( tie(min, max) := range(Sepal.Length) )
#'
#' iris %>%
#'   group_by(Species) %>%
#'   bow( tie("min", "max") := range(Sepal.Length) )
#'
#' small <- "min"
#' big   <- "max"
#' iris %>%
#'   group_by(Species) %>%
#'   bow( tie(!!small, !!big) := range(Sepal.Length) )
#'
#' iris %>%
#'   group_by(Species) %>%
#'   bow( tie(,q25,q50,q75,) := quantile(Sepal.Length) )
#'
#'
#'
#' @export
bow <- function(data, x){
  ts = tie_separate(enquo(x))

  summarise( data, ..tmp.. = !!ts$rhs ) %>%
    mutate( !!!ts$exprs ) %>%
    select( -..tmp..)
}

#' @rdname bow
#' @importFrom dplyr summarise mutate select
#' @importFrom rlang enquo
#' @export
neck <- function(data, x){
  ts = tie_separate(enquo(x))

  mutate( data, ..tmp.. = !!ts$rhs ) %>%
    mutate( !!!ts$exprs ) %>%
    select( -..tmp..)
}

