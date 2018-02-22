
#' @importFrom rlang quos
#' @export
tie <- quos

#' @importFrom rlang quo_get_expr quo_get_env is_symbol as_string is_missing
#' @importFrom rlang sym new_quosure enquo eval_tidy quo_expr quo
#' @importFrom purrr map_chr map pluck simplify keep
#' @importFrom dplyr summarise mutate select
#' @importFrom assertthat assert_that
#' @importFrom magrittr %>% set_names
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
  x <- enquo(x)
  expr <- quo_get_expr(x)
  env  <- quo_get_env(x)

  # test that this of form `bow( tie() :=  )`
  assert_that( identical(expr[[1]], sym(":=") ) )
  assert_that( identical(expr[[2]][[1]], sym("tie") ) )

  lhs <- new_quosure(expr[[2]], env)

  bits <- map_chr( eval_tidy(lhs, env = env), function(q){
    xp <- quo_expr(q)
    if( is_missing(xp)){
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

  summarise( data, ..tmp.. = !!rhs ) %>%
    mutate( !!!exprs ) %>%
    select( -..tmp..)

}
