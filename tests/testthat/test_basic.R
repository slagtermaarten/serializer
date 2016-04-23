context('Fundamentals')

test_that('Read and write', {
  serializer <- gen_serializer()
  serializer(a <- long_computing_func())
  expect_equal(a, 'return value')
  # [1] 'return value'
  rm(a)
  serializer(a <- long_computing_func())
  expect_equal(a, 'return value')
})

test_that('Clearing objects', {
  serializer <- gen_serializer()
  serializer(a <- long_computing_func())
  expect_equal(file.exists(file.path('saved-objects', 'a.rds')), T)
  clear_object(a <- long_computing_func())
  expect_equal(file.exists(file.path('saved-objects', 'a.rds')), F)
})

test_that('Clearing storage folder', {
  serializer <- gen_serializer()
  clear_all_objects()
  expect_equal(file.exists(file.path('saved-objects')), F)
})
