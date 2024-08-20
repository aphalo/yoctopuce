#' Initialise the API
#'
#' Import the API and USB-module-specific functions and register to communicate
#' with USB modules through a virtual or physical hub.
#'
#' @param ... character Names of the yoctopuce Python modules to import from
#'   the 'yoctopuce' Python library supporting the functions in the USB modules
#'   that will be used.
#' @param hub.url character vector of URLs to YoctoHubs, including the port on
#'   the hub to connect to, defaults to a virtual hub running locally, but
#'   hardware and virtual hubs can be accessed through a LAN or the internet.
#'   Passing `NULL` or `character()` skips hub registration.
#' @param force logical Force registration even if the same URL has been already
#'    registered.
#'
#' @details
#' This function is used to initialize the API and register to use one or more hubs.
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
#' from one R session to a later one, their link to the Python library is
#' neither persistent nor restored. Thus, function `init_yoctopuce()` has to be
#' run at the start of each new R session, and Python modules reimported, even
#' if the objects have been saved. In general it is recommended not to import
#' the same Python modules more than once on a given session, although in
#' practice this does not seem to cause difficulties with the 'yoctopuce' Python
#' library.
#'
#' @export
#'
init_yoctopuce <- function(..., hub.url = "localhost:4444", force = FALSE) {

  modules <- list(...)
  for (i in seq_along(modules)) {
    if (!grepl("^yoctopuce\\.", modules[[i]])) {
      modules[[i]] <- paste("yoctopuce", modules[[i]], sep = ".")
    }
  }

  # 'yocto_api' is always needed!
  # set union, in addition, removes any duplicates
  modules <- union("yoctopuce.yocto_api", modules)

  message("Importing Python modules into R objects:")
  for (module in modules) {
    short.name <- gsub("^yoctopuce\\.", "", module)
    if (py_module_available(module)) {
      if (!exists(short.name) || !length(get(short.name))) {
        message("Module '", module, "' imported as '", short.name, "'")
        assign(short.name, import(module), inherits = TRUE)
      } else {
        message("Existing object '", short.name, "' not replaced.")
      }
    } else {
      warning("Module '", module, "' not found!")
    }
  }

  if (length(hub.url)) {
    register_hubs(hub.url = hub.url, force = force)
  }
  invisible(registered.hubs)
}

#' @rdname init_yoctopuce
#'
#' @export
#'
register_hubs <- function(hub.url = "localhost:4444", force = FALSE) {
  if (length(hub.url)) {
    # protects in case registered_hubs object is deleted by user
    if (!exists("registered.hubs", inherits = TRUE, mode = "character")) {
      assign("registered.hubs", character(), inherits = TRUE)
    }
    for (hub in hub.url) {
      if (!force || hub %in% registered.hubs) {
        errmsg <- yocto_api$YRefParam()
        if (yocto_api$YAPI$RegisterHub(hub, errmsg) != yocto_api$YAPI$SUCCESS) {
          stop("Init error on ", hub, ": ", errmsg$value)
        }
        assign("registered.hubs", union(registered.hubs, hub), inherits = TRUE)
      }
    }
  }

  invisible(registered.hubs)
}

utils::globalVariables("yocto_api")
