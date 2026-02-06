///| Stmt nodes for TypeScript AST

///|
/// If Stmt
pub struct IfStmt {
  expression : Expr
  then_statement : Stmt
  else_statement : Stmt?
} derive(Eq, Show)

///|
pub fn IfStmt::new(
  expression : Expr,
  then_statement : Stmt,
  else_statement : Stmt?,
) -> IfStmt {
  { expression, then_statement, else_statement }
}

///|
/// Do Stmt
pub struct DoStmt {
  statement : Stmt
  expression : Expr
} derive(Eq, Show)

///|
pub fn DoStmt::new(statement : Stmt, expression : Expr) -> DoStmt {
  { statement, expression }
}

///|
/// While Stmt
pub struct WhileStmt {
  expression : Expr
  statement : Stmt
} derive(Eq, Show)

///|
pub fn WhileStmt::new(expression : Expr, statement : Stmt) -> WhileStmt {
  { expression, statement }
}

///|
/// For Stmt
pub struct ForStmt {
  initializer : ForInitializer?
  condition : Expr?
  incrementor : Expr?
  statement : Stmt
} derive(Eq, Show)

///|
pub fn ForStmt::new(
  initializer : ForInitializer?,
  condition : Expr?,
  incrementor : Expr?,
  statement : Stmt,
) -> ForStmt {
  { initializer, condition, incrementor, statement }
}

///|
pub enum ForInitializer {
  VariableDeclList(NodeArray[VariableDecl])
  UsingDeclList(NodeArray[UsingDecl], Bool)
  Expr(Expr)
} derive(Eq, Show)

///|
/// For-in Stmt
pub struct ForInStmt {
  initializer : ForInitializer
  expression : Expr
  statement : Stmt
} derive(Eq, Show)

///|
pub fn ForInStmt::new(
  initializer : ForInitializer,
  expression : Expr,
  statement : Stmt,
) -> ForInStmt {
  { initializer, expression, statement }
}

///|
/// For-of Stmt
pub struct ForOfStmt {
  initializer : ForInitializer
  expression : Expr
  statement : Stmt
  is_await : Bool
} derive(Eq, Show)

///|
pub fn ForOfStmt::new(
  initializer : ForInitializer,
  expression : Expr,
  statement : Stmt,
  is_await : Bool,
) -> ForOfStmt {
  { initializer, expression, statement, is_await }
}

///|
/// With Stmt
pub struct WithStmt {
  expression : Expr
  statement : Stmt
} derive(Eq, Show)

///|
pub fn WithStmt::new(expression : Expr, statement : Stmt) -> WithStmt {
  { expression, statement }
}

///|
/// Switch Stmt
pub struct SwitchStmt {
  expression : Expr
  case_block : CaseBlock
} derive(Eq, Show)

///|
pub fn SwitchStmt::new(expression : Expr, case_block : CaseBlock) -> SwitchStmt {
  { expression, case_block }
}

///|
pub struct CaseBlock {
  clauses : NodeArray[CaseOrDefaultClause]
} derive(Eq, Show)

///|
pub fn CaseBlock::new(clauses : NodeArray[CaseOrDefaultClause]) -> CaseBlock {
  { clauses, }
}

///|
pub enum CaseOrDefaultClause {
  CaseClause(CaseClause)
  DefaultClause(NodeArray[Stmt])
} derive(Eq, Show)

///|
pub struct CaseClause {
  expression : Expr
  stmts : NodeArray[Stmt]
} derive(Eq, Show)

///|
pub fn CaseClause::new(
  expression : Expr,
  stmts : NodeArray[Stmt],
) -> CaseClause {
  { expression, stmts }
}

///|
/// Labeled Stmt
pub struct LabeledStmt {
  label : Identifier
  statement : Stmt
} derive(Eq, Show)

///|
pub fn LabeledStmt::new(label : Identifier, statement : Stmt) -> LabeledStmt {
  { label, statement }
}

///|
/// Try Stmt
pub struct TryStmt {
  try_block : Array[Stmt]
  catch_clause : CatchClause?
  finally_block : Array[Stmt]?
} derive(Eq, Show)

///|
pub fn TryStmt::new(
  try_block : Array[Stmt],
  catch_clause : CatchClause?,
  finally_block : Array[Stmt]?,
) -> TryStmt {
  { try_block, catch_clause, finally_block }
}

///|
pub struct CatchClause {
  variable_declaration : VariableDecl?
  block : Array[Stmt]
} derive(Eq, Show)

///|
pub fn CatchClause::new(
  variable_declaration : VariableDecl?,
  block : Array[Stmt],
) -> CatchClause {
  { variable_declaration, block }
}
