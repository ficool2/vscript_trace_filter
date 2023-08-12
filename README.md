# VScript Trace Filter
Simple standalone library that extends VScript traces with entity filtering and gathering.

# Usage
Include the `trace_filter.nut` script, i.e. `IncludeScript("trace_filter")`. 
This only needs to be done once, multiple attempts to load the library will be ignored.

The library provides the following functions, which work similarly to the existing `TraceLineEx`/`TraceHull` functions.
* `TraceLineFilter`/`TraceHullFilter`: Setup with the same table as `TraceLineEx`/`TraceHull`, but a `filter` function is required. The function traces until the filter function returns `TRACE_STOP`, or if it hits the world/nothing. The function takes an `entity` argument, and it should return `TRACE_STOP` to accept the hit and stop tracing, or `TRACE_CONTINUE` to continue tracing.

* `TraceLineGather`/`TraceHullGather`: Setup with the same table as `TraceLineEx`/`TraceHull`, but a `filter` function is required. The function gathers all entities intersecting the trace that match the filter. Each "hit" is stored as a trace subtable in the new `hits` array in the original trace table. The function takes an `entity` argument, and it can return any of the following:
`TRACE_STOP`: Stops the trace and rejects the hit
`TRACE_OK_STOP`: Stops the trace and accepts the hit
`TRACE_CONTINUE`: Rejects the hit and continues the trace
`TRACE_OK_CONTINUE`: Accepts the hit and continues the trace

See included `trace_filter_example.nut` for an example of `TraceLineFilter` and `TraceLineGather`, which collects red players intersecting the player's crosshair.

# Limitations
Traces cannot filter out the static world (e.g. immoveable brushes and static props), they will always terminate the hit.
The script relies on the quirk of setting entity bounds to 0 0 0 temporarily, recursively retracing and reverting it after the trace. 
As a result, these traces are more expensive than regular traces. Gather traces are more expensive than filtered traces, as they do not early out and require copying multiple trace tables.
If you are running many of these traces at once, terminating traces in the filter function after a capped amount of filter calls may be a good idea.

# License
Do whatever the hell you want
