# serializeR

Wrapper around existing serialization infrastructure in R (writeRDS) that
obviates typical associated boilerplate code. This project is premeaturely published, so 
use at your own risk and convenience. I'm considering a migration to an OOP design using 
R's reference classes.

## Usage example

First create a serializer function

    serializer <- gen_serializer()

The cache folder is set to `saved-objects` in the current working directory of
the R session by default.

Example of a long running function whose results you would want to
store to save future CPU time

    longComputingFunc <- function() {
      # Wait 2 seconds
      Sys.sleep(2)
      return("return value")
    }
    a <- longComputingFunc()

The first time you run this, the function call will be evaluated. The second
time, the evaluated expression in the right hand side of the assignment will
have been stored on disk using `saveRDS` and will be assigned to `a`

    serializer(a <- longComputingFunc())
    print(a)
    # [1] "return value"

Remove the value to illustrate starting out a new session with regards to `a`

    rm(a)

This time the RHS of the assignment will be read from memory

    serializer(a <- longComputingFunc())
    print(a)
    # [1] "return value"

To remove a stored object - for instance because the upstream code has changed
and you want this to be reflected in the object - you can do the following:

    clear_object(a)
    # alternative
    clear_object(a <- longComputingFunc())

The inclusion of this functionality in the `serializeR` package illustrates the
difference between `serializeR` and knitR caching. Unlike in knitR caching,
upstream code changes will not break the stored result but rather only variable
name change on the LHS of assignments will accomplish this. For my own
purposes, this is a great time saver as I often make small stylistic changes to
long running code that I know will not affect the returned value. Be mindful of
this difference and *do* use knitr caching if you would rather always be on the safe
side!

To clear all objects and remove the cache folder in its entirety

    clear_all_objects()


# Known issues

Data.table objects don't like to be wrapped using the functionality in this package, YMMV.
