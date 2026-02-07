# sennenki/tsparser

Yet another TypeScript parser.

Currently ECMA versions and file formats other than `.ts` and `.d.ts` are not supported.

Usage:

```moonbit
// Construct a Parser instance

///|
let parser = Parser::new(source)
// Specify file name
// The second argument of parse_source_file will be used in the output SourceFile struct
// Usually it's expected to be the same as the argument of Parser::new

///|
let result = parser.parse_source_file("filename.ts", source) catch {
  ParseError(span~, kind~) as e =>
    match kind {
      // Pattern match on the caught error to inspect the exact reason of parsing failure
      UnexpectedToken(token_kind) => ...
      // ...
      // Or just print the error message as ParseError implements Show
      _ => abort(e)
    }
}
```
