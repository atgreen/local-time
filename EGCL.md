# EGCL support

The `egcl` branch uses `EGCL-EXT:GET-PRECISE-TIME` for the current wall clock.
It converts universal seconds to Unix seconds while retaining the native
nanosecond fraction. Other implementations retain their existing clock paths.

Requires EGCL with `EGCL-EXT:GET-PRECISE-TIME` (tested with EGCL 0.0.10,
revision b94618ece). From this repository's root, run:

```sh
egcl --no-init --load test/egcl-clock.lisp
```

The focused regression bounds each clock sample by native samples, checks the
fractional range and precision, and exercises `NOW` through a Unix timestamp
roundtrip. It failed against the unmodified second-resolution fallback and
passes with the adapter. This is not a claim that the complete upstream suite
has run. EGCL integration work: `bliss-wne9.10`.
