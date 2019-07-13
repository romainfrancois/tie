context("missing")

data <- dplyr::group_by( iris, Species)

test_that("bowtie understand missing", {
  res <- data %>%
    bow( tie(,max) := range(Sepal.Length))

  expect_identical(res,
    dplyr::summarise(data, max = max(Sepal.Length) )
  )

  res <- data %>%
    bow( tie(min,) := range(Sepal.Length))

  expect_identical(res,
    dplyr::summarise(data, min = min(Sepal.Length) )
  )
})

test_that("necktie understand missing", {
  res <- data %>%
    neck( tie(,max) := range(Sepal.Length))

  expect_identical(res,
    dplyr::mutate(data, max = max(Sepal.Length) )
  )

  res <- data %>%
    neck( tie(min,) := range(Sepal.Length))

  expect_identical(res,
    dplyr::mutate(data, min = min(Sepal.Length) )
  )
})
