# serializeR

Wrapper around existing serialization infrastructure in R (writeRDS) that
obviates typical associated boilerplate code. This project is extremely
premeaturely published, so use at your own risk and convenience. I'm
considering to migrate to a OOP design using reference classes.

## Usage example

First create a serializer function, define storage location

    serializer <- genSerializer(saveFolder = 'my-objects')

Example of a long running function whose results you would want to
store/serialize to save future CPU time

    longComputingFunc <- function() {
      Sys.sleep(4)
      return("return value")
    }
    a <- longComputingFunc())

The first time you run this, the function call will be evaluated. The second
time, the value that was previously stored in memory will be assigned to `a`

    serializer(a <- longComputingFunc())
    print(a)
    # [1] "return value"

Remove the value to illustrate starting out in a fresh session

    rm(a)

This time the value will be read from memory

    serializer(a <- longComputingFunc())
    print(a)
    # [1] "return value"

To remove a stored object - for instance because the upstream code has changed
and you want this to be reflected in the object - you can do the following:

    clearObject(a)
    # alternative
    clearObject(a <- longComputingFunc())

To clear all objects

    clearObjects()

