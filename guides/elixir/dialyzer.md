# Dialyzer

[Dialyer](http://erlang.org/doc/man/dialyzer.html) is a static analysis tool which detects type
errors in our Elixir code.  We use the [Dialyxir](https://github.com/jeremyjh/dialyxir) wrapper,
which provides output in Elixir (as opposed to Erlang) syntax.

## Usage

To run Dialyzer locally:
`dea mix mix dialyzer --halt-exit-status`

Dialyzer may take several minutes to built its Persistent Lookup Table, after which
subsequent runs should be faster.

Dialyzer is also included in our CI pipeline.

## Interpreting/Debugging Errors

`function has no local return`

The function is expected to crash.  If there are other errors in the run, it's worth investigating
them first, as a crash may be an effect of one of these more descriptive errors.

Keep in mind that the function may not actually ever crash (in tests or in the live system), but
Dialyzer thinks it will because there is a spec mismatch for a function call in its body.

`The @spec for the function does not match the success typing of the function.`

Based on the spec that was written for it, the function is expected to pass invalid params to
other functions called within its body.  The 'success typing' is the typespec that would make
the function pass the correct types to the functions it composes.

If there are difficulties determining which term in the typespec is causing the violation,
one can paste the suggested success typing in as the typespec, and incrementally
change terms back to the originals until the violation occurs again.  Then the developer will know
that the last changed term is the one causing the violation.

## General Tips

- Dialyzer doesn't catch all type errors, but it's never wrong
- A common mistake is to forget the type function in a declaration (e.g. `Invoice` vs `Invoice.t()`)
