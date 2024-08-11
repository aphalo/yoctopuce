#' Install the yoctopuce Python library
#'
#' Python must be installed before installing the library. You can
#' use `reticulate::install_python` to install Python. Python and the
#' yoctopuce Python library need to be installed once, when first using R
#' package 'yoctopuce'.
#'
#' @param ... additional libraries or named parameters to pass to
#'   `reticulate::py_install`.
#' @param envname character The name of a Python environment where to install the
#'   library. Not to be confused with R language environments!
#'
#' @export
#'
install_yoctopuce <- function(..., envname = "r-yoctopuce") {
  reticulate::py_install("yoctopuce", envname = envname, ...)
}

