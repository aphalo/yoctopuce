#' Initialise the API
#'
#' Import the API and module-specific extensions and register to communicate
#' through a virtual or physical hub.
#'
#' @param ... character Names of the yoctopuce APIs to import.
#' @param hub.url character URL including port of the hub to connect to,
#'   defaults to a virtual hub running locally, but hardware and virtual
#'   hub can be accessed through a LAN or the internet.
#'
#' @details
#' With this function we initialize the API and register to use a specific
#' hub. The main API can be accessed through object \code{yocto_api} using
#' the \code{$} notation. Be aware that there is more than one level of
#' nesting. Say for 'yoctopuce.yocto_relay' the object \code{yocto_relay} is
#' created and can be used to access its members.
#'
#' This function uses the Python API to check that the requested API extensions
#' are available, so it should work unchanged with future updates to the
#' YoctoPuce Python library, including after new modules are released as long
#' as the Python libray installed is up-to-date.
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

  # always needed
  stopifnot("yoctopuce API not found" =
              reticulate::py_module_available("yoctopuce.yocto_api"))
  yocto_api <- import("yoctopuce.yocto_api")

  modules <- setdiff(modules, "yoctopuce.yocto_api")

  for (module in modules) {
    if (reticulate::py_module_available(module)) {
      message("Importing ", module)
      assign(gsub("^yoctopuce\\.", "", module),
             import(module))
    } else {
      warning("Failed to import ", module)
    }
  }

  errmsg <- yocto_api$YRefParam()

  if (yocto_api$YAPI$RegisterHub(hub.url, errmsg) != yocto_api$YAPI$SUCCESS) {
    stop("Init error: ", errmsg$value)
  }

}

#' @rdname y_initialise
#'
y_initialize <- y_initialise
