context("bowtie")

data <- dplyr::group_by( iris, Species)

expected <- dplyr::summarise( data,
  min = min(Sepal.Length), max = max(Sepal.Length)
)

test_that("tie understand raw symbol", {
  res <- data %>%
    bow( tie(min, max) := range(Sepal.Length) )
  expect_identical(res, expected)
})

test_that("tie understand literal strings", {
  res <- data %>%
    bow( tie("min", "max") := range(Sepal.Length) )
  expect_identical(res, expected)
})

test_that("tie unquotes", {
  small <- "min"
  big   <- "max"
  res <- data %>%
    bow( tie(!!small, !!big) := range(Sepal.Length) )
  expect_identical(res, expected)
})
