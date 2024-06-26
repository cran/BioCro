system_derivatives <- function(
    parameters = list(),
    drivers,
    direct_module_names = list(),
    differential_module_names = list()
)
{
    # The inputs to this function have the same requirements as the `run_biocro`
    # inputs with the same names
    error_messages <- check_run_biocro_inputs(
        list(),
        parameters,
        drivers,
        direct_module_names,
        differential_module_names
    )

    send_error_messages(error_messages)

    # If the drivers input doesn't have a time column, add one
    drivers <- add_time_to_weather_data(drivers)

    # Make module creators from the specified names and libraries
    direct_module_creators <- sapply(
        direct_module_names,
        check_out_module
    )

    differential_module_creators <- sapply(
        differential_module_names,
        check_out_module
    )

    # C++ requires that all the variables have type `double`
    parameters <- lapply(parameters, as.numeric)
    drivers <- lapply(drivers, as.numeric)

    # Create a function that returns a derivative
    function(t, differential_quantities, parms)
    {
        # Note: parms is required by LSODES but we aren't using it here. We
        # don't need to do any format checking here because LSODES will have
        # already done it.

        # Call the C++ code that calculates a derivative
        derivs <- .Call(
            R_system_derivatives,
            as.list(differential_quantities),
            t,
            parameters,
            drivers,
            direct_module_creators,
            differential_module_creators
        )

        # LSODES requires the output from this function to be a list whose first
        # element is a named vector of the derivatives in the same order as in
        # the `differential_quantities` input. Right now `derivs` is a list, so
        # we need to convert it to a properly ordered vector and wrap that
        # vector in a list.
        result <- numeric(length(differential_quantities))
        for (i in seq_along(result)) {
            result[i] <- derivs[[names(differential_quantities)[i]]]
        }
        names(result) <- names(differential_quantities)
        return(list(result))
    }
}
