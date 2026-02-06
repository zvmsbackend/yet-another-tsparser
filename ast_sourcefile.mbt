///| Top-level nodes for TypeScript AST

///|
/// Source file - the root of the AST
pub struct SourceFile {
  stmts : NodeArray[Stmt]
  file_name : String
  text : String
  script_kind : ScriptKind
  is_module : Bool
} derive(Show)

///|
fn SourceFile::new(
  stmts : NodeArray[Stmt],
  file_name : String,
  text : String,
  is_module : Bool,
  script_kind : ScriptKind,
) -> SourceFile {
  { stmts, file_name, text, script_kind, is_module }
}

///|
/// Script kind
pub(all) enum ScriptKind {
  Unknown
  JS
  JSX
  TS
  TSX
  TSDeclarations
  External
  JSON
  Deferred
} derive(Eq, Show)

///|
/// Script target (ECMAScript version)
pub(all) enum ScriptTarget {
  ES3
  ES5
  ES2015
  ES2016
  ES2017
  ES2018
  ES2019
  ES2020
  ES2021
  ES2022
  ES2023
  ESNext
  Latest
} derive(Eq, Show)
