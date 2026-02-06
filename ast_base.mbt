///|
/// Node array - a list of nodes with text range information
pub struct NodeArray[T] {
  elements : Array[T]
  start : Span
  end : Span
  has_trailing_comma : Bool
  is_missing_list : Bool
} derive(Eq, Show)

///|
pub fn[T] NodeArray::length(self : NodeArray[T]) -> Int {
  self.elements.length()
}

///|
pub fn[T] NodeArray::get(self : NodeArray[T], index : Int) -> T? {
  if index >= 0 && index < self.elements.length() {
    Some(self.elements[index])
  } else {
    None
  }
}

///|
pub fn[T] NodeArray::iter(self : NodeArray[T]) -> Iter[T] {
  self.elements.iter()
}

///|
/// Identifier node
pub struct Identifier {
  text : String
  has_extended_unicode_escape : Bool
  is_in_jsdoc_namespace : Bool
  span : Span
} derive(Eq, Show)

///|
pub fn Identifier::new(text : String, span : Span) -> Identifier {
  {
    text,
    has_extended_unicode_escape: false,
    is_in_jsdoc_namespace: false,
    span,
  }
}
