\name{module_write}

\alias{module_write}

\title{
  Generate a BioCro module header file.
}

\description{
  To facilitate the creation of new BioCro modules, \code{module_write}
  generates a BioCro module header file. Given a set of input and output
  variables, \code{module_write} will create a C++ header file ('.h' file) by
  filling in a template with the input and output variables, ensuring the
  correct C++ syntax for a BioCro module.
}

\usage{
  module_write(
    module_name,
    module_library,
    module_type,
    inputs,
    outputs,
    output_equations = NULL,
    input_units = NULL,
    output_units = NULL
  )
}

\arguments{
  \item{module_name}{
    A string for the module's name.
  }

  \item{module_library}{
    A string for the module's library namespace. E.g., \code{'biocro'}.
  }

  \item{module_type}{
    A string setting the module type: \code{'direct'} or \code{'differential'}.
  }

  \item{inputs}{
    A character vector of the module's input variables.
  }

  \item{outputs}{
    A character vector of the module's output variables.
  }

  \item{output_equations}{
    A character vector. The module's output variables will be updated with these
    variables. If \code{NULL}, a zero is inserted instead.
  }

  \item{input_units}{
    A character vector of the inputs' units. If \code{NULL}, no units are
    embedded.
  }

  \item{output_units}{
    A character vector of the outputs' units. If \code{NULL}, no units are
    embedded.
  }
}

\details{
    \code{type} should be either \code{'direct'} or \code{'differential'};
    however, \code{module_write} does not enforce this in case new module types
    are created in the future.
}

\value{
    A string containing a new BioCro module header file.
}

\note{
    This function returns a string and has no file I/O. Use
    \code{\link{writeLines}} to print the output to console, or to save the
    output. See examples below. Note that it is customary to name the header
    file with the same name as the module.

    \code{module_write} checks for duplicate input or output variables, and if
    detected, it will raise an error. In theory, this check should ensure that
    the generated module will compile correctly. However, it is still possible
    to define an module that is circular and will not pass the checks in
    \code{\link{validate_dynamical_system_inputs}}. See \verb{Example 4}.
}

\examples{
# Example 1
# Inputs as character vector
xs = c('x1','x2','x3')

# Units
xs_units <- c('Mg / ha', 'Mg / ha / hr', 'dimensionless')

# Outputs
ys = c('y1','y2')

out <- module_write('testmod', 'testlib', 'direct',
    inputs=xs, input_units= xs_units, outputs=ys)

# Use writeLines to print to console
writeLines(out)

\dontrun{
  # Use writeLines to save as a `.h` file
  writeLines(out, "./testmod.h")
}

# Example 2: A differential module
xs <- c('var_1','var_2')
out <- module_write('testmod', 'testlib', 'differential', xs, xs)
writeLines(out)

# Example 3: A module with pairwise names
# Here we use an outer product to generate pairwise combinations of
# tissues and pool types
tissues <- c('leaf', 'stem', 'root')
pools <- c('carbon', 'nitrogen')
xs <- as.vector(outer(tissues, pools, paste, sep = '_'))
out <- module_write('testmod', 'testlib', 'differential', xs, xs)
writeLines(out)

# Example 4: Circular modules

\dontrun{
  out <- module_write(inputs = c('x' ,'x'))

  # Will compile, but will cause a "circular quantities" error if it is used
  # in a BioCro simulation:
  out <- module_write('inconsistent', 'examplelib', type='direct',
          inputs = 'x', outputs = 'x')
}

}
