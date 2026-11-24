# Routing Results

This directory contains OpenROAD global-routing and detailed-routing
logs, metrics, and reports for the conventional and pipelined MAC designs.

## Detailed-routing results

Both designs completed detailed routing with zero remaining router
violations.

- Conventional MAC: final detailed-routing iteration reported 0 violations.
- Pipelined MAC: iteration 5 reported 6 violations; iteration 6 reduced
  the count to 0.

The pipelined report `5_route_drc_intermediate_iter5.rpt` is retained
as an intermediate diagnostic snapshot. It is not the final routing
result.

Both detailed-routing logs report zero antenna violations, zero net
violations, and zero pin violations.

The router's internal violation count is not a substitute for
independent signoff DRC. KLayout DRC and LVS are separate verification
steps and have not yet been established by these routing results.
