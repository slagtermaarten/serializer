#' Create a serializer function which takes expressions to be evaluated only when
#' their result has not been computed already.
#'
#' The serializer function will only evaluate its argument, an assignment, if
#' the assignment's result could not be found in the cache folder, storing the
#' right hand side of the assignment in the cache folder to prevent future evaluations
#'
#' @param cache_loc location to store serialized objects
#' @return function that can serialize objects
gen_serializer <- function(cache_loc = 'saved-objects') {
  dir.create(cache_loc, showWarnings = F)
  force(cache_loc)

  so <- function(ex) {
    o.name <- deparse(formula.tools::lhs(substitute(ex)))
    o.path <- file.path(cache_loc, paste0(o.name, '.rds'))

    if (!file.exists(o.path)) {
      # Compute expression
      o.val <- eval(formula.tools::rhs(substitute(ex)))
      # Save object
      saveRDS(o.val, file = o.path)
    }
    invisible(assign(o.name, readRDS(file = o.path), envir = parent.frame()))
  }
  class(so) <- c('serializer', 'function')
  return(so)
}


print.serializer <- function(co) {
  loc <- environment(co)$cache_loc
  ## Inventorise stored objects
  so <- gsub("\\.rds$", "", list.files(loc, full.name = F))
  print(sprintf('Cacher storing objects in: %s. Found files: %s', loc,
                paste(so, collapse = ", ")))
}


#' Remove all serialized objects
#'
#' @param cache_loc location of serialized objects
clear_all_objects <- function(cache_loc = 'saved-objects') {
  unlink(cache_loc, recursive = T)
}


#' Remove single objects
#'
#' @param ex object to be removed.  if \code{ex} is neither an object
#' nor a character string, it is assumed to be an assignment in the form
#' \code{a <- func("value")}
#' @param cache_loc location of serialized objects
clear_object <- function(ex, cache_loc = 'saved-objects') {
  if (is.object(ex)) {
    o.name <- deparse(substitute(ex))
  } else {
    o.name <- deparse(formula.tools::lhs(substitute(ex)))
  }

  o.path <- file.path(cache_loc, paste0(o.name, '.rds'))
  if (file.exists(o.path)) {
    return(file.remove(o.path))
  } else {
    warning('Cannot find .rds of ', o.name)
  }
}


#' Example long running func (for testing purposes)
#'
#'
long_computing_func <- function() {
  Sys.sleep(1)
  return('return value')
}
