///|
/// Core AST node types and structures

// Span represents a span in source text
pub struct Span {
  start : Int
  end : Int
  line : Int
  column : Int
  end_line : Int
  end_column : Int
} derive(Eq)

///|
pub fn Span::with_line_info(
  start : Int,
  end : Int,
  line : Int,
  column : Int,
  end_line : Int,
  end_column : Int,
) -> Span {
  { start, end, line, column, end_line, end_column }
}

///|
pub impl Show for Span with to_string(self) {
  "\{self.line}:\{self.column}-\{self.end_line}:\{self.end_column}(\{self.start}-\{self.end})"
}

///|
pub impl Show for Span with output(self, logger) {
  logger.write_string(self.to_string())
}
