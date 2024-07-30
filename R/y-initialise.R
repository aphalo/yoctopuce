#' Initialise the API
#'
#' Import the API and module-specific extensions and register to communicate
#' through a virtual or physical hub.
#'
#' @param ... character Names of the yoctopuce APIs to import.
#' @param hub.url character vector of URLs to YoctoHubs, including the port on
#'   the hub to connect to, defaults to a virtual hub running locally, but
#'   hardware and virtual hubs can be accessed through a LAN or the internet.
#'   Passing `NULL` or `character()` skips hub registration.
#'
#' @details
#' With this function we initialize the API and register to use a specific hub.
#' The main API can be accessed through object \code{yocto_api} using the
#' \code{$} notation, and specific APIs using objects named after the APIs.
#' Beware that there is more than one level of nesting, so more than one `$` can
#' be needed. For example, for Python module 'yoctopuce.yocto_relay' the object
#' \code{yocto_relay} is created and can be used to access its members.
#'
#' This function uses the Python API to check that the requested API extensions
#' are available, so it should work unchanged with future updates to the
#' YoctoPuce Python library, including after new modules are released as long
#' as the Python library installed is up-to-date.
#'
#' @section Warning!:
#' Although the objects created to access Python library modules can persist
#' from one R session to a later one, their link to the Python library is not
#' restored. This, function `y_initialise` has to be run at the start of a new
#' R session, and Python modules reimported. In general it is recommended not
#' to import the same Python modules more than once on a given session.
#'
#' @export
#'
y_initialise <- function(..., hub.url = "localhost:4444") {
  modules <- list(...)
  for (i in seq_along(modules)) {
    if (!grepl("^yoctopuce\\.", modules[[i]])) {
      modules[[i]] <- paste("yoctopuce", modules[[i]], sep = ".")
    }
  }

  # 'yocto_api' is always needed!
  # set union, in addition, removes any duplicates
  modules <- union("yoctopuce.yocto_api", modules)

  for (module in modules) {
    short.name <- gsub("^yoctopuce\\.", "", module)
    if (py_module_available(module)) {
      message("Importing: ", module)
      assign(short.name, import(module), inherits = TRUE)
    } else {
      warning("Python module '", module, "' not found!")
    }
  }

  if (length(hub.url)) {
    # protects in case registered_hubs object is deleted by user
    if (!exists("registered_hubs", inherits = TRUE, mode = "character")) {
      assign("registered_hubs", character(), inherits = TRUE)
    }
    for (hub in hub.url) {
      errmsg <- yocto_api$YRefParam()
      if (yocto_api$YAPI$RegisterHub(hub, errmsg) != yocto_api$YAPI$SUCCESS) {
        stop("Init error on ", hub, ": ", errmsg$value)
      }
      registered_hubs <- union(registered_hubs, hub)
    }
  }

  invisible(registered_hubs)
}

#' @rdname y_initialise
#'
y_initialize <- y_initialise

utils::globalVariables("yocto_api")
