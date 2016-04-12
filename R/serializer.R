#' Create a serializer functional which takes expressions. 
#' The serializer function will only evaluate the expression if the result could
#' not be found in the cache folder, storing the result for future evaluations
#'
#' @param saveFolder location to store serialized objects
#' @return function that can serialize objects
genSerializer <- function(saveFolder = 'saved-objects') {
  dir.create(saveFolder, showWarnings = F)

  mySerialize <- function(ex) {
    o.name <- deparse(formula.tools::lhs(substitute(ex)))
    o.path <- file.path(saveFolder, paste0(o.name, '.rds'))

    if (!file.exists(o.path)) {
      # Compute expression
      o.val <- eval(rhs(substitute(ex)))
      # Save object
      saveRDS(o.val, file = o.path)
    }
    invisible(assign(o.name, readRDS(file = o.path), envir = parent.frame()))
  }
}


#' Remove all serialized objects
#'
#' @param saveFolder location of serialized objects
clearObjects <- function(saveFolder = 'saved-objects')
  unlink(saveFolder, recursive = T)


#' Remove single objects
#'
#' @param ex object to be removed
#' @param saveFolder location of serialized objects
clearObject <- function(ex, saveFolder = 'saved-objects') {
  if (is.expression(ex)) {
    o.name <- deparse(formula.tools::lhs(substitute(ex)))
  } else if (is.object(ex)) {
    o.name <- deparse(substitute(ex))
  } else if (is.character(ex)) {
    o.name <- ex
  } else {
    stop('Do not know how to handle input of class', ex, ', ', class(ex))
  }

  o.path <- file.path(saveFolder, paste0(o.name, '.rds'))
  file.remove(o.path)
}
