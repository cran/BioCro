test_that("c3photo is sensitive to changes in vcmax", {
    # redmine issue #1478

    # Set up basic inputs for the "c3_assimilation" module, which is
    # just a wrapper for the `c3photoC` function
    inputs <- list(
        Qabs = 1500,
        Tleaf = 10,
        temp = 10,
        rh = 0.7,
        jmax = 180,
        tpu_rate_max = 23,
        Rd = 1.1,
        b0 = 0.08,
        b1 = 5,
        Gs_min = 1e-3,
        Catm = 380,
        atmospheric_pressure = 101325,
        O2 = 210,
        theta = 0.7,
        StomataWS = 1,
        electrons_per_carboxylation = 4.5,
        electrons_per_oxygenation = 5.25,
        beta_PSII = 0.5,
        gbw = 1.2
    )

    # Get net assimilation for vmax = 100 micromol / m^2 / s
    inputs$vmax1 = 100
    a_100 <- evaluate_module("BioCro:c3_assimilation", inputs)$Assim

    # Get net assimilation for vmax = 10 micromol / m^2 / s
    inputs$vmax1 = 10
    a_10 <- evaluate_module("BioCro:c3_assimilation", inputs)$Assim

    # The two values should be different
    expect_false(a_100 == a_10)
})
