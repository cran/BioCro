\name{model_test_case}

\alias{model_test_case}

\title{Define BioCro model test cases}

\description{
  BioCro models can be tested using test cases, which are sets of known outputs
  that correspond to particular inputs. The \code{model_test_case} function
  defines such a test case.

  Note that \emph{model tests} are distinct from the \emph{module tests}
  described in \code{\link{module_testing}}.
}

\usage{
  model_test_case(
    test_case_name,
    model_definition,
    drivers,
    check_outputs,
    directory = '.',
    quantities_to_ignore = character(),
    row_interval = 24,
    digits = 5,
    relative_tolerance = 1e-3
  )
}

\arguments{
  \item{test_case_name}{A string describing the test case.}

  \item{model_definition}{
    A list defining a model, as described in the documentation for
    \code{\link{crop_model_definitions}}.
  }

  \item{drivers}{
    A set of drivers to be passed to \code{\link{run_biocro}} along with the
    \code{model_definition}.
  }

  \item{check_outputs}{
    A logical value indicating whether to compare the simulation output against
    a stored result.
  }

  \item{directory}{
    A relative or absolute path to a directory containing a stored simulation
    result. Only used when \code{check_outputs} is \code{TRUE}.
  }

  \item{quantities_to_ignore}{
    A character vector of any quantities that should not be compared against the
    stored results. Only used when \code{check_outputs} is \code{TRUE}.
  }

  \item{row_interval}{
    Determines which rows are saved and compared when using
    \code{\link{update_stored_model_results}},
    \code{\link{compare_model_output}}, or
    \code{\link{run_model_test_cases}}. Only used when \code{check_outputs} is
    \code{TRUE}.
  }

  \item{digits}{
    Passed to \code{\link{signif}} to round values when storing saved results.
    Only used when \code{check_outputs} is \code{TRUE}.
  }

  \item{relative_tolerance}{
    A relative tolerance to be used when comparing new values against stored
    ones. This value will be passed to \code{\link{all.equal}} as its
    \code{tolerance} input argument. Only used when \code{check_outputs} is
    \code{TRUE}.
  }
}

\details{
  The \code{model_test_case} function forms the basis for the BioCro model
  testing system. See \code{\link{model_testing}} for more information.

  With the default settings:
  \itemize{
    \item Every 24 rows of the simulation output will be stored and compared.
          When using drivers with an hourly time step, this corresponds to one
          row for each day.
    \item Values in the stored simulation results will be rounded to five
          significant digits. This reduces the size of the stored result file.
    \item The value of the relative tolerance was chosen to be the smallest
          value that enabled the tests to pass on all operating systems.
  }

  These default settings have proven useful for the BioCro
  \code{\link{miscanthus_x_giganteus}}, \code{\link{willow}}, and
  \code{\link{soybean}} models.
}

\value{
  A list that defines a model test case, which can be passed to
  \code{\link{update_stored_model_results}}, \code{\link{compare_model_output}},
  or \code{\link{run_model_test_cases}}.
}

\seealso{
  \itemize{
    \item \code{\link{model_testing}}
    \item \code{\link{crop_model_definitions}}
    \item \code{\link{update_stored_model_results}}
    \item \code{\link{compare_model_output}}
    \item \code{\link{run_model_test_cases}}
  }
}

\examples{
# Define a test case for the miscanthus model
miscanthus_test_case <- model_test_case(
    'miscanthus_x_giganteus',
    miscanthus_x_giganteus,
    get_growing_season_climate(weather$'2005'),
    TRUE,
    tempdir(),
    'soil_evaporation_rate'
)

# The result is a specially formatted list
str(miscanthus_test_case)
}
