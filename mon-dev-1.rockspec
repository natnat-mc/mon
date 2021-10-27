package = "mon"
version = "dev-1"
source = {
   url = "*** please add URL for source tarball, zip or repository here ***"
}
description = {
   homepage = "*** please enter a project homepage ***",
   license = "*** please specify a license ***"
}
build = {
   type = "builtin",
   modules = {}
}
dependencies = {
   "lua>=5.3",
   "lua-cjson==2.1.0",
   "lua-dkjson>=2.5",
}
