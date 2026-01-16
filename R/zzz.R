# Package internal environment
.pkgenv <- rlang::env()

.onLoad <- function(libname, pkgname) {
  rlang::env_bind(.pkgenv, "read_aozora" = memoise::memoise(read_aozora_impl()))
  rlang::env_bind(.pkgenv, "read_ldnws" = memoise::memoise(read_ldnws_impl()))
  rlang::env_bind(
    .pkgenv,
    "read_jrte_rte" = memoise::memoise(read_jrte_rte_impl())
  )
}

.onUnload <- function(libpath) {
  library.dynam.unload("ldccr", libpath)
}
