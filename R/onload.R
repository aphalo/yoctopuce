.onLoad <- function(...) {
  reticulate::use_virtualenv("r-yoctopuce", required = FALSE)
  assign("registered.hubs", character(), inherits = TRUE)
}
