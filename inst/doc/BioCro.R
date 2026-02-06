## ----include = FALSE----------------------------------------------------------
options(
  crayon.enabled = FALSE, # crayon colors cause latex issues
  cli.num_colors = 1
)

knitr::opts_chunk$set(
  error = FALSE, # stop on errors to help with troubleshooting
  collapse = TRUE,
  comment = "#>",
  fig.width = 6,
  fig.height = 5,
  fig.align = "center"
)

## -----------------------------------------------------------------------------
library(BioCro)
library(lattice)

result <- with(soybean, {run_biocro(
  initial_values,
  parameters,
  soybean_weather$'2002',
  direct_modules,
  differential_modules,
  ode_solver
)})

xyplot(Stem + Leaf ~ TTc, data = result, type='l', auto = TRUE)

