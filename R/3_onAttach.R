.onAttach <- function(libname, pkgname) {
  packageStartupMessage(paste(
    "\nspulsconnect",
    utils::packageDescription("spulsconnect")$Version,
    "https://folkehelseinstituttet.github.io/spulsconnect"
  ))
  packageStartupMessage("\nIf you have any technical problems, please contact:")
  packageStartupMessage("- RichardAubrey.White@fhi.no")
  packageStartupMessage("- Beatriz.ValcarcelSalamanca@fhi.no")
  packageStartupMessage("- CalvinChen-Kai.Chiang@fhi.no")
}
