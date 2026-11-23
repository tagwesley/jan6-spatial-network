for (f in sort(list.files("R", full.names = TRUE))) { cat("\n==>", f, "\n"); source(f, echo = FALSE) }
