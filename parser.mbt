///| Minimal parser inspired by Serenity TypeScript Parser

///|
fn compute_line_starts(text : String) -> Array[Int] {
  let starts : Array[Int] = [0]
  let mut i = 0
  let n = text.char_length()
  while i < n {
    match text.get_char(i) {
      Some('\n') => {
        i = i + 1
        starts.push(i)
        continue
      }
      Some('\r') => {
        if text.get_char(i + 1) is Some('\n') {
          i = i + 2
        } else {
          i = i + 1
        }
        starts.push(i)
        continue
      }
      _ => ()
    }
    i = i + 1
  }
  starts
}

///|
fn line_col_from_starts(starts : Array[Int], pos : Int) -> (Int, Int) {
  if starts.length() == 0 {
    return (1, pos + 1)
  }
  let mut low = 0
  let mut high = starts.length() - 1
  while low <= high {
    let mid = (low + high) / 2
    let start = starts[mid]
    if start <= pos {
      if mid + 1 < starts.length() && starts[mid + 1] <= pos {
        low = mid + 1
      } else {
        let line = mid + 1
        let column = pos - start + 1
        return (line, column)
      }
    } else {
      if mid == 0 {
        break
      }
      high = mid - 1
    }
  }
  (1, pos + 1)
}

///|
fn span_with_line_info(
  line_starts : Array[Int],
  start : Int,
  end : Int,
) -> Span {
  let (line, column) = line_col_from_starts(line_starts, start)
  let (end_line, end_column) = line_col_from_starts(line_starts, end)
  Span::with_line_info(start, end, line, column, end_line, end_column)
}

///|
fn parse_error_at_with(
  line_starts : Array[Int],
  start : Int,
  end : Int,
  kind : ParseErrorKind,
) -> ParseError {
  ParseError::ParseError(
    span=span_with_line_info(line_starts, start, end),
    kind~,
  )
}

///|
pub enum LexKind {
  Identifier(String)
  PrivateIdentifier(String)
  Number(String)
  String(String)
  Regex(String)
  NoSubTemplate(String, String)
  TemplateHead(String, String)
  TemplateMiddle(String, String)
  TemplateTail(String, String)
  KeywordLet
  KeywordConst
  KeywordVar
  KeywordUsing
  KeywordFunction
  KeywordReturn
  KeywordIf
  KeywordElse
  KeywordWhile
  KeywordFor
  KeywordDo
  KeywordBreak
  KeywordContinue
  KeywordSwitch
  KeywordCase
  KeywordDefault
  KeywordDebugger
  KeywordTry
  KeywordCatch
  KeywordFinally
  KeywordThrow
  KeywordWith
  KeywordNew
  KeywordClass
  KeywordInterface
  KeywordType
  KeywordEnum
  KeywordModule
  KeywordNamespace
  KeywordImport
  KeywordExport
  KeywordAssert
  KeywordGlobal
  KeywordFrom
  KeywordExtends
  KeywordImplements
  KeywordIn
  KeywordInstanceof
  KeywordOf
  KeywordAs
  KeywordSatisfies
  KeywordDelete
  KeywordTypeof
  KeywordVoid
  KeywordAwait
  KeywordYield
  KeywordThis
  KeywordSuper
  KeywordTrue
  KeywordFalse
  KeywordNull
  LParen
  RParen
  LBrace
  RBrace
  LBracket
  RBracket
  Comma
  Dot
  DotDotDot
  Semicolon
  Colon
  Question
  QuestionDot
  Plus
  PlusPlus
  PlusEq
  Minus
  MinusMinus
  MinusEq
  Star
  StarStar
  StarEq
  StarStarEq
  Slash
  SlashEq
  Percent
  PercentEq
  Bang
  Tilde
  Eq
  EqEq
  Arrow
  EqEqEq
  BangEq
  BangEqEq
  Lt
  LtLt
  LtLtEq
  LtSlash
  Gt
  GtGt
  GtGtGt
  GtGtEq
  GtGtGtEq
  LtEq
  GtEq
  Ampersand
  AmpAmp
  AmpersandEq
  AmpAmpEq
  Bar
  BarBar
  BarEq
  BarBarEq
  Caret
  CaretEq
  QuestionQuestion
  QuestionQuestionEq
  At
  Eof
} derive(Eq)

///|
impl Show for LexKind with to_string(self) {
  match self {
    Identifier(name) => "identifier \{name}"
    PrivateIdentifier(name) => "private identifier \{name}"
    Number(text) => "number literal \{text}"
    String(text) => "string literal \"\{text}\""
    Regex(text) => "regex /\{text}/"
    NoSubTemplate(text, _) => "template `\{text}`"
    TemplateHead(text, _) => "template head `\{text}`"
    TemplateMiddle(text, _) => "template middle `\{text}`"
    TemplateTail(text, _) => "template tail `\{text}`"
    KeywordLet => "let"
    KeywordConst => "const"
    KeywordVar => "var"
    KeywordUsing => "using"
    KeywordFunction => "function"
    KeywordReturn => "return"
    KeywordIf => "if"
    KeywordElse => "else"
    KeywordWhile => "while"
    KeywordFor => "for"
    KeywordDo => "do"
    KeywordBreak => "break"
    KeywordContinue => "continue"
    KeywordSwitch => "switch"
    KeywordCase => "case"
    KeywordDefault => "default"
    KeywordDebugger => "debugger"
    KeywordTry => "try"
    KeywordCatch => "catch"
    KeywordFinally => "finally"
    KeywordThrow => "throw"
    KeywordWith => "with"
    KeywordNew => "new"
    KeywordClass => "class"
    KeywordInterface => "interface"
    KeywordType => "type"
    KeywordEnum => "enum"
    KeywordModule => "module"
    KeywordNamespace => "namespace"
    KeywordImport => "import"
    KeywordExport => "export"
    KeywordAssert => "assert"
    KeywordGlobal => "global"
    KeywordFrom => "from"
    KeywordExtends => "extends"
    KeywordImplements => "implements"
    KeywordIn => "in"
    KeywordInstanceof => "instanceof"
    KeywordOf => "of"
    KeywordAs => "as"
    KeywordSatisfies => "satisfies"
    KeywordDelete => "delete"
    KeywordTypeof => "typeof"
    KeywordVoid => "void"
    KeywordAwait => "await"
    KeywordYield => "yield"
    KeywordThis => "this"
    KeywordSuper => "super"
    KeywordTrue => "true"
    KeywordFalse => "false"
    KeywordNull => "null"
    LParen => "'('"
    RParen => "')'"
    LBrace => "'{'"
    RBrace => "'}'"
    LBracket => "'['"
    RBracket => "']'"
    Comma => "','"
    Dot => "'.'"
    DotDotDot => "'...'"
    Semicolon => "';'"
    Colon => "':'"
    Question => "?'"
    QuestionDot => "'?.'"
    Plus => "'+'"
    PlusPlus => "'++'"
    PlusEq => "'+='"
    Minus => "'-'"
    MinusMinus => "'--'"
    MinusEq => "'-='"
    Star => "'*'"
    StarStar => "'**'"
    StarEq => "'*='"
    StarStarEq => "'**='"
    Slash => "'/'"
    SlashEq => "'/='"
    Percent => "'%'"
    PercentEq => "'%='"
    Bang => "'!'"
    Tilde => "'~'"
    Eq => "'='"
    EqEq => "'=='"
    Arrow => "'=>'"
    EqEqEq => "'==='"
    BangEq => "'!='"
    BangEqEq => "'!=='"
    Lt => "'<'"
    LtLt => "'<<'"
    LtLtEq => "'<<='"
    LtSlash => "'</'"
    Gt => "'>'"
    GtGt => "'>>'"
    GtGtGt => "'>>>'"
    GtGtEq => "'>>='"
    GtGtGtEq => "'>>>='"
    LtEq => "'<='"
    GtEq => "'>='"
    Ampersand => "'&'"
    AmpAmp => "'&&'"
    AmpersandEq => "'&='"
    AmpAmpEq => "'&&='"
    Bar => "'|'"
    BarBar => "'||'"
    BarEq => "'|='"
    BarBarEq => "'||='"
    Caret => "'^'"
    CaretEq => "'^='"
    QuestionQuestion => "'??'"
    QuestionQuestionEq => "'??='"
    At => "'@'"
    Eof => "end of file"
  }
}

///|
impl Show for LexKind with output(self, logger) {
  logger.write_string(self.to_string())
}

///|
pub struct LexToken {
  kind : LexKind
  start : Int
  end : Int
  has_leading_line_break : Bool
} derive(Show)

///|
fn LexToken::new(
  kind : LexKind,
  start : Int,
  end : Int,
  has_leading_line_break : Bool,
) -> LexToken {
  { kind, start, end, has_leading_line_break }
}

///|
fn is_digit(c : Char) -> Bool {
  c >= '0' && c <= '9'
}

///|
fn is_alpha(c : Char) -> Bool {
  (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || c == '_' || c == '$'
}

///|
fn is_ident_start(c : Char) -> Bool {
  is_alpha(c)
}

///|
fn is_ident_part(c : Char) -> Bool {
  is_alpha(c) || is_digit(c)
}

///|
fn is_hex_digit(c : Char) -> Bool {
  (c >= '0' && c <= '9') || (c >= 'a' && c <= 'f') || (c >= 'A' && c <= 'F')
}

///|
fn is_bin_digit(c : Char) -> Bool {
  c == '0' || c == '1'
}

///|
fn is_oct_digit(c : Char) -> Bool {
  c >= '0' && c <= '7'
}

///|
fn is_dec_digit_or_sep(c : Char) -> Bool {
  is_digit(c) || c == '_'
}

///|
fn is_hex_digit_or_sep(c : Char) -> Bool {
  is_hex_digit(c) || c == '_'
}

///|
fn is_bin_digit_or_sep(c : Char) -> Bool {
  is_bin_digit(c) || c == '_'
}

///|
fn is_oct_digit_or_sep(c : Char) -> Bool {
  is_oct_digit(c) || c == '_'
}

///|
fn read_digits(text : String, start : Int, pred : (Char) -> Bool) -> Int {
  let mut i = start
  while text.get_char(i) is Some(c) && pred(c) {
    i = i + 1
  }
  i
}

///|
fn read_exponent(text : String, start : Int) -> Int {
  let mut i = start
  if text.get_char(i) is Some(c) && (c == 'e' || c == 'E') {
    let mut j = i + 1
    if text.get_char(j) is Some(sign) && (sign == '+' || sign == '-') {
      j = j + 1
    }
    let after = read_digits(text, j, is_dec_digit_or_sep)
    if after > j {
      i = after
    }
  }
  i
}

///|
fn can_end_expr(kind : LexKind) -> Bool {
  match kind {
    Identifier(_) => true
    KeywordType => true
    KeywordAs => true
    KeywordFrom => true
    KeywordOf => true
    KeywordUsing => true
    Number(_) => true
    String(_) => true
    Regex(_) => true
    NoSubTemplate(_, _) => true
    KeywordThis => true
    KeywordSuper => true
    KeywordTrue => true
    KeywordFalse => true
    KeywordNull => true
    RParen => true
    RBracket => true
    RBrace => true
    PlusPlus => true
    MinusMinus => true
    _ => false
  }
}

///|
fn modifier_kind_from_name(name : String) -> ModifierKind? {
  match name {
    "abstract" => Some(ModifierKind::Abstract)
    "accessor" => Some(ModifierKind::Accessor)
    "async" => Some(ModifierKind::Async)
    "const" => Some(ModifierKind::Const)
    "declare" => Some(ModifierKind::Declare)
    "default" => Some(ModifierKind::Default)
    "export" => Some(ModifierKind::Export)
    "in" => Some(ModifierKind::In)
    "public" => Some(ModifierKind::Public)
    "private" => Some(ModifierKind::Private)
    "protected" => Some(ModifierKind::Protected)
    "readonly" => Some(ModifierKind::Readonly)
    "override" => Some(ModifierKind::Override)
    "out" => Some(ModifierKind::Out)
    "static" => Some(ModifierKind::Static)
    _ => None
  }
}

///|
fn is_param_modifier(kind : ModifierKind) -> Bool {
  match kind {
    ModifierKind::Public => true
    ModifierKind::Private => true
    ModifierKind::Protected => true
    ModifierKind::Readonly => true
    ModifierKind::Override => true
    _ => false
  }
}

///|
fn Parser::parse_decorators(
  self : Parser,
  fallback_start : Int,
) -> NodeArray[Expr]? raise ParseError {
  let items : Array[Expr] = []
  let mut start_start : Int? = None
  let mut end_start : Int? = None
  while self.at(LexKind::At) {
    let at_tok = self.advance()
    let expr = self.parse_starttfix_expr()
    if start_start is None {
      start_start = Some(at_tok.start)
    }
    end_start = Some(expr.span.end)
    items.push(expr)
  }
  if items.length() == 0 {
    None
  } else {
    Some(
      self.node_array(
        items,
        start_start.unwrap_or(fallback_start),
        end_start.unwrap_or(fallback_start),
      ),
    )
  }
}

///|
fn Parser::parse_modifiers(
  self : Parser,
  fallback_start : Int,
) -> NodeArray[ModifierKind]? {
  let items : Array[ModifierKind] = []
  let mut start_start : Int? = None
  let mut end_start : Int? = None
  for {
    match self.current().kind {
      KeywordExport => {
        self.has_export_syntax = true
        let tok = self.advance()
        if start_start is None {
          start_start = Some(tok.start)
        }
        end_start = Some(tok.end)
        items.push(ModifierKind::Export)
        continue
      }
      KeywordDefault => {
        let tok = self.advance()
        if start_start is None {
          start_start = Some(tok.start)
        }
        end_start = Some(tok.end)
        items.push(ModifierKind::Default)
        continue
      }
      Identifier(text) =>
        match modifier_kind_from_name(text) {
          Some(kind) => {
            let tok = self.advance()
            if start_start is None {
              start_start = Some(tok.start)
            }
            end_start = Some(tok.end)
            items.push(kind)
            continue
          }
          None => break
        }
      _ => break
    }
  }
  if items.length() == 0 {
    None
  } else {
    Some(
      self.node_array(
        items,
        start_start.unwrap_or(fallback_start),
        end_start.unwrap_or(fallback_start),
      ),
    )
  }
}

///|
fn Parser::parse_parameter_modifiers(
  self : Parser,
  fallback_start : Int,
) -> NodeArray[ModifierKind]? {
  let items : Array[ModifierKind] = []
  let mut start_start : Int? = None
  let mut end_start : Int? = None
  for {
    match self.current().kind {
      Identifier(text) =>
        match modifier_kind_from_name(text) {
          Some(kind) if is_param_modifier(kind) => {
            let tok = self.advance()
            if start_start is None {
              start_start = Some(tok.start)
            }
            end_start = Some(tok.end)
            items.push(kind)
            continue
          }
          _ => break
        }
      _ => break
    }
  }
  if items.length() == 0 {
    None
  } else {
    Some(
      self.node_array(
        items,
        start_start.unwrap_or(fallback_start),
        end_start.unwrap_or(fallback_start),
      ),
    )
  }
}

///|

///|
fn lex(
  text : String,
  line_starts : Array[Int],
) -> Array[LexToken] raise ParseError {
  fn slice(text : String, start : Int, end : Int) -> String raise ParseError {
    if start <= end && end <= text.char_length() {
      text[start:end].to_string() catch {
        _ =>
          raise parse_error_at_with(
            line_starts,
            start,
            end,
            ParseErrorKind::InvalidSlice(end~),
          )
      }
    } else {
      raise parse_error_at_with(
        line_starts,
        start,
        end,
        ParseErrorKind::InvalidSlice(end~),
      )
    }
  }

  let tokens : Array[LexToken] = []
  let mut i = 0
  let n = text.char_length()
  let mut prev_can_end = false
  let mut template_expr_depth = 0
  let template_stack : Array[Int] = []
  let mut has_line_break = false
  while i < n {
    let c = match text.get_char(i) {
      Some(ch) => ch
      None =>
        raise parse_error_at_with(
          line_starts,
          i,
          i,
          ParseErrorKind::InvalidChar('\u0000'),
        )
    }
    if c == ' ' || c == '\t' || c == '\n' || c == '\r' {
      if c == '\n' || c == '\r' {
        has_line_break = true
      }
      i = i + 1
      continue
    }
    if c == '#' && text.get_char(i + 1) is Some(next) && is_ident_start(next) {
      let start = i
      i = i + 1
      let name_start = i
      i = i + 1
      while text.get_char(i) is Some(c) && is_ident_part(c) {
        i = i + 1
      }
      let value = slice(text, name_start, i)
      let kind = LexKind::PrivateIdentifier(value.to_string())
      tokens.push(LexToken::new(kind, start, i, has_line_break))
      has_line_break = false
      prev_can_end = false
      continue
    }
    if template_expr_depth > 0 && c == '}' {
      template_expr_depth = template_expr_depth - 1
      if template_expr_depth > 0 {
        let start = i
        i = i + 1
        let kind = LexKind::RBrace
        tokens.push(LexToken::new(kind, start, i, has_line_break))
        has_line_break = false
        prev_can_end = can_end_expr(kind)
        continue
      }
      i = i + 1
      let chunk_start = i
      let mut terminated = false
      while i < n {
        if text[i] == '\\' && i + 1 < n {
          i = i + 2
          continue
        }
        if text[i] == '`' {
          let raw = slice(text, chunk_start, i)
          i = i + 1
          let kind = LexKind::TemplateTail(raw.to_string(), raw.to_string())
          tokens.push(LexToken::new(kind, chunk_start, i, has_line_break))
          has_line_break = false
          prev_can_end = true
          template_expr_depth = match template_stack.pop() {
            Some(d) => d
            None => 0
          }
          terminated = true
          break
        }
        if text[i] == '$' && i + 1 < n && text[i + 1] == '{' {
          let raw = slice(text, chunk_start, i)
          i = i + 2
          let kind = LexKind::TemplateMiddle(raw.to_string(), raw.to_string())
          tokens.push(LexToken::new(kind, chunk_start, i, has_line_break))
          has_line_break = false
          prev_can_end = false
          template_expr_depth = 1
          terminated = true
          break
        }
        i = i + 1
      }
      if !terminated {
        raise parse_error_at_with(
          line_starts,
          chunk_start,
          i,
          ParseErrorKind::UnterminatedString,
        )
      }
      continue
    }
    if c == '`' {
      let start = i
      i = i + 1
      let chunk_start = i
      let mut terminated = false
      while i < n {
        if text[i] == '\\' && i + 1 < n {
          i = i + 2
          continue
        }
        if text[i] == '`' {
          let raw = slice(text, chunk_start, i)
          i = i + 1
          let kind = LexKind::NoSubTemplate(raw.to_string(), raw.to_string())
          tokens.push(LexToken::new(kind, start, i, has_line_break))
          has_line_break = false
          prev_can_end = true
          terminated = true
          break
        }
        if text[i] == '$' && i + 1 < n && text[i + 1] == '{' {
          let raw = slice(text, chunk_start, i)
          i = i + 2
          let kind = LexKind::TemplateHead(raw.to_string(), raw.to_string())
          tokens.push(LexToken::new(kind, start, i, has_line_break))
          has_line_break = false
          prev_can_end = false
          template_stack.push(template_expr_depth)
          template_expr_depth = 1
          terminated = true
          break
        }
        i = i + 1
      }
      if !terminated {
        raise parse_error_at_with(
          line_starts,
          start,
          i,
          ParseErrorKind::UnterminatedString,
        )
      }
      continue
    }
    if c == '/' && text.get_char(i + 1) is Some(next) {
      if next == '/' {
        i = i + 2
        while i < n && text[i] != '\n' {
          i = i + 1
        }
        continue
      }
      if next == '*' {
        i = i + 2
        while i + 1 < n {
          if text[i] == '\n' || text[i] == '\r' {
            has_line_break = true
          }
          if text[i] == '*' && text[i + 1] == '/' {
            i = i + 2
            break
          }
          i = i + 1
        }
        continue
      }
      if !prev_can_end {
        let start = i
        i = i + 1
        while i < n {
          if text[i] == '\\' && i + 1 < n {
            i = i + 2
            continue
          }
          if text[i] == '/' {
            i = i + 1
            break
          }
          i = i + 1
        }
        while i < n {
          match text.get_char(i) {
            Some(ch) if (ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z') =>
              i = i + 1
            _ => break
          }
        }
        let value = slice(text, start, i)
        let kind = LexKind::Regex(value.to_string())
        tokens.push(LexToken::new(kind, start, i, has_line_break))
        has_line_break = false
        prev_can_end = true
        continue
      }
    }
    if is_ident_start(c) {
      let start = i
      i = i + 1
      while text.get_char(i) is Some(c) && is_ident_part(c) {
        i = i + 1
      }
      let value = slice(text, start, i)
      let kind = match value {
        "let" => LexKind::KeywordLet
        "const" => LexKind::KeywordConst
        "var" => LexKind::KeywordVar
        "using" => LexKind::KeywordUsing
        "function" => LexKind::KeywordFunction
        "return" => LexKind::KeywordReturn
        "if" => LexKind::KeywordIf
        "else" => LexKind::KeywordElse
        "while" => LexKind::KeywordWhile
        "for" => LexKind::KeywordFor
        "do" => LexKind::KeywordDo
        "break" => LexKind::KeywordBreak
        "continue" => LexKind::KeywordContinue
        "switch" => LexKind::KeywordSwitch
        "case" => LexKind::KeywordCase
        "default" => LexKind::KeywordDefault
        "debugger" => LexKind::KeywordDebugger
        "try" => LexKind::KeywordTry
        "catch" => LexKind::KeywordCatch
        "finally" => LexKind::KeywordFinally
        "throw" => LexKind::KeywordThrow
        "with" => LexKind::KeywordWith
        "new" => LexKind::KeywordNew
        "class" => LexKind::KeywordClass
        "interface" => LexKind::KeywordInterface
        "type" => LexKind::KeywordType
        "enum" => LexKind::KeywordEnum
        "module" => LexKind::KeywordModule
        "namespace" => LexKind::KeywordNamespace
        "import" => LexKind::KeywordImport
        "export" => LexKind::KeywordExport
        "assert" => LexKind::KeywordAssert
        "global" => LexKind::KeywordGlobal
        "from" => LexKind::KeywordFrom
        "extends" => LexKind::KeywordExtends
        "implements" => LexKind::KeywordImplements
        "in" => LexKind::KeywordIn
        "instanceof" => LexKind::KeywordInstanceof
        "of" => LexKind::KeywordOf
        "as" => LexKind::KeywordAs
        "satisfies" => LexKind::KeywordSatisfies
        "delete" => LexKind::KeywordDelete
        "typeof" => LexKind::KeywordTypeof
        "void" => LexKind::KeywordVoid
        "await" => LexKind::KeywordAwait
        "yield" => LexKind::KeywordYield
        "this" => LexKind::KeywordThis
        "super" => LexKind::KeywordSuper
        "true" => LexKind::KeywordTrue
        "false" => LexKind::KeywordFalse
        "null" => LexKind::KeywordNull
        _ => LexKind::Identifier(value.to_string())
      }
      tokens.push(LexToken::new(kind, start, i, has_line_break))
      has_line_break = false
      prev_can_end = can_end_expr(kind)
      continue
    }
    if is_digit(c) {
      let start = i
      if c == '0' && text.get_char(i + 1) is Some(next) {
        match next {
          'x' | 'X' => {
            i = i + 2
            let after = read_digits(text, i, is_hex_digit_or_sep)
            if after == i {
              raise parse_error_at_with(
                line_starts,
                i,
                i + 1,
                ParseErrorKind::InvalidChar(next),
              )
            }
            i = after
            if text.get_char(i) is Some('n') {
              i = i + 1
            }
            let value = slice(text, start, i)
            tokens.push(
              LexToken::new(
                LexKind::Number(value.to_string()),
                start,
                i,
                has_line_break,
              ),
            )
            has_line_break = false
            continue
          }
          'b' | 'B' => {
            i = i + 2
            let after = read_digits(text, i, is_bin_digit_or_sep)
            if after == i {
              raise parse_error_at_with(
                line_starts,
                i,
                i + 1,
                ParseErrorKind::InvalidChar(next),
              )
            }
            i = after
            if text.get_char(i) is Some('n') {
              i = i + 1
            }
            let value = slice(text, start, i)
            tokens.push(
              LexToken::new(
                LexKind::Number(value.to_string()),
                start,
                i,
                has_line_break,
              ),
            )
            has_line_break = false
            continue
          }
          'o' | 'O' => {
            i = i + 2
            let after = read_digits(text, i, is_oct_digit_or_sep)
            if after == i {
              raise parse_error_at_with(
                line_starts,
                i,
                i + 1,
                ParseErrorKind::InvalidChar(next),
              )
            }
            i = after
            if text.get_char(i) is Some('n') {
              i = i + 1
            }
            let value = slice(text, start, i)
            tokens.push(
              LexToken::new(
                LexKind::Number(value.to_string()),
                start,
                i,
                has_line_break,
              ),
            )
            has_line_break = false
            continue
          }
          _ => ()
        }
      }
      i = read_digits(text, i + 1, is_dec_digit_or_sep)
      if text.get_char(i) is Some('.') && !(text.get_char(i + 1) is Some('.')) {
        i = read_digits(text, i + 1, is_dec_digit_or_sep)
      }
      i = read_exponent(text, i)
      if text.get_char(i) is Some('n') {
        i = i + 1
      }
      if text.get_char(i) is Some(next) && is_ident_start(next) {
        raise parse_error_at_with(
          line_starts,
          i,
          i + 1,
          ParseErrorKind::IdentifierAfterNumericLiteral,
        )
      }
      let value = slice(text, start, i)
      tokens.push(
        LexToken::new(
          LexKind::Number(value.to_string()),
          start,
          i,
          has_line_break,
        ),
      )
      has_line_break = false
      prev_can_end = true
      continue
    }
    if c == '\'' || c == '"' {
      let quote = c
      let start = i
      i = i + 1
      let value_start = i
      while text.get_char(i) is Some(c) && c != quote {
        if c == '\\' && i + 1 < n {
          i = i + 2
          continue
        }
        i = i + 1
      }
      let value = slice(text, value_start, i)
      if text.get_char(i) is Some(c) && c == quote {
        i = i + 1
      } else {
        raise parse_error_at_with(
          line_starts,
          start,
          i,
          ParseErrorKind::UnterminatedString,
        )
      }
      tokens.push(
        LexToken::new(
          LexKind::String(value.to_string()),
          start,
          i,
          has_line_break,
        ),
      )
      has_line_break = false
      prev_can_end = true
      continue
    }
    let start = i
    let kind = match c {
      '(' => LexKind::LParen
      ')' => LexKind::RParen
      '{' => LexKind::LBrace
      '}' => LexKind::RBrace
      '[' => LexKind::LBracket
      ']' => LexKind::RBracket
      ',' => LexKind::Comma
      '.' => {
        if i + 2 < n && text[i + 1] == '.' && text[i + 2] == '.' {
          i = i + 3
          tokens.push(
            LexToken::new(LexKind::DotDotDot, start, i, has_line_break),
          )
          has_line_break = false
          continue
        }
        if text.get_char(i + 1) is Some(next) && is_digit(next) {
          let number_start = i
          i = read_digits(text, i + 1, is_dec_digit_or_sep)
          i = read_exponent(text, i)
          if text.get_char(i) is Some('n') {
            i = i + 1
          }
          if text.get_char(i) is Some(next) && is_ident_start(next) {
            raise parse_error_at_with(
              line_starts,
              i,
              i + 1,
              ParseErrorKind::IdentifierAfterNumericLiteral,
            )
          }
          let value = slice(text, number_start, i)
          tokens.push(
            LexToken::new(
              LexKind::Number(value.to_string()),
              number_start,
              i,
              has_line_break,
            ),
          )
          has_line_break = false
          continue
        }
        LexKind::Dot
      }
      ';' => LexKind::Semicolon
      ':' => LexKind::Colon
      '?' => {
        if i + 1 < n && text[i + 1] == '.' {
          i = i + 2
          tokens.push(
            LexToken::new(LexKind::QuestionDot, start, i, has_line_break),
          )
          has_line_break = false
          continue
        }
        if i + 2 < n && text[i + 1] == '?' && text[i + 2] == '=' {
          i = i + 3
          tokens.push(
            LexToken::new(LexKind::QuestionQuestionEq, start, i, has_line_break),
          )
          has_line_break = false
          continue
        }
        if i + 1 < n && text[i + 1] == '?' {
          i = i + 2
          tokens.push(
            LexToken::new(LexKind::QuestionQuestion, start, i, has_line_break),
          )
          has_line_break = false
          continue
        }
        LexKind::Question
      }
      '+' => {
        if i + 1 < n && text[i + 1] == '+' {
          i = i + 2
          tokens.push(
            LexToken::new(LexKind::PlusPlus, start, i, has_line_break),
          )
          has_line_break = false
          continue
        }
        if i + 1 < n && text[i + 1] == '=' {
          i = i + 2
          tokens.push(LexToken::new(LexKind::PlusEq, start, i, has_line_break))
          has_line_break = false
          continue
        }
        LexKind::Plus
      }
      '-' => {
        if i + 1 < n && text[i + 1] == '-' {
          i = i + 2
          tokens.push(
            LexToken::new(LexKind::MinusMinus, start, i, has_line_break),
          )
          has_line_break = false
          continue
        }
        if i + 1 < n && text[i + 1] == '=' {
          i = i + 2
          tokens.push(LexToken::new(LexKind::MinusEq, start, i, has_line_break))
          has_line_break = false
          continue
        }
        LexKind::Minus
      }
      '*' => {
        if i + 2 < n && text[i + 1] == '*' && text[i + 2] == '=' {
          i = i + 3
          tokens.push(
            LexToken::new(LexKind::StarStarEq, start, i, has_line_break),
          )
          has_line_break = false
          continue
        }
        if i + 1 < n && text[i + 1] == '*' {
          i = i + 2
          tokens.push(
            LexToken::new(LexKind::StarStar, start, i, has_line_break),
          )
          has_line_break = false
          continue
        }
        if i + 1 < n && text[i + 1] == '=' {
          i = i + 2
          tokens.push(LexToken::new(LexKind::StarEq, start, i, has_line_break))
          has_line_break = false
          continue
        }
        LexKind::Star
      }
      '/' => {
        if i + 1 < n && text[i + 1] == '=' {
          i = i + 2
          tokens.push(LexToken::new(LexKind::SlashEq, start, i, has_line_break))
          has_line_break = false
          continue
        }
        LexKind::Slash
      }
      '%' => {
        if i + 1 < n && text[i + 1] == '=' {
          i = i + 2
          tokens.push(
            LexToken::new(LexKind::PercentEq, start, i, has_line_break),
          )
          has_line_break = false
          continue
        }
        LexKind::Percent
      }
      '!' => {
        if i + 2 < n && text[i + 1] == '=' && text[i + 2] == '=' {
          i = i + 3
          tokens.push(
            LexToken::new(LexKind::BangEqEq, start, i, has_line_break),
          )
          has_line_break = false
          continue
        }
        if i + 1 < n && text[i + 1] == '=' {
          i = i + 2
          tokens.push(LexToken::new(LexKind::BangEq, start, i, has_line_break))
          has_line_break = false
          continue
        }
        LexKind::Bang
      }
      '~' => LexKind::Tilde
      '=' => {
        if i + 1 < n && text[i + 1] == '>' {
          i = i + 2
          tokens.push(LexToken::new(LexKind::Arrow, start, i, has_line_break))
          has_line_break = false
          continue
        }
        if i + 2 < n && text[i + 1] == '=' && text[i + 2] == '=' {
          i = i + 3
          tokens.push(LexToken::new(LexKind::EqEqEq, start, i, has_line_break))
          has_line_break = false
          continue
        }
        if i + 1 < n && text[i + 1] == '=' {
          i = i + 2
          tokens.push(LexToken::new(LexKind::EqEq, start, i, has_line_break))
          has_line_break = false
          continue
        }
        LexKind::Eq
      }
      '<' => {
        if i + 1 < n && text[i + 1] == '<' {
          if i + 2 < n && text[i + 2] == '=' {
            i = i + 3
            tokens.push(
              LexToken::new(LexKind::LtLtEq, start, i, has_line_break),
            )
            has_line_break = false
            continue
          }
          i = i + 2
          tokens.push(LexToken::new(LexKind::LtLt, start, i, has_line_break))
          has_line_break = false
          continue
        }
        if i + 1 < n && text[i + 1] == '/' {
          i = i + 2
          tokens.push(LexToken::new(LexKind::LtSlash, start, i, has_line_break))
          has_line_break = false
          continue
        }
        if i + 1 < n && text[i + 1] == '=' {
          i = i + 2
          tokens.push(LexToken::new(LexKind::LtEq, start, i, has_line_break))
          has_line_break = false
          continue
        }
        LexKind::Lt
      }
      '>' => {
        if i + 2 < n && text[i + 1] == '>' && text[i + 2] == '>' {
          if i + 3 < n && text[i + 3] == '=' {
            i = i + 4
            tokens.push(
              LexToken::new(LexKind::GtGtGtEq, start, i, has_line_break),
            )
            has_line_break = false
            continue
          }
          i = i + 3
          tokens.push(LexToken::new(LexKind::GtGtGt, start, i, has_line_break))
          has_line_break = false
          continue
        }
        if i + 1 < n && text[i + 1] == '>' {
          if i + 2 < n && text[i + 2] == '=' {
            i = i + 3
            tokens.push(
              LexToken::new(LexKind::GtGtEq, start, i, has_line_break),
            )
            has_line_break = false
            continue
          }
          i = i + 2
          tokens.push(LexToken::new(LexKind::GtGt, start, i, has_line_break))
          has_line_break = false
          continue
        }
        if i + 1 < n && text[i + 1] == '=' {
          i = i + 2
          tokens.push(LexToken::new(LexKind::GtEq, start, i, has_line_break))
          has_line_break = false
          continue
        }
        LexKind::Gt
      }
      '&' => {
        if i + 2 < n && text[i + 1] == '&' && text[i + 2] == '=' {
          i = i + 3
          tokens.push(
            LexToken::new(LexKind::AmpAmpEq, start, i, has_line_break),
          )
          has_line_break = false
          continue
        }
        if i + 1 < n && text[i + 1] == '&' {
          i = i + 2
          tokens.push(LexToken::new(LexKind::AmpAmp, start, i, has_line_break))
          has_line_break = false
          continue
        }
        if i + 1 < n && text[i + 1] == '=' {
          i = i + 2
          tokens.push(
            LexToken::new(LexKind::AmpersandEq, start, i, has_line_break),
          )
          has_line_break = false
          continue
        }
        LexKind::Ampersand
      }
      '|' => {
        if i + 2 < n && text[i + 1] == '|' && text[i + 2] == '=' {
          i = i + 3
          tokens.push(
            LexToken::new(LexKind::BarBarEq, start, i, has_line_break),
          )
          has_line_break = false
          continue
        }
        if i + 1 < n && text[i + 1] == '|' {
          i = i + 2
          tokens.push(LexToken::new(LexKind::BarBar, start, i, has_line_break))
          has_line_break = false
          continue
        }
        if i + 1 < n && text[i + 1] == '=' {
          i = i + 2
          tokens.push(LexToken::new(LexKind::BarEq, start, i, has_line_break))
          has_line_break = false
          continue
        }
        LexKind::Bar
      }
      '^' => {
        if i + 1 < n && text[i + 1] == '=' {
          i = i + 2
          tokens.push(LexToken::new(LexKind::CaretEq, start, i, has_line_break))
          has_line_break = false
          continue
        }
        LexKind::Caret
      }
      '@' => LexKind::At
      _ =>
        raise parse_error_at_with(
          line_starts,
          start,
          start + 1,
          ParseErrorKind::InvalidChar(c),
        )
    }
    i = i + 1
    tokens.push(LexToken::new(kind, start, i, has_line_break))
    has_line_break = false
    if template_expr_depth > 0 && kind == LexKind::LBrace {
      template_expr_depth = template_expr_depth + 1
    }
    prev_can_end = can_end_expr(kind)
  }
  tokens.push(LexToken::new(LexKind::Eof, n, n, has_line_break))
  tokens
}

///|
pub struct Parser {
  tokens : Array[LexToken]
  mut index : Int
  line_starts : Array[Int]
  is_module : Bool
  script_kind : ScriptKind
  mut in_generator : Int
  mut in_function : Int
  mut in_async_function : Int
  mut in_conditional_extends : Int
  mut has_import_syntax : Bool
  mut has_export_syntax : Bool
  mut has_non_namespace_export : Bool
  mut has_export_assignment : Bool
  mut export_namespace_range : (Int, Int)?
  mut top_level_await_range : (Int, Int)?
  mut for_await_range : (Int, Int)?
  mut await_using_range : (Int, Int)?
} derive(Show)

///|
pub fn Parser::new(
  text : String,
  script_kind? : ScriptKind = TS,
  is_module? : Bool = false,
) -> Parser raise ParseError {
  let line_starts = compute_line_starts(text)
  {
    tokens: lex(text, line_starts),
    index: 0,
    line_starts,
    in_generator: 0,
    in_function: 0,
    in_async_function: 0,
    in_conditional_extends: 0,
    has_import_syntax: false,
    has_export_syntax: false,
    has_non_namespace_export: false,
    has_export_assignment: false,
    export_namespace_range: None,
    top_level_await_range: None,
    for_await_range: None,
    await_using_range: None,
    script_kind,
    is_module,
  }
}

///|
fn Parser::parse_error_at(
  self : Parser,
  start : Int,
  end : Int,
  kind : ParseErrorKind,
) -> ParseError {
  parse_error_at_with(self.line_starts, start, end, kind)
}

///|
fn Parser::mark_non_namespace_export(
  self : Parser,
  start : Int,
  end : Int,
) -> Unit raise ParseError {
  if self.has_export_assignment {
    raise self.parse_error_at(
      start,
      end,
      ParseErrorKind::ExportAssignmentCannotBeUsedWithOtherExports,
    )
  }
  self.has_non_namespace_export = true
}

///|
fn Parser::record_top_level_await(self : Parser, span : Span) -> Unit {
  if self.in_function == 0 {
    if self.top_level_await_range is None {
      self.top_level_await_range = Some((span.start, span.end))
    }
  }
}

///|
fn Parser::record_top_level_await_using(self : Parser, span : Span) -> Unit {
  if self.in_function == 0 {
    if self.await_using_range is None {
      self.await_using_range = Some((span.start, span.end))
    }
  }
}

///|
fn Parser::current(self : Parser) -> LexToken {
  self.tokens[self.index]
}

///|
fn Parser::at(self : Parser, kind : LexKind) -> Bool {
  self.current().kind == kind
}

///|
fn Parser::advance(self : Parser) -> LexToken {
  let tok = self.current()
  self.index = self.index + 1
  tok
}

///|
fn Parser::peek(self : Parser, offset : Int) -> LexToken {
  let idx = self.index + offset
  if idx < self.tokens.length() {
    self.tokens[idx]
  } else {
    self.tokens[self.tokens.length() - 1]
  }
}

///|
fn Parser::has_preceding_line_break(self : Parser) -> Bool {
  self.current().has_leading_line_break
}

///|
fn Parser::can_parse_semicolon(self : Parser) -> Bool {
  match self.current().kind {
    Semicolon => true
    RBrace => true
    Eof => true
    _ => self.has_preceding_line_break()
  }
}

///|
fn Parser::try_parse_semicolon(self : Parser) -> Bool {
  if !self.can_parse_semicolon() {
    return false
  }
  if self.at(LexKind::Semicolon) {
    self.advance() |> ignore
  }
  true
}

///|
fn Parser::parse_semicolon(self : Parser) -> Unit raise ParseError {
  if self.try_parse_semicolon() {
    return ()
  }
  let tok = self.current()
  raise self.parse_error_at(
    tok.start,
    tok.end,
    ParseErrorKind::ExpectedToken(expected=LexKind::Semicolon, actual=tok.kind),
  )
}

///|
fn Parser::expect(self : Parser, kind : LexKind) -> LexToken raise ParseError {
  let tok = self.current()
  if tok.kind == kind {
    self.index = self.index + 1
    tok
  } else {
    raise self.parse_error_at(
      tok.start,
      tok.end,
      ParseErrorKind::ExpectedToken(expected=kind, actual=tok.kind),
    )
  }
}

///|
/// Special handling for expecting '>' token with token splitting for >> ambiguity
fn Parser::expect_gt(self : Parser) -> LexToken raise ParseError {
  let tok = self.current()
  match tok.kind {
    Gt => {
      self.index = self.index + 1
      tok
    }
    GtGt => {
      // Split >> into two > tokens
      // Return first >, replace current token with second > (keep index at second >)
      let first_gt = LexToken::new(
        LexKind::Gt,
        tok.start,
        tok.start + 1,
        tok.has_leading_line_break,
      )
      let second_gt = LexToken::new(LexKind::Gt, tok.start + 1, tok.end, false)
      self.tokens[self.index] = second_gt
      // Don't increment index - next call will consume the second >
      first_gt
    }
    GtGtGt => {
      // Split >>> into > and >>
      let first_gt = LexToken::new(
        LexKind::Gt,
        tok.start,
        tok.start + 1,
        tok.has_leading_line_break,
      )
      let rest_gtgt = LexToken::new(
        LexKind::GtGt,
        tok.start + 1,
        tok.end,
        false,
      )
      self.tokens[self.index] = rest_gtgt
      first_gt
    }
    GtGtEq => {
      // Split >>= into > and >=
      let first_gt = LexToken::new(
        LexKind::Gt,
        tok.start,
        tok.start + 1,
        tok.has_leading_line_break,
      )
      let rest_gteq = LexToken::new(
        LexKind::GtEq,
        tok.start + 1,
        tok.end,
        false,
      )
      self.tokens[self.index] = rest_gteq
      first_gt
    }
    GtGtGtEq => {
      // Split >>>= into > and >>=
      let first_gt = LexToken::new(
        LexKind::Gt,
        tok.start,
        tok.start + 1,
        tok.has_leading_line_break,
      )
      let rest_gtgteq = LexToken::new(
        LexKind::GtGtEq,
        tok.start + 1,
        tok.end,
        false,
      )
      self.tokens[self.index] = rest_gtgteq
      first_gt
    }
    _ =>
      raise self.parse_error_at(
        tok.start,
        tok.end,
        ParseErrorKind::ExpectedToken(expected=LexKind::Gt, actual=tok.kind),
      )
  }
}

///|
fn Parser::span_from(self : Parser, start : Int, end : Int) -> Span {
  span_with_line_info(self.line_starts, start, end)
}

///|
fn[T] Parser::node_array(
  self : Parser,
  elements : Array[T],
  start : Int,
  end : Int,
) -> NodeArray[T] {
  {
    elements,
    start: self.span_from(start, start),
    end: self.span_from(end, end),
    has_trailing_comma: false,
    is_missing_list: false,
  }
}

///|
fn type_keyword_from_name(name : String) -> TypeKeyword? {
  match name {
    "any" => Some(TypeKeyword::Any)
    "unknown" => Some(TypeKeyword::Unknown)
    "number" => Some(TypeKeyword::Number)
    "bigint" => Some(TypeKeyword::BigInt)
    "object" => Some(TypeKeyword::Object)
    "boolean" => Some(TypeKeyword::Boolean)
    "string" => Some(TypeKeyword::String)
    "symbol" => Some(TypeKeyword::Symbol)
    "void" => Some(TypeKeyword::Void)
    "undefined" => Some(TypeKeyword::Undefined)
    "null" => Some(TypeKeyword::Null)
    "never" => Some(TypeKeyword::Never)
    _ => None
  }
}

///|
fn Parser::parse_constructor_type(
  self : Parser,
  start : Int,
  is_abstract : Bool,
) -> TypeNode raise ParseError {
  if is_abstract {
    self.advance() |> ignore
  }
  self.expect(LexKind::KeywordNew) |> ignore
  let type_params = if self.at(LexKind::Lt) {
    Some(self.parse_type_parameters())
  } else {
    None
  }
  let params = self.parse_parameter_list(true)
  self.expect(LexKind::Arrow) |> ignore
  let return_type = if !self.at(LexKind::Semicolon) && !self.at(LexKind::RBrace) {
    Some(self.parse_type())
  } else {
    None
  }
  let end = if return_type is Some(t) {
    t.span.end
  } else {
    self.current().start
  }
  let ctor = ConstructorTypeNode::new(
    is_abstract, type_params, params, return_type,
  )
  TypeNode::new(TypeNodeKind::ConstructorType(ctor), self.span_from(start, end))
}

///|
fn Parser::parse_type(self : Parser) -> TypeNode raise ParseError {
  self.parse_conditional_type()
}

///|
fn Parser::parse_conditional_type(self : Parser) -> TypeNode raise ParseError {
  let check_type = self.parse_union_type()
  if self.at(LexKind::KeywordExtends) {
    let start = check_type.span.start
    self.advance() |> ignore
    self.in_conditional_extends = self.in_conditional_extends + 1
    let extends_type = self.parse_type()
    self.in_conditional_extends = self.in_conditional_extends - 1
    self.expect(LexKind::Question) |> ignore
    let true_type = self.parse_type()
    self.expect(LexKind::Colon) |> ignore
    let false_type = self.parse_type()
    let end = false_type.span.end
    TypeNode::new(
      TypeNodeKind::ConditionalType(
        ConditionalTypeNode::new(
          check_type, extends_type, true_type, false_type,
        ),
      ),
      self.span_from(start, end),
    )
  } else {
    check_type
  }
}

///|
fn Parser::parse_union_type(self : Parser) -> TypeNode raise ParseError {
  let types : Array[TypeNode] = []
  types.push(self.parse_intersection_type())
  while self.at(LexKind::Bar) {
    self.advance() |> ignore
    types.push(self.parse_intersection_type())
  }
  if types.length() == 1 {
    types[0]
  } else {
    let start = types[0].span.start
    let end = types[types.length() - 1].span.end
    TypeNode::new(
      TypeNodeKind::UnionType(self.node_array(types, start, end)),
      self.span_from(start, end),
    )
  }
}

///|
fn Parser::parse_intersection_type(self : Parser) -> TypeNode raise ParseError {
  let types : Array[TypeNode] = []
  types.push(self.parse_type_operator())
  while self.at(LexKind::Ampersand) {
    self.advance() |> ignore
    types.push(self.parse_type_operator())
  }
  if types.length() == 1 {
    types[0]
  } else {
    let start = types[0].span.start
    let end = types[types.length() - 1].span.end
    TypeNode::new(
      TypeNodeKind::IntersectionType(self.node_array(types, start, end)),
      self.span_from(start, end),
    )
  }
}

///|
fn Parser::parse_type_operator(self : Parser) -> TypeNode raise ParseError {
  let tok = self.current()
  match tok.kind {
    Identifier("keyof") => {
      self.advance() |> ignore
      let operand = self.parse_type_operator()
      TypeNode::new(
        TypeNodeKind::TypeOperator(
          TypeOperatorNode::new(TypeOperatorKind::KeyOf, operand),
        ),
        self.span_from(tok.start, operand.span.end),
      )
    }
    Identifier("unique") => {
      self.advance() |> ignore
      let operand = self.parse_type_operator()
      TypeNode::new(
        TypeNodeKind::TypeOperator(
          TypeOperatorNode::new(TypeOperatorKind::Unique, operand),
        ),
        self.span_from(tok.start, operand.span.end),
      )
    }
    Identifier("readonly") => {
      self.advance() |> ignore
      let operand = self.parse_type_operator()
      TypeNode::new(
        TypeNodeKind::TypeOperator(
          TypeOperatorNode::new(TypeOperatorKind::Readonly, operand),
        ),
        self.span_from(tok.start, operand.span.end),
      )
    }
    _ => self.parse_type_primary()
  }
}

///|
fn Parser::parse_type_primary(self : Parser) -> TypeNode raise ParseError {
  let tok = self.current()
  let mut base = match tok.kind {
    KeywordVoid => {
      self.advance() |> ignore
      TypeNode::new(
        TypeNodeKind::KeywordType(TypeKeyword::Void),
        self.span_from(tok.start, tok.end),
      )
    }
    KeywordNull => {
      self.advance() |> ignore
      TypeNode::new(
        TypeNodeKind::KeywordType(TypeKeyword::Null),
        self.span_from(tok.start, tok.end),
      )
    }
    KeywordTypeof => {
      let start = self.advance().start
      if self.at(LexKind::KeywordImport) {
        let import_type = self.parse_import_type()
        let end = import_type.span.end
        TypeNode::new(
          TypeNodeKind::TypeQuery(
            TypeQueryNode::new(
              TypeQueryExprName::ImportType(
                match import_type.kind {
                  TypeNodeKind::ImportType(node) => node
                  _ => abort("unreachable")
                },
              ),
              None,
            ),
          ),
          self.span_from(start, end),
        )
      } else {
        let first = self.parse_identifier()
        let (entity, end_start) = self.parse_entity_name(first)
        let type_args = if self.at(LexKind::Lt) {
          Some(self.parse_type_arguments())
        } else {
          None
        }
        let end = match type_args {
          Some(args) => args.end.end
          None => end_start
        }
        TypeNode::new(
          TypeNodeKind::TypeQuery(
            TypeQueryNode::new(TypeQueryExprName::EntityName(entity), type_args),
          ),
          self.span_from(start, end),
        )
      }
    }
    KeywordThis => {
      self.advance() |> ignore
      TypeNode::new(TypeNodeKind::ThisType, self.span_from(tok.start, tok.end))
    }
    KeywordTrue => {
      self.advance() |> ignore
      TypeNode::new(
        TypeNodeKind::LiteralType(
          Expr::new(ExprKind::TrueLiteral, self.span_from(tok.start, tok.end)),
        ),
        self.span_from(tok.start, tok.end),
      )
    }
    KeywordFalse => {
      self.advance() |> ignore
      TypeNode::new(
        TypeNodeKind::LiteralType(
          Expr::new(ExprKind::FalseLiteral, self.span_from(tok.start, tok.end)),
        ),
        self.span_from(tok.start, tok.end),
      )
    }
    Number(text) => {
      self.advance() |> ignore
      TypeNode::new(
        TypeNodeKind::LiteralType(
          Expr::new(
            ExprKind::NumericLiteral(
              NumericLiteral::new(text, self.span_from(tok.start, tok.end)),
            ),
            self.span_from(tok.start, tok.end),
          ),
        ),
        self.span_from(tok.start, tok.end),
      )
    }
    String(text) => {
      self.advance() |> ignore
      TypeNode::new(
        TypeNodeKind::LiteralType(
          Expr::new(
            ExprKind::StringLiteral(
              StringLiteral::new(text, self.span_from(tok.start, tok.end)),
            ),
            self.span_from(tok.start, tok.end),
          ),
        ),
        self.span_from(tok.start, tok.end),
      )
    }
    NoSubTemplate(text, _raw) => {
      self.advance() |> ignore
      TypeNode::new(
        TypeNodeKind::LiteralType(
          Expr::new(
            ExprKind::StringLiteral(
              StringLiteral::new(text, self.span_from(tok.start, tok.end)),
            ),
            self.span_from(tok.start, tok.end),
          ),
        ),
        self.span_from(tok.start, tok.end),
      )
    }
    TemplateHead(text, raw) =>
      self.parse_template_literal_type(text, raw, tok.start)
    Minus => {
      let start = self.advance().start
      let num_tok = self.current()
      match num_tok.kind {
        Number(text) => {
          self.advance() |> ignore
          let num_span = self.span_from(num_tok.start, num_tok.end)
          let num_expr = Expr::new(
            ExprKind::NumericLiteral(NumericLiteral::new(text, num_span)),
            num_span,
          )
          let full_span = self.span_from(start, num_tok.end)
          TypeNode::new(
            TypeNodeKind::LiteralType(
              Expr::new(
                ExprKind::PrefixUnaryExpr(
                  PrefixUnaryExpr::new(UnaryOperator::Minus, num_expr),
                ),
                full_span,
              ),
            ),
            full_span,
          )
        }
        _ =>
          raise self.parse_error_at(
            num_tok.start,
            num_tok.end,
            ParseErrorKind::ExpectedNumericLiteralAfterMinus(num_tok.kind),
          )
      }
    }
    KeywordImport => self.parse_import_type()
    KeywordNew =>
      if self.peek(1).kind == LexKind::LParen ||
        self.peek(1).kind == LexKind::Lt {
        self.parse_constructor_type(tok.start, false)
      } else {
        raise self.parse_error_at(
          tok.start,
          tok.end,
          ParseErrorKind::UnexpectedToken(tok.kind),
        )
      }
    Identifier(text) =>
      if text == "abstract" &&
        self.peek(1).kind == LexKind::KeywordNew &&
        (
          self.peek(2).kind == LexKind::LParen ||
          self.peek(2).kind == LexKind::Lt
        ) {
        self.parse_constructor_type(tok.start, true)
      } else if text == "infer" {
        let start = self.advance().start
        if self.in_conditional_extends == 0 {
          raise self.parse_error_at(
            start,
            self.current().start,
            ParseErrorKind::InferTypeOnlyInConditionalExtends,
          )
        }
        let name = self.parse_identifier()
        let constraint = if self.at(LexKind::KeywordExtends) {
          self.advance() |> ignore
          Some(self.parse_type())
        } else {
          None
        }
        let end = match constraint {
          Some(c) => c.span.end
          None => name.span.end
        }
        TypeNode::new(
          TypeNodeKind::InferType(
            TypeParameterDecl::new(
              name,
              TypeParameterModifiers::default(),
              constraint,
              None,
            ),
          ),
          self.span_from(start, end),
        )
      } else {
        let id = self.parse_identifier()
        match type_keyword_from_name(id.text) {
          Some(keyword) =>
            TypeNode::new(
              TypeNodeKind::KeywordType(keyword),
              self.span_from(tok.start, tok.end),
            )
          None => {
            let (entity, end_start) = self.parse_entity_name(id)
            self.parse_type_reference(tok.start, entity, end_start)
          }
        }
      }
    Lt =>
      if self.looks_like_type_arguments() {
        let start = self.current().start
        let type_params = self.parse_type_parameters()
        let params = self.parse_parameter_list(false)
        self.expect(LexKind::Arrow) |> ignore
        let return_type = if !self.at(LexKind::Semicolon) &&
          !self.at(LexKind::RBrace) {
          Some(self.parse_type())
        } else {
          None
        }
        let end = if return_type is Some(t) {
          t.span.end
        } else {
          self.current().start
        }
        let func = FunctionTypeNode::new(Some(type_params), params, return_type)
        TypeNode::new(
          TypeNodeKind::FunctionType(func),
          self.span_from(start, end),
        )
      } else {
        raise self.parse_error_at(
          tok.start,
          tok.end,
          ParseErrorKind::UnexpectedToken(tok.kind),
        )
      }
    LParen =>
      if self.looks_like_function_type() {
        let start = self.current().start
        let params = self.parse_parameter_list(false)
        self.expect(LexKind::Arrow) |> ignore
        let return_type = if !self.at(LexKind::Semicolon) &&
          !self.at(LexKind::RBrace) {
          Some(self.parse_type())
        } else {
          None
        }
        let end = if return_type is Some(t) {
          t.span.end
        } else {
          self.current().start
        }
        let func = FunctionTypeNode::new(None, params, return_type)
        TypeNode::new(
          TypeNodeKind::FunctionType(func),
          self.span_from(start, end),
        )
      } else {
        let start = self.advance().start
        let inner = self.parse_type()
        let end_tok = self.expect(LexKind::RParen)
        TypeNode::new(
          TypeNodeKind::ParenthesizedType(inner),
          self.span_from(start, end_tok.end),
        )
      }
    LBracket => {
      let start = self.advance().start
      let elements : Array[TupleElement] = []
      if !self.at(LexKind::RBracket) {
        for {
          let start = self.current().start
          let mut is_rest = false
          if self.at(LexKind::DotDotDot) {
            self.advance() |> ignore
            is_rest = true
          }
          let mut label : Identifier? = None
          let mut is_optional = false
          let mut type_node : TypeNode? = None
          match self.current().kind {
            Identifier(_) => {
              let next = self.peek(1)
              let is_label = next.kind == LexKind::Colon ||
                (
                  next.kind == LexKind::Question &&
                  self.peek(2).kind == LexKind::Colon
                )
              if is_label {
                label = Some(self.parse_identifier())
                if self.at(LexKind::Question) {
                  self.advance() |> ignore
                  is_optional = true
                }
                self.expect(LexKind::Colon) |> ignore
                type_node = Some(self.parse_type())
              }
            }
            _ => ()
          }
          if type_node is None {
            type_node = Some(self.parse_type())
            if !is_rest && !is_optional && self.at(LexKind::Question) {
              self.advance() |> ignore
              is_optional = true
            }
          }
          let type_node = type_node.unwrap()
          let end = if is_optional && label is None {
            // Unnamed optional type ending with ?
            // The ? was consumed, current startition is after ?
            self.tokens[self.index - 1].end
          } else {
            type_node.span.end
          }
          elements.push(
            TupleElement::new(
              label,
              is_optional,
              is_rest,
              type_node,
              self.span_from(start, end),
            ),
          )
          if self.at(LexKind::Comma) {
            self.advance() |> ignore
            if self.at(LexKind::RBracket) {
              break
            }
            continue
          }
          break
        }
      }
      let end_tok = self.expect(LexKind::RBracket)
      TypeNode::new(
        TypeNodeKind::TupleType(self.node_array(elements, start, end_tok.end)),
        self.span_from(start, end_tok.end),
      )
    }
    LBrace => {
      let start = self.advance().start
      if self.looks_like_mapped_type() {
        self.parse_mapped_type(start)
      } else {
        let members = self.parse_type_literal_members()
        let end_tok = self.expect(LexKind::RBrace)
        TypeNode::new(
          TypeNodeKind::TypeLiteral(
            self.node_array(members, start, end_tok.end),
          ),
          self.span_from(start, end_tok.end),
        )
      }
    }
    _ =>
      raise self.parse_error_at(
        tok.start,
        tok.end,
        ParseErrorKind::UnexpectedToken(tok.kind),
      )
  }
  for {
    if self.at(LexKind::LBracket) {
      if self.peek(1).kind == LexKind::RBracket {
        let start = base.span.start
        self.advance() |> ignore
        let end_tok = self.expect(LexKind::RBracket)
        base = TypeNode::new(
          TypeNodeKind::ArrayType(base),
          self.span_from(start, end_tok.end),
        )
        continue
      } else {
        let start = base.span.start
        self.advance() |> ignore
        let index_type = self.parse_type()
        let end_tok = self.expect(LexKind::RBracket)
        base = TypeNode::new(
          TypeNodeKind::IndexedAccessType(
            IndexedAccessTypeNode::new(base, index_type),
          ),
          self.span_from(start, end_tok.end),
        )
        continue
      }
    }
    break
  }
  base
}

///|
fn Parser::looks_like_mapped_type(self : Parser) -> Bool {
  let mut i = self.index
  // Skip optional 'readonly'
  match self.tokens[i].kind {
    Identifier("readonly") => i = i + 1
    _ => ()
  }
  // Expect [
  if self.tokens[i].kind != LexKind::LBracket {
    return false
  }
  i = i + 1
  // Expect identifier
  match self.tokens[i].kind {
    Identifier(_) => i = i + 1
    _ => return false
  }
  // Expect 'in'
  self.tokens[i].kind == LexKind::KeywordIn
}

///|
fn Parser::parse_mapped_type(
  self : Parser,
  start : Int,
) -> TypeNode raise ParseError {
  let is_readonly = match self.current().kind {
    Identifier("readonly") => {
      self.advance() |> ignore
      true
    }
    _ => false
  }
  self.expect(LexKind::LBracket) |> ignore
  let name = self.parse_identifier()
  self.expect(LexKind::KeywordIn) |> ignore
  let constraint = self.parse_type()
  let name_type = if self.at(LexKind::KeywordAs) {
    self.advance() |> ignore
    Some(self.parse_type())
  } else {
    None
  }
  self.expect(LexKind::RBracket) |> ignore
  let is_optional = if self.at(LexKind::Question) {
    self.advance() |> ignore
    true
  } else {
    false
  }
  let type_node = if self.at(LexKind::Colon) {
    self.advance() |> ignore
    Some(self.parse_type())
  } else {
    None
  }
  if self.at(LexKind::Semicolon) {
    self.advance() |> ignore
  }
  let end_tok = self.expect(LexKind::RBrace)
  let type_param = TypeParameterDecl::new(
    name,
    TypeParameterModifiers::new(),
    Some(constraint),
    None,
  )
  TypeNode::new(
    TypeNodeKind::MappedType(
      MappedTypeNode::new(
        is_readonly, type_param, name_type, is_optional, type_node,
      ),
    ),
    self.span_from(start, end_tok.end),
  )
}

///|
fn Parser::parse_import_type(self : Parser) -> TypeNode raise ParseError {
  let start = self.expect(LexKind::KeywordImport).start
  self.expect(LexKind::LParen) |> ignore
  let arg_tok = self.current()
  let argument = match arg_tok.kind {
    String(text) => {
      self.advance() |> ignore
      Expr::new(
        ExprKind::StringLiteral(
          StringLiteral::new(text, self.span_from(arg_tok.start, arg_tok.end)),
        ),
        self.span_from(arg_tok.start, arg_tok.end),
      )
    }
    _ =>
      raise self.parse_error_at(
        arg_tok.start,
        arg_tok.end,
        ParseErrorKind::ExpectedStringLiteralInImportType(arg_tok.kind),
      )
  }
  let rparen_end = self.expect(LexKind::RParen).end
  let (qualifier, end_after_qual) = if self.at(LexKind::Dot) {
    self.advance() |> ignore
    let first = self.parse_identifier()
    let (entity, end_start) = self.parse_entity_name(first)
    (Some(entity), end_start)
  } else {
    (None, rparen_end)
  }
  let type_args = if self.at(LexKind::Lt) {
    Some(self.parse_type_arguments())
  } else {
    None
  }
  let end = match type_args {
    Some(args) => args.end.end
    None => end_after_qual
  }
  TypeNode::new(
    TypeNodeKind::ImportType(
      ImportTypeNode::new(argument, qualifier, type_args),
    ),
    self.span_from(start, end),
  )
}

///|
fn Parser::parse_template_literal_type(
  self : Parser,
  head_text : String,
  head_raw : String,
  start : Int,
) -> TypeNode raise ParseError {
  self.advance() |> ignore
  let head = TemplateHead::new(head_text, head_raw)
  let spans : Array[TemplateLiteralTypeSpan] = []
  let mut end_start = start
  for {
    let type_node = self.parse_type()
    let tok = self.current()
    match tok.kind {
      TemplateMiddle(text, raw) => {
        self.advance() |> ignore
        let middle = TemplateMiddle::new(text, raw)
        spans.push(
          TemplateLiteralTypeSpan::new(
            type_node,
            TemplateMiddleOrTemplateTail::TemplateMiddle(middle),
          ),
        )
        continue
      }
      TemplateTail(text, raw) => {
        end_start = tok.end
        self.advance() |> ignore
        let tail = TemplateTail::new(text, raw)
        spans.push(
          TemplateLiteralTypeSpan::new(
            type_node,
            TemplateMiddleOrTemplateTail::TemplateTail(tail),
          ),
        )
        break
      }
      _ =>
        raise self.parse_error_at(
          tok.start,
          tok.end,
          ParseErrorKind::ExpectedTemplateLiteralTypeSpan(tok.kind),
        )
    }
  }
  TypeNode::new(
    TypeNodeKind::TemplateLiteralType(
      TemplateLiteralTypeNode::new(
        head,
        self.node_array(spans, start, end_start),
      ),
    ),
    self.span_from(start, end_start),
  )
}

///|
fn Parser::parse_type_reference(
  self : Parser,
  start : Int,
  entity : EntityName,
  entity_end : Int,
) -> TypeNode raise ParseError {
  let type_args = if self.at(LexKind::Lt) {
    Some(self.parse_type_arguments())
  } else {
    None
  }
  let ref_node = TypeReferenceNode::new(entity, type_args)
  let end = match type_args {
    Some(args) => args.end.end
    None => entity_end
  }
  TypeNode::new(
    TypeNodeKind::TypeReference(ref_node),
    self.span_from(start, end),
  )
}

///|
fn Parser::parse_type_arguments(
  self : Parser,
) -> NodeArray[TypeNode] raise ParseError {
  let start = self.expect(LexKind::Lt).start
  let args : Array[TypeNode] = []
  if !self.at(LexKind::Gt) {
    for {
      args.push(self.parse_type())
      if self.at(LexKind::Comma) {
        self.advance() |> ignore
        continue
      }
      break
    }
  }
  let end_tok = self.expect_gt()
  self.node_array(args, start, end_tok.end)
}

///|
fn Parser::parse_type_parameters(
  self : Parser,
) -> NodeArray[TypeParameterDecl] raise ParseError {
  let start = self.expect(LexKind::Lt).start
  let params : Array[TypeParameterDecl] = []
  if !self.at(LexKind::Gt) {
    for {
      let variance_items : Array[ModifierKind] = []
      let mut variance_start : Int? = None
      let mut variance_end : Int? = None
      let mut seen_in = false
      let mut seen_out = false
      for {
        let tok = self.current()
        match tok.kind {
          KeywordIn | Identifier("in") => {
            if seen_in {
              raise self.parse_error_at(
                tok.start,
                tok.end,
                ParseErrorKind::DuplicateModifier(ModifierKind::In),
              )
            }
            if seen_out {
              raise self.parse_error_at(
                tok.start,
                tok.end,
                ParseErrorKind::InvalidVarianceOrder(
                  previous=ModifierKind::Out,
                  current=ModifierKind::In,
                ),
              )
            }
            self.advance() |> ignore
            variance_items.push(ModifierKind::In)
            seen_in = true
          }
          Identifier("out") => {
            if seen_out {
              raise self.parse_error_at(
                tok.start,
                tok.end,
                ParseErrorKind::DuplicateModifier(ModifierKind::Out),
              )
            }
            self.advance() |> ignore
            variance_items.push(ModifierKind::Out)
            seen_out = true
          }
          _ => break
        }
        if variance_start is None {
          variance_start = Some(tok.start)
        }
        variance_end = Some(tok.end)
      }
      let variance = if variance_items.length() > 0 {
        Some(
          self.node_array(
            variance_items,
            variance_start.unwrap_or(start),
            variance_end.unwrap_or(start),
          ),
        )
      } else {
        None
      }
      let name = self.parse_identifier()
      let constraint = if self.at(LexKind::KeywordExtends) {
        self.advance() |> ignore
        Some(self.parse_type())
      } else {
        None
      }
      let default_type = if self.at(LexKind::Eq) {
        self.advance() |> ignore
        Some(self.parse_type())
      } else {
        None
      }
      let span = match variance {
        Some(v) => v.start
        None => name.span
      }
      let type_param_mods = parse_type_parameter_modifiers(variance, span)
      params.push(
        TypeParameterDecl::new(name, type_param_mods, constraint, default_type),
      )
      if self.at(LexKind::Comma) {
        self.advance() |> ignore
        continue
      }
      break
    }
  }
  let end_tok = self.expect_gt()
  self.node_array(params, start, end_tok.end)
}

///|
fn Parser::parse_identifier(self : Parser) -> Identifier raise ParseError {
  let tok = self.current()
  match tok.kind {
    Identifier(name) => {
      self.advance() |> ignore
      Identifier::new(name, self.span_from(tok.start, tok.end))
    }
    _ =>
      if is_contextual_keyword_kind(tok.kind) {
        match keyword_text(tok.kind) {
          Some(text) => {
            self.advance() |> ignore
            Identifier::new(text, self.span_from(tok.start, tok.end))
          }
          None =>
            raise self.parse_error_at(
              tok.start,
              tok.end,
              ParseErrorKind::UnexpectedToken(tok.kind),
            )
        }
      } else {
        raise self.parse_error_at(
          tok.start,
          tok.end,
          ParseErrorKind::UnexpectedToken(tok.kind),
        )
      }
  }
}

///|
fn is_contextual_keyword_kind(kind : LexKind) -> Bool {
  kind
  is (KeywordType
  | KeywordAs
  | KeywordFrom
  | KeywordOf
  | KeywordUsing
  | KeywordGlobal)
}

///|
fn is_identifier_or_contextual(kind : LexKind) -> Bool {
  match kind {
    Identifier(_) => true
    _ => is_contextual_keyword_kind(kind)
  }
}

///|
fn keyword_text(kind : LexKind) -> String? {
  match kind {
    KeywordLet => Some("let")
    KeywordConst => Some("const")
    KeywordVar => Some("var")
    KeywordUsing => Some("using")
    KeywordFunction => Some("function")
    KeywordReturn => Some("return")
    KeywordIf => Some("if")
    KeywordElse => Some("else")
    KeywordWhile => Some("while")
    KeywordFor => Some("for")
    KeywordDo => Some("do")
    KeywordBreak => Some("break")
    KeywordContinue => Some("continue")
    KeywordSwitch => Some("switch")
    KeywordCase => Some("case")
    KeywordDefault => Some("default")
    KeywordDebugger => Some("debugger")
    KeywordTry => Some("try")
    KeywordCatch => Some("catch")
    KeywordFinally => Some("finally")
    KeywordThrow => Some("throw")
    KeywordWith => Some("with")
    KeywordNew => Some("new")
    KeywordClass => Some("class")
    KeywordInterface => Some("interface")
    KeywordType => Some("type")
    KeywordEnum => Some("enum")
    KeywordModule => Some("module")
    KeywordNamespace => Some("namespace")
    KeywordImport => Some("import")
    KeywordExport => Some("export")
    KeywordAssert => Some("assert")
    KeywordGlobal => Some("global")
    KeywordFrom => Some("from")
    KeywordExtends => Some("extends")
    KeywordImplements => Some("implements")
    KeywordIn => Some("in")
    KeywordInstanceof => Some("instanceof")
    KeywordOf => Some("of")
    KeywordAs => Some("as")
    KeywordSatisfies => Some("satisfies")
    KeywordDelete => Some("delete")
    KeywordTypeof => Some("typeof")
    KeywordVoid => Some("void")
    KeywordAwait => Some("await")
    KeywordYield => Some("yield")
    KeywordThis => Some("this")
    KeywordSuper => Some("super")
    KeywordTrue => Some("true")
    KeywordFalse => Some("false")
    KeywordNull => Some("null")
    _ => None
  }
}

///|
fn Parser::parse_identifier_name(self : Parser) -> Identifier raise ParseError {
  let tok = self.current()
  match tok.kind {
    Identifier(name) => {
      self.advance() |> ignore
      Identifier::new(name, self.span_from(tok.start, tok.end))
    }
    _ =>
      match keyword_text(tok.kind) {
        Some(text) => {
          self.advance() |> ignore
          Identifier::new(text, self.span_from(tok.start, tok.end))
        }
        None =>
          raise self.parse_error_at(
            tok.start,
            tok.end,
            ParseErrorKind::UnexpectedToken(tok.kind),
          )
      }
  }
}

///|
fn Parser::is_module_export_name_start(self : Parser) -> Bool {
  match self.current().kind {
    Identifier(_) => true
    String(_) => true
    _ => keyword_text(self.current().kind) is Some(_)
  }
}

///|
fn Parser::parse_module_export_name(
  self : Parser,
) -> Identifier raise ParseError {
  let tok = self.current()
  match tok.kind {
    String(value) => {
      self.advance() |> ignore
      Identifier::new(value, self.span_from(tok.start, tok.end))
    }
    _ => self.parse_identifier_name()
  }
}

///|
fn Parser::parse_parameter_list(
  self : Parser,
  allow_modifiers : Bool,
) -> NodeArray[ParameterDecl] raise ParseError {
  let open = self.expect(LexKind::LParen)
  let params : Array[ParameterDecl] = []
  if !self.at(LexKind::RParen) {
    for {
      let modifiers = if allow_modifiers {
        self.parse_parameter_modifiers(self.current().start)
      } else {
        None
      }
      let mut is_rest = false
      if self.at(LexKind::DotDotDot) {
        self.advance() |> ignore
        is_rest = true
      }
      let (binding, binding_span) = self.parse_binding_name()
      let mut is_optional = false
      if self.at(LexKind::Question) {
        self.advance() |> ignore
        is_optional = true
      }
      let type_node = if self.at(LexKind::Colon) {
        self.advance() |> ignore
        Some(self.parse_type())
      } else {
        None
      }
      let initializer = if self.at(LexKind::Eq) {
        self.advance() |> ignore
        Some(self.parse_assignment_expr())
      } else {
        None
      }
      let param_start = if modifiers is Some(list) {
        list.start.start
      } else {
        binding_span.start
      }
      let end_start = if initializer is Some(init) {
        init.span.end
      } else if type_node is Some(type_value) {
        type_value.span.end
      } else {
        binding_span.end
      }
      let span = match modifiers {
        Some(m) => m.start
        None => binding_span
      }
      let param_mods = parse_parameter_modifiers(modifiers, span)
      let param = ParameterDecl::new(
        binding,
        param_mods,
        is_rest,
        is_optional,
        type_node,
        initializer,
        self.span_from(param_start, end_start),
      )
      params.push(param)
      if is_rest && self.at(LexKind::Comma) {
        let tok = self.current()
        raise self.parse_error_at(
          tok.start,
          tok.end,
          ParseErrorKind::RestParameterMustBeLastInParameterList,
        )
      }
      if self.at(LexKind::Comma) {
        self.advance() |> ignore
        continue
      }
      break
    }
  }
  let end_tok = self.expect(LexKind::RParen)
  self.node_array(params, open.start, end_tok.end)
}

///|
fn Parser::looks_like_arrow_from_paren(self : Parser) -> Bool {
  self.looks_like_arrow_from_paren_at(self.index)
}

///|
fn Parser::looks_like_arrow_from_paren_at(
  self : Parser,
  start_index : Int,
) -> Bool {
  let mut depth = 0
  let mut i = start_index
  let len = self.tokens.length()
  while i < len {
    match self.tokens[i].kind {
      LexKind::LParen => depth = depth + 1
      LexKind::RParen => {
        depth = depth - 1
        if depth == 0 {
          if i + 1 < len {
            return self.tokens[i + 1].kind == LexKind::Arrow
          }
          return false
        }
      }
      LexKind::Eof => return false
      _ => ()
    }
    i = i + 1
  }
  false
}

///|
fn Parser::looks_like_type_arguments(self : Parser) -> Bool {
  if !self.at(LexKind::Lt) {
    return false
  }
  let mut depth = 0
  let mut i = self.index
  let len = self.tokens.length()
  while i < len {
    match self.tokens[i].kind {
      LexKind::Lt => depth = depth + 1
      LexKind::Gt => {
        depth = depth - 1
        if depth == 0 {
          if i + 1 < len {
            return self.tokens[i + 1].kind == LexKind::LParen
          }
          return false
        }
      }
      LexKind::Eof => return false
      _ => ()
    }
    i = i + 1
  }
  false
}

///|
fn Parser::looks_like_function_type(self : Parser) -> Bool {
  if !self.at(LexKind::LParen) {
    return false
  }
  let mut depth = 0
  let mut i = self.index
  let len = self.tokens.length()
  while i < len {
    match self.tokens[i].kind {
      LexKind::LParen => depth = depth + 1
      LexKind::RParen => {
        depth = depth - 1
        if depth == 0 {
          if i + 1 < len {
            return self.tokens[i + 1].kind == LexKind::Arrow
          }
          return false
        }
      }
      LexKind::Eof => return false
      _ => ()
    }
    i = i + 1
  }
  false
}

///|
fn Parser::parse_entity_name(
  self : Parser,
  first : Identifier,
) -> (EntityName, Int) raise ParseError {
  let mut current = EntityName::Identifier(first)
  let mut end_start = first.span.end
  while self.at(LexKind::Dot) {
    self.advance() |> ignore
    let right = self.parse_identifier()
    end_start = right.span.end
    current = EntityName::QualifiedName(QualifiedName::new(current, right))
  }
  (current, end_start)
}

///|
fn Parser::parse_type_parameter_list(
  self : Parser,
) -> NodeArray[TypeParameterDecl]? raise ParseError {
  if self.at(LexKind::Lt) {
    Some(self.parse_type_parameters())
  } else {
    None
  }
}

///|
fn Parser::parse_binding_name(
  self : Parser,
) -> (BindingName, Span) raise ParseError {
  let tok = self.current()
  match tok.kind {
    LBrace => {
      let start = self.advance().start
      let elements = self.parse_object_binding_elements()
      let end_tok = self.expect(LexKind::RBrace)
      let span = self.span_from(start, end_tok.end)
      (
        BindingName::ObjectBindingPattern(
          self.node_array(elements, start, end_tok.end),
        ),
        span,
      )
    }
    LBracket => {
      let start = self.advance().start
      let elements = self.parse_array_binding_elements()
      let end_tok = self.expect(LexKind::RBracket)
      let span = self.span_from(start, end_tok.end)
      (
        BindingName::ArrayBindingPattern(
          self.node_array(elements, start, end_tok.end),
        ),
        span,
      )
    }
    _ => {
      let id = self.parse_identifier()
      (BindingName::Identifier(id), id.span)
    }
  }
}

///|
fn Parser::parse_object_binding_elements(
  self : Parser,
) -> Array[BindingElement] raise ParseError {
  let elements : Array[BindingElement] = []
  if !self.at(LexKind::RBrace) {
    for {
      if self.at(LexKind::DotDotDot) {
        self.advance() |> ignore
        let (name, _) = self.parse_binding_name()
        elements.push(BindingElement::new(name, None, true, None))
        if self.at(LexKind::Comma) && self.peek(1).kind != LexKind::RBrace {
          let tok = self.current()
          raise self.parse_error_at(
            tok.start,
            tok.end,
            ParseErrorKind::RestBindingMustBeLastInPattern,
          )
        }
      } else {
        let name_tok = self.current()
        let prop_name = self.parse_property_name()
        if self.at(LexKind::Colon) {
          self.advance() |> ignore
          let (name, _) = self.parse_binding_name()
          let initializer = if self.at(LexKind::Eq) {
            self.advance() |> ignore
            Some(self.parse_assignment_expr())
          } else {
            None
          }
          elements.push(
            BindingElement::new(name, Some(prop_name), false, initializer),
          )
        } else {
          match prop_name {
            PropertyName::Identifier(id) => {
              let initializer = if self.at(LexKind::Eq) {
                self.advance() |> ignore
                Some(self.parse_assignment_expr())
              } else {
                None
              }
              elements.push(
                BindingElement::new(
                  BindingName::Identifier(id),
                  None,
                  false,
                  initializer,
                ),
              )
            }
            _ =>
              raise self.parse_error_at(
                name_tok.start,
                name_tok.end,
                ParseErrorKind::UnexpectedToken(name_tok.kind),
              )
          }
        }
      }
      if self.at(LexKind::Comma) {
        self.advance() |> ignore
        if self.at(LexKind::RBrace) {
          break
        }
        continue
      }
      break
    }
  }
  elements
}

///|
fn Parser::parse_array_binding_elements(
  self : Parser,
) -> Array[ArrayBindingElement] raise ParseError {
  let elements : Array[ArrayBindingElement] = []
  if !self.at(LexKind::RBracket) {
    for {
      if self.at(LexKind::Comma) {
        self.advance() |> ignore
        elements.push(ArrayBindingElement::OmittedExpr)
        if self.at(LexKind::RBracket) {
          break
        }
        continue
      }
      if self.at(LexKind::DotDotDot) {
        self.advance() |> ignore
        let (name, _) = self.parse_binding_name()
        let element = BindingElement::new(name, None, true, None)
        elements.push(ArrayBindingElement::BindingElement(element))
        if self.at(LexKind::Comma) && self.peek(1).kind != LexKind::RBracket {
          let tok = self.current()
          raise self.parse_error_at(
            tok.start,
            tok.end,
            ParseErrorKind::RestBindingMustBeLastInPattern,
          )
        }
      } else {
        let (name, _) = self.parse_binding_name()
        let initializer = if self.at(LexKind::Eq) {
          self.advance() |> ignore
          Some(self.parse_assignment_expr())
        } else {
          None
        }
        let element = BindingElement::new(name, None, false, initializer)
        elements.push(ArrayBindingElement::BindingElement(element))
      }
      if self.at(LexKind::Comma) {
        self.advance() |> ignore
        if self.at(LexKind::RBracket) {
          break
        }
        continue
      }
      break
    }
  }
  elements
}

///|
fn Parser::parse_type_literal_members(
  self : Parser,
) -> Array[TypeElement] raise ParseError {
  let members : Array[TypeElement] = []
  while !self.at(LexKind::RBrace) && !self.at(LexKind::Eof) {
    if self.at(LexKind::Semicolon) || self.at(LexKind::Comma) {
      self.advance() |> ignore
      continue
    }
    if self.at(LexKind::LParen) {
      let params = self.parse_parameter_list(false)
      let type_node = if self.at(LexKind::Colon) {
        self.advance() |> ignore
        Some(self.parse_type())
      } else {
        None
      }
      members.push(
        TypeElement::CallSignature(
          CallSignatureDecl::new(None, params, type_node),
        ),
      )
      continue
    }
    if self.at(LexKind::KeywordNew) {
      self.advance() |> ignore
      let params = self.parse_parameter_list(false)
      let type_node = if self.at(LexKind::Colon) {
        self.advance() |> ignore
        Some(self.parse_type())
      } else {
        None
      }
      members.push(
        TypeElement::ConstructSignature(
          ConstructSignatureDecl::new(None, params, type_node),
        ),
      )
      continue
    }
    if self.at(LexKind::LBracket) {
      self.advance() |> ignore
      let param_name = self.parse_identifier()
      self.expect(LexKind::Colon) |> ignore
      let key_type = self.parse_type()
      self.expect(LexKind::RBracket) |> ignore
      self.expect(LexKind::Colon) |> ignore
      let value_type = self.parse_type()
      let param_span = self.span_from(param_name.span.start, key_type.span.end)
      let param = ParameterDecl::new(
        BindingName::Identifier(param_name),
        ParameterModifiers::default(),
        false,
        false,
        Some(key_type),
        None,
        param_span,
      )
      let param_start = param.span.start
      let param_end = param.span.end
      members.push(
        TypeElement::IndexSignature(
          IndexSignatureDecl::new(
            false,
            self.node_array([param], param_start, param_end),
            value_type,
          ),
        ),
      )
      continue
    }
    let name = self.parse_property_name()
    let mut is_optional = false
    if self.at(LexKind::Question) {
      self.advance() |> ignore
      is_optional = true
    }
    match name {
      PropertyName::Identifier(id) =>
        if id.text == "get" && !self.at(LexKind::Colon) {
          let accessor_name = self.parse_property_name()
          let params = self.parse_parameter_list(false)
          let type_node = if self.at(LexKind::Colon) {
            self.advance() |> ignore
            Some(self.parse_type())
          } else {
            None
          }
          members.push(
            TypeElement::GetAccessor(
              GetAccessorDecl::new(
                None,
                ClassMemberModifiers::default(),
                accessor_name,
                params,
                type_node,
                None,
              ),
            ),
          )
          continue
        } else if id.text == "set" && !self.at(LexKind::Colon) {
          let accessor_name = self.parse_property_name()
          let params = self.parse_parameter_list(false)
          members.push(
            TypeElement::SetAccessor(
              SetAccessorDecl::new(
                None,
                ClassMemberModifiers::default(),
                accessor_name,
                params,
                None,
              ),
            ),
          )
          continue
        }
      _ => ()
    }
    if self.at(LexKind::LParen) {
      let type_params = self.parse_type_parameter_list()
      let params = self.parse_parameter_list(false)
      let type_node = if self.at(LexKind::Colon) {
        self.advance() |> ignore
        Some(self.parse_type())
      } else {
        None
      }
      members.push(
        TypeElement::MethodSignature(
          MethodSignature::new(
            name, is_optional, type_params, params, type_node,
          ),
        ),
      )
      continue
    }
    let type_node = if self.at(LexKind::Colon) {
      self.advance() |> ignore
      Some(self.parse_type())
    } else {
      None
    }
    members.push(
      TypeElement::PropertySignature(
        PropertySignature::new(false, name, is_optional, type_node),
      ),
    )
  }
  members
}

///|
fn Parser::parse_property_name(self : Parser) -> PropertyName raise ParseError {
  let tok = self.current()
  match tok.kind {
    Identifier(_) => {
      let id = self.parse_identifier()
      PropertyName::Identifier(id)
    }
    PrivateIdentifier(name) => {
      self.advance() |> ignore
      PropertyName::PrivateIdentifier(name)
    }
    String(value) => {
      self.advance() |> ignore
      let lit = StringLiteral::new(value, self.span_from(tok.start, tok.end))
      PropertyName::StringLiteral(lit)
    }
    Number(value) => {
      self.advance() |> ignore
      let lit = NumericLiteral::new(value, self.span_from(tok.start, tok.end))
      PropertyName::NumericLiteral(lit)
    }
    LBracket => {
      self.advance() |> ignore
      let expr = self.parse_assignment_expr()
      self.expect(LexKind::RBracket) |> ignore
      PropertyName::ComputedPropertyName(expr)
    }
    _ =>
      raise self.parse_error_at(
        tok.start,
        tok.end,
        ParseErrorKind::UnexpectedPrimary(tok.kind),
      )
  }
}

///|
fn Parser::parse_array_literal(
  self : Parser,
  start : Int,
) -> Expr raise ParseError {
  let elements : Array[Expr] = []
  if !self.at(LexKind::RBracket) {
    for {
      if self.at(LexKind::Comma) {
        let comma = self.advance()
        elements.push(
          Expr::new(
            ExprKind::OmittedExpr,
            self.span_from(comma.start, comma.end),
          ),
        )
        continue
      }
      if self.at(LexKind::DotDotDot) {
        let spread_tok = self.advance()
        let expr = self.parse_assignment_expr()
        let span = self.span_from(spread_tok.start, expr.span.end)
        elements.push(Expr::new(ExprKind::SpreadElement(expr), span))
      } else {
        elements.push(self.parse_assignment_expr())
      }
      if self.at(LexKind::Comma) {
        self.advance() |> ignore
        if self.at(LexKind::RBracket) {
          break
        }
        continue
      }
      break
    }
  }
  let end_tok = self.expect(LexKind::RBracket)
  let span = self.span_from(start, end_tok.end)
  Expr::new(
    ExprKind::ArrayLiteralExpr(self.node_array(elements, start, end_tok.end)),
    span,
  )
}

///|
fn Parser::parse_object_literal(
  self : Parser,
  start : Int,
) -> Expr raise ParseError {
  let elements : Array[ObjectLiteralElementLike] = []
  if !self.at(LexKind::RBrace) {
    for {
      if self.at(LexKind::DotDotDot) {
        self.advance() |> ignore
        let expr = self.parse_assignment_expr()
        elements.push(ObjectLiteralElementLike::SpreadAssignment(expr))
      } else {
        let mut is_generator = false
        if self.at(LexKind::Star) {
          self.advance() |> ignore
          is_generator = true
        }
        let name_tok = self.current()
        let prop_name = self.parse_property_name()
        let mut is_optional = false
        if self.at(LexKind::Question) {
          self.advance() |> ignore
          is_optional = true
        }
        if !is_generator {
          match prop_name {
            PropertyName::Identifier(id) =>
              if id.text == "get" && !self.at(LexKind::Colon) {
                let accessor_name = self.parse_property_name()
                let params = self.parse_parameter_list(false)
                let type_node = if self.at(LexKind::Colon) {
                  self.advance() |> ignore
                  Some(self.parse_type())
                } else {
                  None
                }
                let (body, _) = self.parse_block_with_function_context(
                  false, false,
                )
                elements.push(
                  ObjectLiteralElementLike::GetAccessor(
                    GetAccessorDecl::new(
                      None,
                      ClassMemberModifiers::default(),
                      accessor_name,
                      params,
                      type_node,
                      Some(body),
                    ),
                  ),
                )
                if self.at(LexKind::Comma) {
                  self.advance() |> ignore
                }
                if self.at(LexKind::RBrace) {
                  break
                }
                continue
              } else if id.text == "set" && !self.at(LexKind::Colon) {
                let accessor_name = self.parse_property_name()
                let params = self.parse_parameter_list(false)
                let (body, _) = self.parse_block_with_function_context(
                  false, false,
                )
                elements.push(
                  ObjectLiteralElementLike::SetAccessor(
                    SetAccessorDecl::new(
                      None,
                      ClassMemberModifiers::default(),
                      accessor_name,
                      params,
                      Some(body),
                    ),
                  ),
                )
                if self.at(LexKind::Comma) {
                  self.advance() |> ignore
                }
                if self.at(LexKind::RBrace) {
                  break
                }
                continue
              }
            _ => ()
          }
        }
        if self.at(LexKind::Colon) {
          self.advance() |> ignore
          let value = self.parse_assignment_expr()
          elements.push(
            ObjectLiteralElementLike::PropertyAssignment(
              PropertyAssignment::new(prop_name, value),
            ),
          )
        } else if self.at(LexKind::LParen) {
          let params = self.parse_parameter_list(false)
          let type_node = if self.at(LexKind::Colon) {
            self.advance() |> ignore
            Some(self.parse_type())
          } else {
            None
          }
          let (body, _) = self.parse_block_with_function_context(
            is_generator, false,
          )
          elements.push(
            ObjectLiteralElementLike::MethodDecl(
              MethodDecl::new(
                None,
                ClassMemberModifiers::default(),
                is_generator,
                prop_name,
                is_optional,
                None,
                params,
                type_node,
                Some(body),
              ),
            ),
          )
        } else {
          match prop_name {
            PropertyName::Identifier(id) =>
              elements.push(
                ObjectLiteralElementLike::ShorthandPropertyAssignment(
                  ShorthandPropertyAssignment::new(id),
                ),
              )
            _ =>
              raise self.parse_error_at(
                name_tok.start,
                name_tok.end,
                ParseErrorKind::UnexpectedToken(name_tok.kind),
              )
          }
        }
      }
      if self.at(LexKind::Comma) {
        self.advance() |> ignore
        if self.at(LexKind::RBrace) {
          break
        }
        continue
      }
      break
    }
  }
  let end_tok = self.expect(LexKind::RBrace)
  let span = self.span_from(start, end_tok.end)
  Expr::new(
    ExprKind::ObjectLiteralExpr(self.node_array(elements, start, end_tok.end)),
    span,
  )
}

///|
fn Parser::parse_new_expr(self : Parser, start : Int) -> Expr raise ParseError {
  let callee = self.parse_starttfix_expr()
  let type_args = if self.looks_like_type_arguments() {
    Some(self.parse_type_arguments())
  } else {
    None
  }
  let args = if self.at(LexKind::LParen) {
    let open = self.advance()
    let list : Array[Expr] = []
    if !self.at(LexKind::RParen) {
      for {
        list.push(self.parse_assignment_expr())
        if self.at(LexKind::Comma) {
          self.advance() |> ignore
          continue
        }
        break
      }
    }
    let end_tok = self.expect(LexKind::RParen)
    Some(self.node_array(list, open.start, end_tok.end))
  } else {
    None
  }
  let end = match args {
    Some(list) => list.end.end
    None => callee.span.end
  }
  let new_expr = NewExpr::new(callee, type_args, args)
  Expr::new(ExprKind::NewExpr(new_expr), self.span_from(start, end))
}

///|
fn Parser::parse_function_expr(
  self : Parser,
  start : Int,
) -> Expr raise ParseError {
  let mut is_generator = false
  if self.at(LexKind::Star) {
    self.advance() |> ignore
    is_generator = true
  }
  let name = if self.current().kind is Identifier(_) {
    Some(self.parse_identifier())
  } else {
    None
  }
  let params = self.parse_parameter_list(false)
  let return_type = if self.at(LexKind::Colon) {
    self.advance() |> ignore
    Some(self.parse_type())
  } else {
    None
  }
  let (body_stmts, body_span) = self.parse_block_with_function_context(
    is_generator, false,
  )
  let func = FunctionExpr::new(
    false,
    is_generator,
    name,
    None,
    params,
    return_type,
    Some(body_stmts),
  )
  let span = self.span_from(start, body_span.end)
  Expr::new(ExprKind::FunctionExpr(func), span)
}

///|
fn Parser::parse_template_expr(
  self : Parser,
  head_text : String,
  head_raw : String,
  start : Int,
) -> Expr raise ParseError {
  let head = TemplateHead::new(head_text, head_raw)
  let spans : Array[TemplateSpan] = []
  let mut end_start = start
  for {
    let expr = self.parse_expr()
    let tok = self.current()
    match tok.kind {
      TemplateMiddle(text, raw) => {
        self.advance() |> ignore
        let middle = TemplateMiddle::new(text, raw)
        spans.push(
          TemplateSpan::new(
            expr,
            TemplateMiddleOrTemplateTail::TemplateMiddle(middle),
          ),
        )
        continue
      }
      TemplateTail(text, raw) => {
        self.advance() |> ignore
        let tail = TemplateTail::new(text, raw)
        spans.push(
          TemplateSpan::new(
            expr,
            TemplateMiddleOrTemplateTail::TemplateTail(tail),
          ),
        )
        end_start = tok.end
        break
      }
      _ =>
        raise self.parse_error_at(
          tok.start,
          tok.end,
          ParseErrorKind::ExpectedTemplateSpan(tok.kind),
        )
    }
  }
  let span = self.span_from(start, end_start)
  let template = TemplateExpr::new(
    head,
    self.node_array(spans, start, end_start),
  )
  Expr::new(ExprKind::TemplateExpr(template), span)
}

///|
fn modifiers_has(
  modifiers : NodeArray[ModifierKind]?,
  kind : ModifierKind,
) -> Bool {
  match modifiers {
    Some(list) => {
      for item in list.elements.iter() {
        if item == kind {
          return true
        }
      }
      false
    }
    None => false
  }
}

///|
fn Parser::parse_expr_with_type_arguments(
  self : Parser,
) -> ExprWithTypeArguments raise ParseError {
  let expr = self.parse_starttfix_expr()
  let type_args = if self.at(LexKind::Lt) && self.looks_like_type_arguments() {
    Some(self.parse_type_arguments())
  } else {
    None
  }
  ExprWithTypeArguments::new(expr, type_args)
}

///|
fn Parser::parse_heritage_clause(
  self : Parser,
  kind : HeritageKind,
  start : Int,
) -> HeritageClause raise ParseError {
  let types : Array[ExprWithTypeArguments] = []
  for {
    types.push(self.parse_expr_with_type_arguments())
    if self.at(LexKind::Comma) {
      self.advance() |> ignore
      continue
    }
    break
  }
  HeritageClause::new(kind, self.node_array(types, start, self.current().start))
}

///|
fn Parser::parse_class_elements(
  self : Parser,
  start : Int,
) -> NodeArray[ClassElement] raise ParseError {
  let members : Array[ClassElement] = []
  while !self.at(LexKind::RBrace) && !self.at(LexKind::Eof) {
    if self.at(LexKind::Semicolon) {
      self.advance() |> ignore
      members.push(ClassElement::SemicolonClassElement)
      continue
    }
    let member_start = self.current().start
    let decorators = self.parse_decorators(member_start)
    let modifiers = self.parse_modifiers(member_start)
    if self.at(LexKind::Semicolon) {
      if decorators is Some(list) {
        raise self.parse_error_at(
          list.start.start,
          list.end.end,
          ParseErrorKind::DecoratorsNotAllowedHere,
        )
      }
      self.advance() |> ignore
      members.push(ClassElement::SemicolonClassElement)
      continue
    }
    if self.at(LexKind::LBrace) &&
      modifiers_has(modifiers, ModifierKind::Static) {
      if decorators is Some(list) {
        raise self.parse_error_at(
          list.start.start,
          list.end.end,
          ParseErrorKind::DecoratorsNotAllowedHere,
        )
      }
      let (body, _) = self.parse_block()
      let static_block = ClassStaticBlockDecl::new(body)
      members.push(ClassElement::ClassStaticBlockDecl(static_block))
      continue
    }
    if self.at(LexKind::LBracket) {
      if decorators is Some(list) {
        raise self.parse_error_at(
          list.start.start,
          list.end.end,
          ParseErrorKind::DecoratorsNotAllowedHere,
        )
      }
      self.advance() |> ignore
      let param_name = self.parse_identifier()
      self.expect(LexKind::Colon) |> ignore
      let key_type = self.parse_type()
      self.expect(LexKind::RBracket) |> ignore
      self.expect(LexKind::Colon) |> ignore
      let value_type = self.parse_type()
      let param_span = self.span_from(param_name.span.start, key_type.span.end)
      let param = ParameterDecl::new(
        BindingName::Identifier(param_name),
        ParameterModifiers::default(),
        false,
        false,
        Some(key_type),
        None,
        param_span,
      )
      let param_start = param.span.start
      let param_end = param.span.end
      let span = match modifiers {
        Some(m) => m.start
        None => param_span
      }
      let mod_array = match modifiers {
        Some(m) => Some(m.elements)
        None => None
      }
      let class_mods = parse_class_member_modifiers(mod_array, span)
      let is_readonly = class_mods.is_readonly
      let index_sig = IndexSignatureDecl::new(
        is_readonly,
        self.node_array([param], param_start, param_end),
        value_type,
      )
      self.try_parse_semicolon() |> ignore
      members.push(ClassElement::IndexSignature(index_sig))
      continue
    }
    let mut is_generator = false
    let is_async = modifiers_has(modifiers, ModifierKind::Async)
    if self.at(LexKind::Star) {
      self.advance() |> ignore
      is_generator = true
    }
    let prop_name = self.parse_property_name()
    let mut is_optional = false
    if self.at(LexKind::Question) {
      self.advance() |> ignore
      is_optional = true
    }
    let mut is_definite = false
    if self.at(LexKind::Bang) {
      self.advance() |> ignore
      is_definite = true
    }
    if !is_generator {
      match prop_name {
        PropertyName::Identifier(id) =>
          if id.text == "get" && !self.at(LexKind::Colon) {
            let accessor_name = self.parse_property_name()
            let params = self.parse_parameter_list(false)
            let type_node = if self.at(LexKind::Colon) {
              self.advance() |> ignore
              Some(self.parse_type())
            } else {
              None
            }
            let body = if self.at(LexKind::LBrace) {
              let (block, _) = self.parse_block_with_function_context(
                false, is_async,
              )
              Some(block)
            } else {
              self.try_parse_semicolon() |> ignore
              None
            }
            let span = match modifiers {
              Some(m) => m.start
              None => params.start
            }
            let mod_array = modifiers.map(m => m.elements)
            let class_mods = parse_class_member_modifiers(mod_array, span)
            let get_decl = GetAccessorDecl::new(
              decorators, class_mods, accessor_name, params, type_node, body,
            )
            members.push(ClassElement::GetAccessor(get_decl))
            continue
          } else if id.text == "set" && !self.at(LexKind::Colon) {
            let accessor_name = self.parse_property_name()
            let params = self.parse_parameter_list(false)
            let body = if self.at(LexKind::LBrace) {
              let (block, _) = self.parse_block_with_function_context(
                false, is_async,
              )
              Some(block)
            } else {
              self.try_parse_semicolon() |> ignore
              None
            }
            let span = match modifiers {
              Some(m) => m.start
              None => params.start
            }
            let mod_array = modifiers.map(m => m.elements)
            let class_mods = parse_class_member_modifiers(mod_array, span)
            let set_decl = SetAccessorDecl::new(
              decorators, class_mods, accessor_name, params, body,
            )
            members.push(ClassElement::SetAccessor(set_decl))
            continue
          }
        _ => ()
      }
    }
    let type_params = if self.at(LexKind::Lt) &&
      self.looks_like_type_arguments() {
      Some(self.parse_type_parameters())
    } else {
      None
    }
    if self.at(LexKind::LParen) {
      if !is_generator {
        match prop_name {
          PropertyName::Identifier(id) if id.text == "constructor" => {
            if decorators is Some(list) {
              raise self.parse_error_at(
                list.start.start,
                list.end.end,
                ParseErrorKind::DecoratorsNotAllowedHere,
              )
            }
            let params = self.parse_parameter_list(true)
            let body = if self.at(LexKind::LBrace) {
              let (block, _) = self.parse_block_with_function_context(
                false, false,
              )
              Some(block)
            } else {
              self.try_parse_semicolon() |> ignore
              None
            }
            let span = match modifiers {
              Some(m) => m.start
              None => params.start
            }
            let mod_array = modifiers.map(m => m.elements)
            let class_mods = parse_class_member_modifiers(mod_array, span)
            let ctor = ConstructorDecl::new(class_mods, params, body)
            members.push(ClassElement::Constructor(ctor))
            continue
          }
          _ => ()
        }
      }
      let params = self.parse_parameter_list(false)
      let type_node = if self.at(LexKind::Colon) {
        self.advance() |> ignore
        Some(self.parse_type())
      } else {
        None
      }
      let body = if self.at(LexKind::LBrace) {
        let (block, _) = self.parse_block_with_function_context(
          is_generator, is_async,
        )
        Some(block)
      } else {
        self.try_parse_semicolon() |> ignore
        None
      }
      let span = match modifiers {
        Some(m) => m.start
        None => params.start
      }
      let mod_array = modifiers.map(m => m.elements)
      let class_mods = parse_class_member_modifiers(mod_array, span)
      let mth = MethodDecl::new(
        decorators, class_mods, is_generator, prop_name, is_optional, type_params,
        params, type_node, body,
      )
      members.push(ClassElement::MethodDecl(mth))
      continue
    }
    let type_node = if self.at(LexKind::Colon) {
      self.advance() |> ignore
      Some(self.parse_type())
    } else {
      None
    }
    let initializer = if self.at(LexKind::Eq) {
      self.advance() |> ignore
      Some(self.parse_expr())
    } else {
      None
    }
    self.try_parse_semicolon() |> ignore
    let span = match modifiers {
      Some(m) => m.start
      None => self.span_from(self.current().start, self.current().start)
    }
    let mod_array = match modifiers {
      Some(m) => Some(m.elements)
      None => None
    }
    let class_mods = parse_class_member_modifiers(mod_array, span)
    let prop = PropertyDecl::new(
      decorators, class_mods, prop_name, is_optional, is_definite, type_node, initializer,
    )
    members.push(ClassElement::PropertyDecl(prop))
  }
  self.node_array(members, start, self.current().start)
}

///|
fn Parser::parse_class_expr(
  self : Parser,
  start : Int,
) -> Expr raise ParseError {
  let name = if self.current().kind is Identifier(_) {
    Some(self.parse_identifier())
  } else {
    None
  }
  let type_parameters = if self.at(LexKind::Lt) {
    Some(self.parse_type_parameters())
  } else {
    None
  }
  let heritage_items : Array[HeritageClause] = []
  if self.at(LexKind::KeywordExtends) {
    let extends_tok = self.advance()
    let clause = self.parse_heritage_clause(
      HeritageKind::Extends,
      extends_tok.start,
    )
    heritage_items.push(clause)
  }
  if self.at(LexKind::KeywordImplements) {
    let implements_tok = self.advance()
    let clause = self.parse_heritage_clause(
      HeritageKind::Implements,
      implements_tok.start,
    )
    heritage_items.push(clause)
  }
  let heritage = if heritage_items.length() > 0 {
    Some(self.node_array(heritage_items, start, self.current().start))
  } else {
    None
  }
  let body_start = self.expect(LexKind::LBrace).start
  let members = self.parse_class_elements(body_start)
  let end_tok = self.expect(LexKind::RBrace)
  let class_expr = ClassExpr::new(name, type_parameters, heritage, members)
  Expr::new(ExprKind::ClassExpr(class_expr), self.span_from(start, end_tok.end))
}

///|
fn Parser::parse_primary_expr(self : Parser) -> Expr raise ParseError {
  let tok = self.current()
  match tok.kind {
    Identifier(name) => {
      if name == "async" {
        if self.peek(1).kind == LexKind::LParen &&
          self.looks_like_arrow_from_paren_at(self.index + 1) {
          let start = tok.start
          self.advance() |> ignore
          let params = self.parse_parameter_list(false)
          self.expect(LexKind::Arrow) |> ignore
          let (body, end_start) = if self.at(LexKind::LBrace) {
            let (stmts, span) = self.parse_block_with_function_context(
              false, true,
            )
            (ArrowFunctionBody::Block(stmts), span.end)
          } else {
            let expr = self.parse_arrow_expr_body(true)
            (ArrowFunctionBody::Expr(expr), expr.span.end)
          }
          let arrow = ArrowFunction::new(true, None, params, None, body)
          return Expr::new(
            ExprKind::ArrowFunction(arrow),
            self.span_from(start, end_start),
          )
        }
        if self.peek(1).kind is Identifier(_) &&
          self.peek(2).kind == LexKind::Arrow {
          let start = tok.start
          self.advance() |> ignore
          let param_id = self.parse_identifier()
          let param_span = param_id.span
          let param = ParameterDecl::new(
            BindingName::Identifier(param_id),
            ParameterModifiers::default(),
            false,
            false,
            None,
            None,
            param_span,
          )
          let params = self.node_array(
            [param],
            param_span.start,
            param_span.end,
          )
          self.expect(LexKind::Arrow) |> ignore
          let (body, end_start) = if self.at(LexKind::LBrace) {
            let (stmts, span) = self.parse_block_with_function_context(
              false, true,
            )
            (ArrowFunctionBody::Block(stmts), span.end)
          } else {
            let expr = self.parse_arrow_expr_body(true)
            (ArrowFunctionBody::Expr(expr), expr.span.end)
          }
          let arrow = ArrowFunction::new(true, None, params, None, body)
          return Expr::new(
            ExprKind::ArrowFunction(arrow),
            self.span_from(start, end_start),
          )
        }
      }
      if self.peek(1).kind == LexKind::Arrow {
        let param = ParameterDecl::new(
          BindingName::Identifier(
            Identifier::new(name, self.span_from(tok.start, tok.end)),
          ),
          ParameterModifiers::default(),
          false,
          false,
          None,
          None,
          self.span_from(tok.start, tok.end),
        )
        let params = self.node_array([param], tok.start, tok.end)
        self.advance() |> ignore
        self.expect(LexKind::Arrow) |> ignore
        let (body, end_start) = if self.at(LexKind::LBrace) {
          let (stmts, span) = self.parse_block_with_function_context(
            false, false,
          )
          (ArrowFunctionBody::Block(stmts), span.end)
        } else {
          let expr = self.parse_arrow_expr_body(false)
          (ArrowFunctionBody::Expr(expr), expr.span.end)
        }
        let arrow = ArrowFunction::new(false, None, params, None, body)
        return Expr::new(
          ExprKind::ArrowFunction(arrow),
          self.span_from(tok.start, end_start),
        )
      }
      self.advance() |> ignore
      let id = Identifier::new(name, self.span_from(tok.start, tok.end))
      Expr::new(ExprKind::Identifier(id), self.span_from(tok.start, tok.end))
    }
    KeywordType | KeywordAs | KeywordFrom | KeywordOf | KeywordUsing => {
      let id = self.parse_identifier()
      Expr::new(ExprKind::Identifier(id), id.span)
    }
    Number(value) => {
      self.advance() |> ignore
      let lit = NumericLiteral::new(value, self.span_from(tok.start, tok.end))
      Expr::new(
        ExprKind::NumericLiteral(lit),
        self.span_from(tok.start, tok.end),
      )
    }
    Regex(value) => {
      self.advance() |> ignore
      let lit = RegularExprLiteral::new(
        value,
        self.span_from(tok.start, tok.end),
      )
      Expr::new(
        ExprKind::RegularExprLiteral(lit),
        self.span_from(tok.start, tok.end),
      )
    }
    NoSubTemplate(text, raw) => {
      self.advance() |> ignore
      let lit = NoSubstitutionTemplateLiteral::new(text, raw)
      Expr::new(
        ExprKind::NoSubstitutionTemplateLiteral(lit),
        self.span_from(tok.start, tok.end),
      )
    }
    TemplateHead(text, raw) => {
      self.advance() |> ignore
      self.parse_template_expr(text, raw, tok.start)
    }
    String(value) => {
      self.advance() |> ignore
      let lit = StringLiteral::new(value, self.span_from(tok.start, tok.end))
      Expr::new(
        ExprKind::StringLiteral(lit),
        self.span_from(tok.start, tok.end),
      )
    }
    LParen =>
      if self.looks_like_arrow_from_paren() {
        let start = self.current().start
        let params = self.parse_parameter_list(false)
        self.expect(LexKind::Arrow) |> ignore
        let (body, end_start) = if self.at(LexKind::LBrace) {
          let (stmts, span) = self.parse_block_with_function_context(
            false, false,
          )
          (ArrowFunctionBody::Block(stmts), span.end)
        } else {
          let expr = self.parse_arrow_expr_body(false)
          (ArrowFunctionBody::Expr(expr), expr.span.end)
        }
        let arrow = ArrowFunction::new(false, None, params, None, body)
        Expr::new(
          ExprKind::ArrowFunction(arrow),
          self.span_from(start, end_start),
        )
      } else {
        let start = self.advance().start
        let inner = self.parse_expr()
        let end_tok = self.expect(LexKind::RParen)
        let span = self.span_from(start, end_tok.end)
        Expr::new(ExprKind::ParenthesizedExpr(inner), span)
      }
    LBracket => {
      let start = self.advance().start
      self.parse_array_literal(start)
    }
    LBrace => {
      let start = self.advance().start
      self.parse_object_literal(start)
    }
    KeywordFunction => {
      let start = self.advance().start
      self.parse_function_expr(start)
    }
    KeywordClass => {
      let start = self.advance().start
      self.parse_class_expr(start)
    }
    KeywordNew => {
      if self.peek(1).kind == LexKind::Dot &&
        self.peek(2).kind is Identifier("target") {
        let start = tok.start
        self.advance() |> ignore
        self.advance() |> ignore
        let target_tok = self.advance()
        return Expr::new(
          ExprKind::MetaProperty(MetaPropertyKind::NewTarget),
          self.span_from(start, target_tok.end),
        )
      }
      let start = self.advance().start
      self.parse_new_expr(start)
    }
    KeywordThis => {
      self.advance() |> ignore
      Expr::new(ExprKind::ThisExpr, self.span_from(tok.start, tok.end))
    }
    KeywordSuper => {
      self.advance() |> ignore
      Expr::new(ExprKind::SuperExpr, self.span_from(tok.start, tok.end))
    }
    KeywordTrue => {
      self.advance() |> ignore
      Expr::new(ExprKind::TrueLiteral, self.span_from(tok.start, tok.end))
    }
    KeywordFalse => {
      self.advance() |> ignore
      Expr::new(ExprKind::FalseLiteral, self.span_from(tok.start, tok.end))
    }
    KeywordNull => {
      self.advance() |> ignore
      Expr::new(ExprKind::NullLiteral, self.span_from(tok.start, tok.end))
    }
    KeywordImport => {
      if self.peek(1).kind == LexKind::Dot &&
        self.peek(2).kind is Identifier("meta") {
        let start = tok.start
        self.advance() |> ignore
        self.advance() |> ignore
        let meta_tok = self.advance()
        return Expr::new(
          ExprKind::MetaProperty(MetaPropertyKind::ImportMeta),
          self.span_from(start, meta_tok.end),
        )
      }
      if self.peek(1).kind == LexKind::LParen {
        let start = tok.start
        self.advance() |> ignore
        let open = self.expect(LexKind::LParen)
        let args : Array[Expr] = []
        if !self.at(LexKind::RParen) {
          for {
            args.push(self.parse_assignment_expr())
            if self.at(LexKind::Comma) {
              self.advance() |> ignore
              continue
            }
            break
          }
        }
        let end_tok = self.expect(LexKind::RParen)
        return Expr::new(
          ExprKind::ImportExpr(self.node_array(args, open.start, end_tok.end)),
          self.span_from(start, end_tok.end),
        )
      }
      raise self.parse_error_at(
        tok.start,
        tok.end,
        ParseErrorKind::UnexpectedPrimary(tok.kind),
      )
    }
    _ =>
      raise self.parse_error_at(
        tok.start,
        tok.end,
        ParseErrorKind::UnexpectedPrimary(tok.kind),
      )
  }
}

///|
fn Parser::parse_starttfix_expr(self : Parser) -> Expr raise ParseError {
  let mut expr = self.parse_primary_expr()
  for {
    let tok = self.current()
    match tok.kind {
      Lt => {
        if self.looks_like_type_arguments() {
          let call_type_args = Some(self.parse_type_arguments())
          if self.at(LexKind::LParen) {
            let start = self.current().start
            self.advance() |> ignore
            let args : Array[Expr] = []
            if !self.at(LexKind::RParen) {
              for {
                if self.at(LexKind::DotDotDot) {
                  let spread_tok = self.advance()
                  let arg = self.parse_assignment_expr()
                  let span = self.span_from(spread_tok.start, arg.span.end)
                  args.push(Expr::new(ExprKind::SpreadElement(arg), span))
                } else {
                  args.push(self.parse_assignment_expr())
                }
                if self.at(LexKind::Comma) {
                  self.advance() |> ignore
                  continue
                }
                break
              }
            }
            let end_tok = self.expect(LexKind::RParen)
            let call = CallExpr::new(
              expr,
              call_type_args,
              self.node_array(args, start, end_tok.end),
              false,
            )
            let span = self.span_from(expr.span.start, end_tok.end)
            expr = Expr::new(ExprKind::CallExpr(call), span)
            continue
          }
          break
        }
        break
      }
      QuestionDot => {
        self.advance() |> ignore
        let call_type_args = if self.at(LexKind::Lt) &&
          self.looks_like_type_arguments() {
          Some(self.parse_type_arguments())
        } else {
          None
        }
        if self.at(LexKind::LParen) {
          let call_start = self.current().start
          self.advance() |> ignore
          let args : Array[Expr] = []
          if !self.at(LexKind::RParen) {
            for {
              if self.at(LexKind::DotDotDot) {
                let spread_tok = self.advance()
                let arg = self.parse_assignment_expr()
                let span = self.span_from(spread_tok.start, arg.span.end)
                args.push(Expr::new(ExprKind::SpreadElement(arg), span))
              } else {
                args.push(self.parse_assignment_expr())
              }
              if self.at(LexKind::Comma) {
                self.advance() |> ignore
                continue
              }
              break
            }
          }
          let end_tok = self.expect(LexKind::RParen)
          let call = CallExpr::new(
            expr,
            call_type_args,
            self.node_array(args, call_start, end_tok.end),
            true,
          )
          let span = self.span_from(expr.span.start, end_tok.end)
          expr = Expr::new(ExprKind::CallExpr(call), span)
          continue
        }
        if self.at(LexKind::LBracket) {
          self.advance() |> ignore
          let arg = self.parse_expr()
          let end_tok = self.expect(LexKind::RBracket)
          let access = ElementAccessExpr::new(expr, arg, true)
          let span = self.span_from(expr.span.start, end_tok.end)
          expr = Expr::new(ExprKind::ElementAccessExpr(access), span)
          continue
        }
        let name = self.parse_identifier()
        let span = self.span_from(expr.span.start, name.span.end)
        let access = PropertyAccessExpr::new(expr, name, true)
        expr = Expr::new(ExprKind::PropertyAccessExpr(access), span)
      }
      Dot => {
        self.advance() |> ignore
        let name = self.parse_identifier()
        let span = self.span_from(expr.span.start, name.span.end)
        let access = PropertyAccessExpr::new(expr, name, false)
        expr = Expr::new(ExprKind::PropertyAccessExpr(access), span)
      }
      LParen => {
        let start = tok.start
        self.advance() |> ignore
        let args : Array[Expr] = []
        if !self.at(LexKind::RParen) {
          for {
            if self.at(LexKind::DotDotDot) {
              let spread_tok = self.advance()
              let arg = self.parse_assignment_expr()
              let span = self.span_from(spread_tok.start, arg.span.end)
              args.push(Expr::new(ExprKind::SpreadElement(arg), span))
            } else {
              args.push(self.parse_assignment_expr())
            }
            if self.at(LexKind::Comma) {
              self.advance() |> ignore
              continue
            }
            break
          }
        }
        let end_tok = self.expect(LexKind::RParen)
        let call = CallExpr::new(
          expr,
          None,
          self.node_array(args, start, end_tok.end),
          false,
        )
        let span = self.span_from(expr.span.start, end_tok.end)
        expr = Expr::new(ExprKind::CallExpr(call), span)
      }
      LBracket => {
        self.advance() |> ignore
        let arg = self.parse_expr()
        let end_tok = self.expect(LexKind::RBracket)
        let access = ElementAccessExpr::new(expr, arg, false)
        let span = self.span_from(expr.span.start, end_tok.end)
        expr = Expr::new(ExprKind::ElementAccessExpr(access), span)
      }
      NoSubTemplate(text, raw) => {
        self.advance() |> ignore
        let lit = NoSubstitutionTemplateLiteral::new(text, raw)
        let template_span = self.span_from(tok.start, tok.end)
        let template = Expr::new(
          ExprKind::NoSubstitutionTemplateLiteral(lit),
          template_span,
        )
        let span = self.span_from(expr.span.start, tok.end)
        let tagged = TaggedTemplateExpr::new(expr, None, template)
        expr = Expr::new(ExprKind::TaggedTemplateExpr(tagged), span)
      }
      TemplateHead(text, raw) => {
        self.advance() |> ignore
        let template = self.parse_template_expr(text, raw, tok.start)
        let span = self.span_from(expr.span.start, template.span.end)
        let tagged = TaggedTemplateExpr::new(expr, None, template)
        expr = Expr::new(ExprKind::TaggedTemplateExpr(tagged), span)
      }
      PlusPlus => {
        let op = self.advance()
        let span = self.span_from(expr.span.start, op.end)
        let postfix = PostfixUnaryExpr::new(expr, UnaryOperator::PlusPlus)
        expr = Expr::new(ExprKind::PostfixUnaryExpr(postfix), span)
      }
      MinusMinus => {
        let op = self.advance()
        let span = self.span_from(expr.span.start, op.end)
        let postfix = PostfixUnaryExpr::new(expr, UnaryOperator::MinusMinus)
        expr = Expr::new(ExprKind::PostfixUnaryExpr(postfix), span)
      }
      Bang => {
        let op = self.advance()
        let span = self.span_from(expr.span.start, op.end)
        expr = Expr::new(ExprKind::NonNullExpr(expr), span)
      }
      _ => break
    }
  }
  expr
}

///|
fn Parser::parse_unary_expr(self : Parser) -> Expr raise ParseError {
  let tok = self.current()
  match tok.kind {
    Lt => {
      let start = self.advance().start
      let type_node = self.parse_type()
      self.expect_gt() |> ignore
      let operand = self.parse_unary_expr()
      let span = self.span_from(start, operand.span.end)
      let assertion = TypeAssertionExpr::new(type_node, operand)
      Expr::new(ExprKind::TypeAssertionExpr(assertion), span)
    }
    KeywordDelete => {
      let start = tok.start
      self.advance() |> ignore
      let operand = self.parse_unary_expr()
      let span = self.span_from(start, operand.span.end)
      Expr::new(ExprKind::DeleteExpr(operand), span)
    }
    KeywordTypeof => {
      let start = tok.start
      self.advance() |> ignore
      let operand = self.parse_unary_expr()
      let span = self.span_from(start, operand.span.end)
      Expr::new(ExprKind::TypeOfExpr(operand), span)
    }
    KeywordVoid => {
      let start = tok.start
      self.advance() |> ignore
      let operand = self.parse_unary_expr()
      let span = self.span_from(start, operand.span.end)
      Expr::new(ExprKind::VoidExpr(operand), span)
    }
    KeywordAwait => {
      let start = tok.start
      if self.in_function > 0 && self.in_async_function == 0 {
        raise self.parse_error_at(
          tok.start,
          tok.end,
          ParseErrorKind::AwaitOnlyInAsyncFunction,
        )
      }
      self.advance() |> ignore
      let operand = self.parse_unary_expr()
      let span = self.span_from(start, operand.span.end)
      self.record_top_level_await(span)
      Expr::new(ExprKind::AwaitExpr(operand), span)
    }
    PlusPlus => {
      let start = tok.start
      self.advance() |> ignore |> ignore
      let operand = self.parse_unary_expr()
      let span = self.span_from(start, operand.span.end)
      let unary = PrefixUnaryExpr::new(UnaryOperator::PlusPlus, operand)
      Expr::new(ExprKind::PrefixUnaryExpr(unary), span)
    }
    MinusMinus => {
      let start = tok.start
      self.advance() |> ignore |> ignore
      let operand = self.parse_unary_expr()
      let span = self.span_from(start, operand.span.end)
      let unary = PrefixUnaryExpr::new(UnaryOperator::MinusMinus, operand)
      Expr::new(ExprKind::PrefixUnaryExpr(unary), span)
    }
    Plus => {
      let start = tok.start
      self.advance() |> ignore |> ignore
      let operand = self.parse_unary_expr()
      let span = self.span_from(start, operand.span.end)
      let unary = PrefixUnaryExpr::new(UnaryOperator::Plus, operand)
      Expr::new(ExprKind::PrefixUnaryExpr(unary), span)
    }
    Minus => {
      let start = tok.start
      self.advance() |> ignore |> ignore
      let operand = self.parse_unary_expr()
      let span = self.span_from(start, operand.span.end)
      let unary = PrefixUnaryExpr::new(UnaryOperator::Minus, operand)
      Expr::new(ExprKind::PrefixUnaryExpr(unary), span)
    }
    Bang => {
      let start = tok.start
      self.advance() |> ignore |> ignore
      let operand = self.parse_unary_expr()
      let span = self.span_from(start, operand.span.end)
      let unary = PrefixUnaryExpr::new(UnaryOperator::Exclamation, operand)
      Expr::new(ExprKind::PrefixUnaryExpr(unary), span)
    }
    Tilde => {
      let start = tok.start
      self.advance() |> ignore |> ignore
      let operand = self.parse_unary_expr()
      let span = self.span_from(start, operand.span.end)
      let unary = PrefixUnaryExpr::new(UnaryOperator::Tilde, operand)
      Expr::new(ExprKind::PrefixUnaryExpr(unary), span)
    }
    _ => self.parse_starttfix_expr()
  }
}

///|
fn binary_precedence(kind : LexKind) -> Int {
  match kind {
    StarStar => 11
    Star => 10
    Slash => 10
    Percent => 10
    Plus => 9
    Minus => 9
    LtLt => 8
    GtGt => 8
    GtGtGt => 8
    Lt => 7
    LtEq => 7
    Gt => 7
    GtEq => 7
    KeywordIn => 7
    KeywordInstanceof => 7
    EqEq => 6
    EqEqEq => 6
    BangEq => 6
    BangEqEq => 6
    Ampersand => 5
    Caret => 4
    Bar => 3
    AmpAmp => 2
    BarBar => 1
    QuestionQuestion => 1
    _ => 0
  }
}

///|
fn binary_precedence_no_in(kind : LexKind) -> Int {
  if kind == LexKind::KeywordIn {
    return 0
  }
  binary_precedence(kind)
}

///|
fn binary_operator(kind : LexKind) -> BinaryOperator? {
  match kind {
    StarStar => Some(BinaryOperator::AsteriskAsterisk)
    Star => Some(BinaryOperator::Asterisk)
    Slash => Some(BinaryOperator::Slash)
    Percent => Some(BinaryOperator::Percent)
    Plus => Some(BinaryOperator::Plus)
    Minus => Some(BinaryOperator::Minus)
    LtLt => Some(BinaryOperator::ShiftLeft)
    GtGt => Some(BinaryOperator::ShiftRight)
    GtGtGt => Some(BinaryOperator::ShiftRightUnsigned)
    Lt => Some(BinaryOperator::LessThan)
    LtEq => Some(BinaryOperator::LessThanEquals)
    Gt => Some(BinaryOperator::GreaterThan)
    GtEq => Some(BinaryOperator::GreaterThanEquals)
    KeywordIn => Some(BinaryOperator::In)
    KeywordInstanceof => Some(BinaryOperator::InstanceOf)
    EqEq => Some(BinaryOperator::EqualsEquals)
    EqEqEq => Some(BinaryOperator::EqualsEqualsEquals)
    BangEq => Some(BinaryOperator::ExclamationEquals)
    BangEqEq => Some(BinaryOperator::ExclamationEqualsEquals)
    Ampersand => Some(BinaryOperator::BitwiseAnd)
    Caret => Some(BinaryOperator::BitwiseXor)
    Bar => Some(BinaryOperator::BitwiseOr)
    AmpAmp => Some(BinaryOperator::AmpersandAmpersand)
    BarBar => Some(BinaryOperator::BarBar)
    QuestionQuestion => Some(BinaryOperator::QuestionQuestion)
    _ => None
  }
}

///|
fn assignment_operator(kind : LexKind) -> BinaryOperator? {
  match kind {
    Eq => Some(BinaryOperator::Equals)
    PlusEq => Some(BinaryOperator::PlusEquals)
    MinusEq => Some(BinaryOperator::MinusEquals)
    StarEq => Some(BinaryOperator::AsteriskEquals)
    StarStarEq => Some(BinaryOperator::AsteriskAsteriskEquals)
    SlashEq => Some(BinaryOperator::SlashEquals)
    PercentEq => Some(BinaryOperator::PercentEquals)
    AmpersandEq => Some(BinaryOperator::AmpersandEquals)
    BarEq => Some(BinaryOperator::BarEquals)
    CaretEq => Some(BinaryOperator::CaretEquals)
    LtLtEq => Some(BinaryOperator::ShiftLeftEquals)
    GtGtEq => Some(BinaryOperator::ShiftRightEquals)
    GtGtGtEq => Some(BinaryOperator::ShiftRightUnsignedEquals)
    AmpAmpEq => Some(BinaryOperator::AmpersandAmpersandEquals)
    BarBarEq => Some(BinaryOperator::BarBarEquals)
    QuestionQuestionEq => Some(BinaryOperator::QuestionQuestionEquals)
    _ => None
  }
}

///|
fn Parser::parse_binary_expr(
  self : Parser,
  min_prec : Int,
) -> Expr raise ParseError {
  let mut left = self.parse_unary_expr()
  for {
    let tok = self.current()
    let prec = binary_precedence(tok.kind)
    if prec < min_prec || prec == 0 {
      break
    }
    self.advance() |> ignore
    let next_prec = if tok.kind == LexKind::StarStar { prec } else { prec + 1 }
    let right = self.parse_binary_expr(next_prec)
    let span = self.span_from(left.span.start, right.span.end)
    let op = match binary_operator(tok.kind) {
      Some(op) => op
      None =>
        raise self.parse_error_at(
          tok.start,
          tok.end,
          ParseErrorKind::InvalidBinaryOperator(tok.kind),
        )
    }
    let bin = BinaryExpr::new(left, op, right)
    left = Expr::new(ExprKind::BinaryExpr(bin), span)
  }
  left
}

///|
fn Parser::parse_binary_expr_no_in(
  self : Parser,
  min_prec : Int,
) -> Expr raise ParseError {
  let mut left = self.parse_unary_expr()
  for {
    let tok = self.current()
    let prec = binary_precedence_no_in(tok.kind)
    if prec < min_prec || prec == 0 {
      break
    }
    self.advance() |> ignore
    let next_prec = if tok.kind == LexKind::StarStar { prec } else { prec + 1 }
    let right = self.parse_binary_expr_no_in(next_prec)
    let span = self.span_from(left.span.start, right.span.end)
    let op = match binary_operator(tok.kind) {
      Some(op) => op
      None =>
        raise self.parse_error_at(
          tok.start,
          tok.end,
          ParseErrorKind::InvalidBinaryOperator(tok.kind),
        )
    }
    let bin = BinaryExpr::new(left, op, right)
    left = Expr::new(ExprKind::BinaryExpr(bin), span)
  }
  left
}

///|
fn Parser::parse_conditional_expr(self : Parser) -> Expr raise ParseError {
  let condition = self.parse_binary_expr(1)
  if self.at(LexKind::Question) {
    let start = condition.span.start
    self.advance() |> ignore
    let when_true = self.parse_expr()
    self.expect(LexKind::Colon) |> ignore
    let when_false = self.parse_expr()
    let span = self.span_from(start, when_false.span.end)
    let cond = ConditionalExpr::new(condition, when_true, when_false)
    return Expr::new(ExprKind::ConditionalExpr(cond), span)
  }
  condition
}

///|
fn Parser::parse_conditional_expr_no_in(self : Parser) -> Expr raise ParseError {
  let condition = self.parse_binary_expr_no_in(1)
  if self.at(LexKind::Question) {
    let start = condition.span.start
    self.advance() |> ignore
    let when_true = self.parse_expr_no_in()
    self.expect(LexKind::Colon) |> ignore
    let when_false = self.parse_expr_no_in()
    let span = self.span_from(start, when_false.span.end)
    let cond = ConditionalExpr::new(condition, when_true, when_false)
    return Expr::new(ExprKind::ConditionalExpr(cond), span)
  }
  condition
}

///|
fn Parser::parse_as_expr(self : Parser) -> Expr raise ParseError {
  let mut expr = self.parse_conditional_expr()
  while self.at(LexKind::KeywordAs) || self.at(LexKind::KeywordSatisfies) {
    let start = expr.span.start
    let is_satisfies = self.at(LexKind::KeywordSatisfies)
    self.advance() |> ignore
    let type_node = self.parse_type()
    let span = self.span_from(start, type_node.span.end)
    if is_satisfies {
      expr = Expr::new(
        ExprKind::SatisfiesExpr(SatisfiesExpr::new(expr, type_node)),
        span,
      )
    } else {
      expr = Expr::new(ExprKind::AsExpr(AsExpr::new(expr, type_node)), span)
    }
  }
  if self.at(LexKind::Question) {
    let start = expr.span.start
    self.advance() |> ignore
    let when_true = self.parse_expr()
    self.expect(LexKind::Colon) |> ignore
    let when_false = self.parse_expr()
    let span = self.span_from(start, when_false.span.end)
    let cond = ConditionalExpr::new(expr, when_true, when_false)
    return Expr::new(ExprKind::ConditionalExpr(cond), span)
  }
  expr
}

///|
fn Parser::parse_as_expr_no_in(self : Parser) -> Expr raise ParseError {
  let mut expr = self.parse_conditional_expr_no_in()
  while self.at(LexKind::KeywordAs) || self.at(LexKind::KeywordSatisfies) {
    let start = expr.span.start
    let is_satisfies = self.at(LexKind::KeywordSatisfies)
    self.advance() |> ignore
    let type_node = self.parse_type()
    let span = self.span_from(start, type_node.span.end)
    if is_satisfies {
      expr = Expr::new(
        ExprKind::SatisfiesExpr(SatisfiesExpr::new(expr, type_node)),
        span,
      )
    } else {
      expr = Expr::new(ExprKind::AsExpr(AsExpr::new(expr, type_node)), span)
    }
  }
  if self.at(LexKind::Question) {
    let start = expr.span.start
    self.advance() |> ignore
    let when_true = self.parse_expr_no_in()
    self.expect(LexKind::Colon) |> ignore
    let when_false = self.parse_expr_no_in()
    let span = self.span_from(start, when_false.span.end)
    let cond = ConditionalExpr::new(expr, when_true, when_false)
    return Expr::new(ExprKind::ConditionalExpr(cond), span)
  }
  expr
}

///|
fn Parser::parse_assignment_expr(self : Parser) -> Expr raise ParseError {
  if self.at(LexKind::KeywordYield) {
    if self.in_generator == 0 {
      let tok = self.current()
      raise self.parse_error_at(
        tok.start,
        tok.end,
        ParseErrorKind::YieldOnlyInGenerator,
      )
    }
    let start = self.advance().start
    let is_delegate = if self.at(LexKind::Star) {
      self.advance() |> ignore
      true
    } else {
      false
    }
    let expr = if !self.can_parse_semicolon() {
      Some(self.parse_assignment_expr())
    } else {
      None
    }
    let end = if expr is Some(value) {
      value.span.end
    } else {
      self.current().start
    }
    let yield_expr = YieldExpr::new(is_delegate, expr)
    return Expr::new(
      ExprKind::YieldExpr(yield_expr),
      self.span_from(start, end),
    )
  }
  let left = self.parse_as_expr()
  match assignment_operator(self.current().kind) {
    Some(op) => {
      let start = left.span.start
      self.advance() |> ignore
      let right = self.parse_assignment_expr()
      let span = self.span_from(start, right.span.end)
      let bin = BinaryExpr::new(left, op, right)
      Expr::new(ExprKind::BinaryExpr(bin), span)
    }
    None => left
  }
}

///|
fn Parser::parse_assignment_expr_no_in(self : Parser) -> Expr raise ParseError {
  if self.at(LexKind::KeywordYield) {
    if self.in_generator == 0 {
      let tok = self.current()
      raise self.parse_error_at(
        tok.start,
        tok.end,
        ParseErrorKind::YieldOnlyInGenerator,
      )
    }
    let start = self.advance().start
    let is_delegate = if self.at(LexKind::Star) {
      self.advance() |> ignore
      true
    } else {
      false
    }
    let expr = if !self.can_parse_semicolon() {
      Some(self.parse_assignment_expr_no_in())
    } else {
      None
    }
    let end = if expr is Some(value) {
      value.span.end
    } else {
      self.current().start
    }
    let yield_expr = YieldExpr::new(is_delegate, expr)
    return Expr::new(
      ExprKind::YieldExpr(yield_expr),
      self.span_from(start, end),
    )
  }
  let left = self.parse_as_expr_no_in()
  match assignment_operator(self.current().kind) {
    Some(op) => {
      let start = left.span.start
      self.advance() |> ignore
      let right = self.parse_assignment_expr_no_in()
      let span = self.span_from(start, right.span.end)
      let bin = BinaryExpr::new(left, op, right)
      Expr::new(ExprKind::BinaryExpr(bin), span)
    }
    None => left
  }
}

///|
fn Parser::parse_expr(self : Parser) -> Expr raise ParseError {
  let first = self.parse_assignment_expr()
  if !self.at(LexKind::Comma) {
    return first
  }
  let expressions : Array[Expr] = [first]
  let mut end_start = first.span.end
  while self.at(LexKind::Comma) {
    self.advance() |> ignore
    let expr = self.parse_assignment_expr()
    end_start = expr.span.end
    expressions.push(expr)
  }
  let span = self.span_from(first.span.start, end_start)
  Expr::new(
    ExprKind::CommaListExpr(
      self.node_array(expressions, first.span.start, end_start),
    ),
    span,
  )
}

///|
fn Parser::parse_expr_no_in(self : Parser) -> Expr raise ParseError {
  let first = self.parse_assignment_expr_no_in()
  if !self.at(LexKind::Comma) {
    return first
  }
  let expressions : Array[Expr] = [first]
  let mut end_start = first.span.end
  while self.at(LexKind::Comma) {
    self.advance() |> ignore
    let expr = self.parse_assignment_expr_no_in()
    end_start = expr.span.end
    expressions.push(expr)
  }
  let span = self.span_from(first.span.start, end_start)
  Expr::new(
    ExprKind::CommaListExpr(
      self.node_array(expressions, first.span.start, end_start),
    ),
    span,
  )
}

///|
fn Parser::parse_variable_decl_list(
  self : Parser,
  start : Int,
  kind : VariableDeclKind,
) -> NodeArray[VariableDecl] raise ParseError {
  let decls : Array[VariableDecl] = []
  for {
    let (binding, _) = self.parse_binding_name()
    let type_node = if self.at(LexKind::Colon) {
      self.advance() |> ignore
      Some(self.parse_type())
    } else {
      None
    }
    let initializer = if self.at(LexKind::Eq) {
      self.advance() |> ignore
      Some(self.parse_assignment_expr())
    } else {
      None
    }
    let decl = VariableDecl::new(kind, binding, type_node, initializer)
    decls.push(decl)
    if self.at(LexKind::Comma) {
      self.advance() |> ignore
      continue
    }
    break
  }
  self.node_array(decls, start, self.current().start)
}

///|
fn variable_decl_kind_from_token(kind : LexKind) -> VariableDeclKind {
  match kind {
    KeywordLet => VariableDeclKind::Let
    KeywordConst => VariableDeclKind::Const
    _ => VariableDeclKind::Var
  }
}

///|
fn Parser::parse_using_decl_list(
  self : Parser,
  start : Int,
) -> NodeArray[UsingDecl] raise ParseError {
  let decls : Array[UsingDecl] = []
  for {
    let name = self.parse_identifier()
    let type_node = if self.at(LexKind::Colon) {
      self.advance() |> ignore
      Some(self.parse_type())
    } else {
      None
    }
    self.expect(LexKind::Eq) |> ignore
    let initializer = self.parse_assignment_expr()
    let decl = UsingDecl::new(name, type_node, Some(initializer))
    decls.push(decl)
    if self.at(LexKind::Comma) {
      self.advance() |> ignore
      continue
    }
    break
  }
  self.node_array(decls, start, self.current().start)
}

///|
fn Parser::parse_variable_stmt_with_modifiers(
  self : Parser,
  start : Int,
  modifiers : NodeArray[ModifierKind]?,
) -> Stmt raise ParseError {
  let decl_kind = variable_decl_kind_from_token(self.current().kind)
  self.advance() |> ignore
  let list = self.parse_variable_decl_list(start, decl_kind)
  self.parse_semicolon()
  let stmt = VariableStmt::new(modifiers, list)
  let span = self.span_from(start, self.current().start)
  Stmt::new(StmtKind::VariableStmt(stmt), span)
}

///|
fn Parser::parse_using_stmt_with_modifiers(
  self : Parser,
  start : Int,
  modifiers : NodeArray[ModifierKind]?,
  is_await : Bool,
) -> Stmt raise ParseError {
  if is_await {
    self.advance() |> ignore
    self.expect(LexKind::KeywordUsing) |> ignore
    if self.in_function > 0 && self.in_async_function == 0 {
      raise self.parse_error_at(
        start,
        self.current().end,
        ParseErrorKind::AwaitUsingOnlyInAsyncFunction,
      )
    }
  } else {
    self.advance() |> ignore
  }
  let list = self.parse_using_decl_list(start)
  self.parse_semicolon()
  let stmt = UsingStmt::new(modifiers, list, is_await)
  let span = self.span_from(start, self.current().start)
  if is_await {
    self.record_top_level_await_using(span)
  }
  Stmt::new(StmtKind::UsingStmt(stmt), span)
}

///|
fn Parser::parse_variable_stmt(self : Parser) -> Stmt raise ParseError {
  let start = self.current().start
  self.parse_variable_stmt_with_modifiers(start, None)
}

///|
fn Parser::parse_block(self : Parser) -> (Array[Stmt], Span) raise ParseError {
  let start = self.expect(LexKind::LBrace).start
  let stmts : Array[Stmt] = []
  while !self.at(LexKind::RBrace) && !self.at(LexKind::Eof) {
    stmts.push(self.parse_stmt())
  }
  let end_tok = self.expect(LexKind::RBrace)
  (stmts, self.span_from(start, end_tok.end))
}

///|

///|
fn Parser::parse_block_with_function_context(
  self : Parser,
  is_generator : Bool,
  is_async : Bool,
) -> (Array[Stmt], Span) raise ParseError {
  let prev_generator = self.in_generator
  let prev_function = self.in_function
  let prev_async_function = self.in_async_function
  self.in_generator = if is_generator { 1 } else { 0 }
  self.in_function = prev_function + 1
  self.in_async_function = if is_async { prev_async_function + 1 } else { 0 }
  let result = self.parse_block()
  self.in_generator = prev_generator
  self.in_function = prev_function
  self.in_async_function = prev_async_function
  result
}

///|
fn Parser::parse_arrow_expr_body(
  self : Parser,
  is_async : Bool,
) -> Expr raise ParseError {
  let prev_generator = self.in_generator
  let prev_function = self.in_function
  let prev_async_function = self.in_async_function
  self.in_generator = 0
  self.in_function = prev_function + 1
  self.in_async_function = if is_async { prev_async_function + 1 } else { 0 }
  let expr = self.parse_assignment_expr()
  self.in_generator = prev_generator
  self.in_function = prev_function
  self.in_async_function = prev_async_function
  expr
}

///|
fn Parser::parse_if_stmt(self : Parser) -> Stmt raise ParseError {
  let start = self.advance().start
  self.expect(LexKind::LParen) |> ignore
  let condition = self.parse_expr()
  self.expect(LexKind::RParen) |> ignore
  let then_stmt = self.parse_stmt()
  let else_stmt = if self.at(LexKind::KeywordElse) {
    self.advance() |> ignore
    Some(self.parse_stmt())
  } else {
    None
  }
  let end = match else_stmt {
    Some(stmt) => stmt.span.end
    None => then_stmt.span.end
  }
  let stmt = IfStmt::new(condition, then_stmt, else_stmt)
  Stmt::new(StmtKind::IfStmt(stmt), self.span_from(start, end))
}

///|
fn Parser::parse_return_stmt(self : Parser) -> Stmt raise ParseError {
  let start = self.advance().start
  let expr = if self.can_parse_semicolon() {
    None
  } else {
    Some(self.parse_expr())
  }
  self.parse_semicolon()
  let end = if expr is Some(e) { e.span.end } else { self.current().start }
  Stmt::new(StmtKind::ReturnStmt(expr), self.span_from(start, end))
}

///|
fn Parser::parse_break_stmt(self : Parser) -> Stmt raise ParseError {
  let start = self.advance().start
  let label = if self.can_parse_semicolon() {
    None
  } else {
    Some(self.parse_identifier())
  }
  self.parse_semicolon()
  Stmt::new(
    StmtKind::BreakStmt(label),
    self.span_from(start, self.current().start),
  )
}

///|
fn Parser::parse_continue_stmt(self : Parser) -> Stmt raise ParseError {
  let start = self.advance().start
  let label = if self.can_parse_semicolon() {
    None
  } else {
    Some(self.parse_identifier())
  }
  self.parse_semicolon()
  Stmt::new(
    StmtKind::ContinueStmt(label),
    self.span_from(start, self.current().start),
  )
}

///|
fn Parser::parse_throw_stmt(self : Parser) -> Stmt raise ParseError {
  let start = self.advance().start
  if self.has_preceding_line_break() {
    let tok = self.current()
    raise self.parse_error_at(
      tok.start,
      tok.end,
      ParseErrorKind::LineBreakAfterThrow,
    )
  }
  let expr = self.parse_expr()
  self.parse_semicolon()
  Stmt::new(StmtKind::ThrowStmt(expr), self.span_from(start, expr.span.end))
}

///|
fn Parser::parse_while_stmt(self : Parser) -> Stmt raise ParseError {
  let start = self.advance().start
  self.expect(LexKind::LParen) |> ignore
  let condition = self.parse_expr()
  self.expect(LexKind::RParen) |> ignore
  let body = self.parse_stmt()
  let stmt = WhileStmt::new(condition, body)
  Stmt::new(StmtKind::WhileStmt(stmt), self.span_from(start, body.span.end))
}

///|
fn Parser::parse_do_stmt(self : Parser) -> Stmt raise ParseError {
  let start = self.advance().start
  let body = self.parse_stmt()
  self.expect(LexKind::KeywordWhile) |> ignore
  self.expect(LexKind::LParen) |> ignore
  let condition = self.parse_expr()
  self.expect(LexKind::RParen) |> ignore
  self.parse_semicolon()
  let stmt = DoStmt::new(body, condition)
  Stmt::new(StmtKind::DoStmt(stmt), self.span_from(start, condition.span.end))
}

///|
fn Parser::parse_for_stmt(self : Parser) -> Stmt raise ParseError {
  let start = self.advance().start
  let is_await = if self.at(LexKind::KeywordAwait) {
    self.advance() |> ignore
    true
  } else {
    false
  }
  if is_await && self.in_function > 0 && self.in_async_function == 0 {
    raise self.parse_error_at(
      start,
      self.current().end,
      ParseErrorKind::ForAwaitOnlyInAsyncFunction,
    )
  }
  if is_await && self.for_await_range is None {
    self.for_await_range = Some((start, self.current().end))
  }
  self.expect(LexKind::LParen) |> ignore
  if self.at(LexKind::Semicolon) {
    self.advance() |> ignore
    let condition = if !self.at(LexKind::Semicolon) {
      Some(self.parse_expr())
    } else {
      None
    }
    self.expect(LexKind::Semicolon) |> ignore
    let incrementor = if !self.at(LexKind::RParen) {
      Some(self.parse_expr())
    } else {
      None
    }
    self.expect(LexKind::RParen) |> ignore
    let body = self.parse_stmt()
    let stmt = ForStmt::new(None, condition, incrementor, body)
    return Stmt::new(
      StmtKind::ForStmt(stmt),
      self.span_from(start, body.span.end),
    )
  }
  let init : ForInitializer = if self.at(LexKind::KeywordLet) ||
    self.at(LexKind::KeywordConst) ||
    self.at(LexKind::KeywordVar) ||
    self.is_using_stmt_start() ||
    self.is_await_using_stmt_start() {
    if self.is_await_using_stmt_start() {
      let await_start = self.current().start
      self.advance() |> ignore
      self.expect(LexKind::KeywordUsing) |> ignore
      if self.in_function > 0 && self.in_async_function == 0 {
        raise self.parse_error_at(
          await_start,
          self.current().end,
          ParseErrorKind::AwaitUsingOnlyInAsyncFunction,
        )
      }
      let list = self.parse_using_decl_list(start)
      let span = self.span_from(await_start, self.current().start)
      self.record_top_level_await_using(span)
      ForInitializer::UsingDeclList(list, true)
    } else if self.is_using_stmt_start() {
      self.advance() |> ignore
      let list = self.parse_using_decl_list(start)
      ForInitializer::UsingDeclList(list, false)
    } else {
      let decl_kind = variable_decl_kind_from_token(self.current().kind)
      self.advance() |> ignore
      let list = self.parse_variable_decl_list(start, decl_kind)
      ForInitializer::VariableDeclList(list)
    }
  } else {
    ForInitializer::Expr(self.parse_expr_no_in())
  }
  if self.at(LexKind::KeywordIn) || self.at(LexKind::KeywordOf) {
    let is_for_of = self.at(LexKind::KeywordOf)
    if is_await && !is_for_of {
      let tok = self.current()
      raise self.parse_error_at(
        tok.start,
        tok.end,
        ParseErrorKind::ForAwaitMustUseOf(tok.kind),
      )
    }
    self.advance() |> ignore
    let expr = self.parse_expr()
    self.expect(LexKind::RParen) |> ignore
    let body = self.parse_stmt()
    if is_for_of {
      let stmt = ForOfStmt::new(init, expr, body, is_await)
      return Stmt::new(
        StmtKind::ForOfStmt(stmt),
        self.span_from(start, body.span.end),
      )
    }
    let stmt = ForInStmt::new(init, expr, body)
    return Stmt::new(
      StmtKind::ForInStmt(stmt),
      self.span_from(start, body.span.end),
    )
  }
  if is_await {
    let tok = self.current()
    raise self.parse_error_at(
      tok.start,
      tok.end,
      ParseErrorKind::ForAwaitMustUseOf(tok.kind),
    )
  }
  self.expect(LexKind::Semicolon) |> ignore
  let condition = if !self.at(LexKind::Semicolon) {
    Some(self.parse_expr())
  } else {
    None
  }
  self.expect(LexKind::Semicolon) |> ignore
  let incrementor = if !self.at(LexKind::RParen) {
    Some(self.parse_expr())
  } else {
    None
  }
  self.expect(LexKind::RParen) |> ignore
  let body = self.parse_stmt()
  let stmt = ForStmt::new(Some(init), condition, incrementor, body)
  Stmt::new(StmtKind::ForStmt(stmt), self.span_from(start, body.span.end))
}

///|
fn Parser::parse_with_stmt(self : Parser) -> Stmt raise ParseError {
  let start = self.advance().start
  self.expect(LexKind::LParen) |> ignore
  let expr = self.parse_expr()
  self.expect(LexKind::RParen) |> ignore
  let body = self.parse_stmt()
  let stmt = WithStmt::new(expr, body)
  Stmt::new(StmtKind::WithStmt(stmt), self.span_from(start, body.span.end))
}

///|
fn Parser::parse_case_block(self : Parser) -> CaseBlock raise ParseError {
  let clauses : Array[CaseOrDefaultClause] = []
  self.expect(LexKind::LBrace) |> ignore
  while !self.at(LexKind::RBrace) && !self.at(LexKind::Eof) {
    if self.at(LexKind::KeywordCase) {
      self.advance() |> ignore
      let expr = self.parse_expr()
      self.expect(LexKind::Colon) |> ignore
      let stmts : Array[Stmt] = []
      while !self.at(LexKind::KeywordCase) &&
            !self.at(LexKind::KeywordDefault) &&
            !self.at(LexKind::RBrace) &&
            !self.at(LexKind::Eof) {
        stmts.push(self.parse_stmt())
      }
      let stmt_arr = self.node_array(
        stmts,
        expr.span.start,
        self.current().start,
      )
      clauses.push(
        CaseOrDefaultClause::CaseClause(CaseClause::new(expr, stmt_arr)),
      )
      continue
    }
    if self.at(LexKind::KeywordDefault) {
      self.advance() |> ignore
      self.expect(LexKind::Colon) |> ignore
      let stmts : Array[Stmt] = []
      while !self.at(LexKind::KeywordCase) &&
            !self.at(LexKind::KeywordDefault) &&
            !self.at(LexKind::RBrace) &&
            !self.at(LexKind::Eof) {
        stmts.push(self.parse_stmt())
      }
      clauses.push(
        CaseOrDefaultClause::DefaultClause(
          self.node_array(stmts, 0, self.current().start),
        ),
      )
      continue
    }
    break
  }
  self.expect(LexKind::RBrace) |> ignore
  CaseBlock::new(self.node_array(clauses, 0, self.current().start))
}

///|
fn Parser::parse_switch_stmt(self : Parser) -> Stmt raise ParseError {
  let start = self.advance().start
  self.expect(LexKind::LParen) |> ignore
  let expr = self.parse_expr()
  self.expect(LexKind::RParen) |> ignore
  let block = self.parse_case_block()
  let stmt = SwitchStmt::new(expr, block)
  Stmt::new(
    StmtKind::SwitchStmt(stmt),
    self.span_from(start, self.current().start),
  )
}

///|
fn Parser::parse_try_stmt(self : Parser) -> Stmt raise ParseError {
  let start = self.advance().start
  let (try_block, _) = self.parse_block()
  let mut catch_clause : CatchClause? = None
  if self.at(LexKind::KeywordCatch) {
    self.advance() |> ignore
    let mut binding : VariableDecl? = None
    if self.at(LexKind::LParen) {
      self.advance() |> ignore
      let (name, _) = self.parse_binding_name()
      self.expect(LexKind::RParen) |> ignore
      binding = Some(VariableDecl::new(VariableDeclKind::Let, name, None, None))
    }
    let (catch_block, _) = self.parse_block()
    catch_clause = Some(CatchClause::new(binding, catch_block))
  }
  let finally_block = if self.at(LexKind::KeywordFinally) {
    self.advance() |> ignore
    let (block, _) = self.parse_block()
    Some(block)
  } else {
    None
  }
  let stmt = TryStmt::new(try_block, catch_clause, finally_block)
  Stmt::new(
    StmtKind::TryStmt(stmt),
    self.span_from(start, self.current().start),
  )
}

///|
fn Parser::parse_labeled_stmt(self : Parser) -> Stmt raise ParseError {
  let label = self.parse_identifier()
  self.expect(LexKind::Colon) |> ignore
  let statement = self.parse_stmt()
  let stmt = LabeledStmt::new(label, statement)
  Stmt::new(
    StmtKind::LabeledStmt(stmt),
    self.span_from(label.span.start, statement.span.end),
  )
}

///|
fn Parser::parse_debugger_stmt(self : Parser) -> Stmt raise ParseError {
  let start = self.advance().start
  self.parse_semicolon()
  Stmt::new(StmtKind::DebuggerStmt, self.span_from(start, self.current().start))
}

///|
fn Parser::parse_function_decl_with_modifiers(
  self : Parser,
  start : Int,
  modifiers : NodeArray[ModifierKind]?,
) -> Stmt raise ParseError {
  self.expect(LexKind::KeywordFunction) |> ignore
  let mut is_generator = false
  if self.at(LexKind::Star) {
    self.advance() |> ignore
    is_generator = true
  }
  let name = self.parse_identifier()
  let type_parameters = if self.at(LexKind::Lt) {
    Some(self.parse_type_parameters())
  } else {
    None
  }
  let params = self.parse_parameter_list(false)
  let return_type = if self.at(LexKind::Colon) {
    self.advance() |> ignore
    Some(self.parse_type())
  } else {
    None
  }
  let is_async = modifiers_has(modifiers, ModifierKind::Async)
  let (body, body_span) = if self.at(LexKind::LBrace) {
    let (stmts, span) = self.parse_block_with_function_context(
      is_generator, is_async,
    )
    (Some(stmts), Some(span))
  } else {
    if !self.try_parse_semicolon() {
      let tok = self.current()
      raise self.parse_error_at(
        tok.start,
        tok.end,
        ParseErrorKind::MissingFunctionBodyOrSemicolon(tok.kind),
      )
    }
    (None, None)
  }
  let top_mods = parse_top_level_modifiers(
    modifiers,
    false,
    false,
    self.span_from(start, self.current().start),
  )
  let func = FunctionDecl::new(
    top_mods,
    is_async,
    is_generator,
    Some(name),
    type_parameters,
    params,
    return_type,
    body,
  )
  Stmt::new(
    StmtKind::FunctionDecl(func),
    self.span_from(
      start,
      match body_span {
        Some(span) => span.end
        None => self.current().start
      },
    ),
  )
}

///|
fn Parser::parse_function_decl(self : Parser) -> Stmt raise ParseError {
  let start = self.current().start
  self.parse_function_decl_with_modifiers(start, None)
}

///|
fn Parser::parse_class_decl_with_modifiers(
  self : Parser,
  start : Int,
  decorators : NodeArray[Expr]?,
  modifiers : NodeArray[ModifierKind]?,
) -> Stmt raise ParseError {
  self.expect(LexKind::KeywordClass) |> ignore
  let name = self.parse_identifier()
  let type_parameters = if self.at(LexKind::Lt) {
    Some(self.parse_type_parameters())
  } else {
    None
  }
  let heritage_items : Array[HeritageClause] = []
  if self.at(LexKind::KeywordExtends) {
    let extends_tok = self.advance()
    let clause = self.parse_heritage_clause(
      HeritageKind::Extends,
      extends_tok.start,
    )
    heritage_items.push(clause)
  }
  if self.at(LexKind::KeywordImplements) {
    let implements_tok = self.advance()
    let clause = self.parse_heritage_clause(
      HeritageKind::Implements,
      implements_tok.start,
    )
    heritage_items.push(clause)
  }
  let heritage = if heritage_items.length() > 0 {
    Some(self.node_array(heritage_items, start, self.current().start))
  } else {
    None
  }
  let body_start = self.expect(LexKind::LBrace).start
  let members = self.parse_class_elements(body_start)
  let end_tok = self.expect(LexKind::RBrace)
  let top_mods = parse_top_level_modifiers(
    modifiers,
    true,
    false,
    self.span_from(start, end_tok.end),
  )
  let decl = ClassDecl::new(
    decorators,
    top_mods,
    Some(name),
    type_parameters,
    heritage,
    members,
  )
  Stmt::new(StmtKind::ClassDecl(decl), self.span_from(start, end_tok.end))
}

///|
fn Parser::parse_class_decl(self : Parser) -> Stmt raise ParseError {
  let start = self.current().start
  self.parse_class_decl_with_modifiers(start, None, None)
}

///|
fn Parser::parse_interface_decl_with_modifiers(
  self : Parser,
  start : Int,
  modifiers : NodeArray[ModifierKind]?,
) -> Stmt raise ParseError {
  self.expect(LexKind::KeywordInterface) |> ignore
  let name = self.parse_identifier()
  let type_parameters = if self.at(LexKind::Lt) {
    Some(self.parse_type_parameters())
  } else {
    None
  }
  let heritage_items : Array[HeritageClause] = []
  if self.at(LexKind::KeywordExtends) {
    let extends_tok = self.advance()
    let clause = self.parse_heritage_clause(
      HeritageKind::Extends,
      extends_tok.start,
    )
    heritage_items.push(clause)
  }
  let heritage = if heritage_items.length() > 0 {
    Some(self.node_array(heritage_items, start, self.current().start))
  } else {
    None
  }
  let body_start = self.expect(LexKind::LBrace).start
  let members = self.parse_type_literal_members()
  let end_tok = self.expect(LexKind::RBrace)
  let top_mods = parse_top_level_modifiers(
    modifiers,
    false,
    false,
    self.span_from(start, end_tok.end),
  )
  let decl = InterfaceDecl::new(
    top_mods,
    name,
    type_parameters,
    heritage,
    self.node_array(members, body_start, end_tok.end),
  )
  Stmt::new(StmtKind::InterfaceDecl(decl), self.span_from(start, end_tok.end))
}

///|
fn Parser::parse_interface_decl(self : Parser) -> Stmt raise ParseError {
  let start = self.current().start
  self.parse_interface_decl_with_modifiers(start, None)
}

///|
fn Parser::parse_type_alias_decl_with_modifiers(
  self : Parser,
  start : Int,
  modifiers : NodeArray[ModifierKind]?,
) -> Stmt raise ParseError {
  self.expect(LexKind::KeywordType) |> ignore
  if self.has_preceding_line_break() {
    let tok = self.current()
    raise self.parse_error_at(
      tok.start,
      tok.end,
      ParseErrorKind::LineBreakAfterTypeKeyword,
    )
  }
  let name = self.parse_identifier()
  let type_parameters = if self.at(LexKind::Lt) {
    Some(self.parse_type_parameters())
  } else {
    None
  }
  self.expect(LexKind::Eq) |> ignore
  let type_node = self.parse_type()
  self.parse_semicolon()
  let alias_end = self.current().start
  let top_mods = parse_top_level_modifiers(
    modifiers,
    false,
    false,
    self.span_from(start, alias_end),
  )
  let decl = TypeAliasDecl::new(top_mods, name, type_parameters, type_node)
  Stmt::new(
    StmtKind::TypeAliasDecl(decl),
    self.span_from(start, self.current().start),
  )
}

///|
fn Parser::parse_type_alias_decl(self : Parser) -> Stmt raise ParseError {
  let start = self.current().start
  self.parse_type_alias_decl_with_modifiers(start, None)
}

///|
fn Parser::parse_enum_decl_with_modifiers(
  self : Parser,
  start : Int,
  modifiers : NodeArray[ModifierKind]?,
) -> Stmt raise ParseError {
  self.expect(LexKind::KeywordEnum) |> ignore
  let name = self.parse_identifier()
  let body_start = self.expect(LexKind::LBrace).start
  let members : Array[EnumMember] = []
  while !self.at(LexKind::RBrace) && !self.at(LexKind::Eof) {
    if self.at(LexKind::Comma) {
      self.advance() |> ignore
      continue
    }
    let member_name = self.parse_property_name()
    let initializer = if self.at(LexKind::Eq) {
      self.advance() |> ignore
      Some(self.parse_assignment_expr())
    } else {
      None
    }
    members.push(EnumMember::new(member_name, initializer))
    if self.at(LexKind::Comma) {
      self.advance() |> ignore
      continue
    }
    break
  }
  let end_tok = self.expect(LexKind::RBrace)
  let top_mods = parse_top_level_modifiers(
    modifiers,
    false,
    true,
    self.span_from(start, end_tok.end),
  )
  let decl = EnumDecl::new(
    top_mods,
    name,
    self.node_array(members, body_start, end_tok.end),
  )
  Stmt::new(StmtKind::EnumDecl(decl), self.span_from(start, end_tok.end))
}

///|
fn Parser::parse_enum_decl(self : Parser) -> Stmt raise ParseError {
  let start = self.current().start
  self.parse_enum_decl_with_modifiers(start, None)
}

///|
fn Parser::parse_module_name(self : Parser) -> ModuleName raise ParseError {
  let tok = self.current()
  match tok.kind {
    Identifier(_) => ModuleName::Identifier(self.parse_identifier())
    KeywordGlobal => {
      self.advance() |> ignore
      let id = Identifier::new("global", self.span_from(tok.start, tok.end))
      ModuleName::Identifier(id)
    }
    String(value) => {
      self.advance() |> ignore
      let lit = StringLiteral::new(value, self.span_from(tok.start, tok.end))
      ModuleName::StringLiteral(lit)
    }
    _ =>
      raise self.parse_error_at(
        tok.start,
        tok.end,
        ParseErrorKind::UnexpectedToken(tok.kind),
      )
  }
}

///|
fn Parser::parse_module_block(self : Parser) -> ModuleBody raise ParseError {
  let (stmts, span) = self.parse_block()
  ModuleBody::ModuleBlock(self.node_array(stmts, span.start, span.end))
}

///|
fn Parser::parse_module_decl_with_modifiers(
  self : Parser,
  start : Int,
  modifiers : NodeArray[ModifierKind]?,
) -> Stmt raise ParseError {
  let has_declare = modifiers_has(modifiers, ModifierKind::Declare)
  let keyword = self.current().kind
  self.advance() |> ignore
  let end = self.current().start
  if keyword == LexKind::KeywordNamespace &&
    self.current().kind is LexKind::String(_) {
    let tok = self.current()
    raise self.parse_error_at(
      tok.start,
      tok.end,
      ParseErrorKind::InvalidNamespaceNameStringLiteral(tok.kind),
    )
  }
  let first_name = self.parse_module_name()
  match first_name {
    ModuleName::StringLiteral(s) => {
      if !has_declare {
        raise self.parse_error_at(
          start,
          self.current().start,
          ParseErrorKind::StringLiteralModuleNameOnlyInDeclare,
        )
      }
      let body = if self.at(LexKind::LBrace) {
        Some(self.parse_module_block())
      } else {
        self.parse_semicolon()
        None
      }
      let span = match modifiers {
        Some(m) => m.start
        None => s.span
      }
      let top_mods = parse_top_level_modifiers(modifiers, false, false, span)
      let decl = ModuleDecl::new(top_mods, first_name, body)
      return Stmt::new(
        StmtKind::ModuleDecl(decl),
        self.span_from(start, self.current().start),
      )
    }
    ModuleName::Identifier(first_id) => {
      let names : Array[Identifier] = [first_id]
      while self.at(LexKind::Dot) {
        self.advance() |> ignore
        names.push(self.parse_identifier())
      }
      let leaf_body = if self.at(LexKind::LBrace) {
        Some(self.parse_module_block())
      } else if has_declare {
        self.parse_semicolon()
        None
      } else {
        raise self.parse_error_at(
          start,
          self.current().start,
          ParseErrorKind::ModuleBodyRequiredWithoutDeclare,
        )
      }
      let mut current_body = leaf_body
      let mut i = names.length()
      while i > 0 {
        i = i - 1
        let name = ModuleName::Identifier(names[i])
        let m = parse_top_level_modifiers(
          modifiers,
          false,
          false,
          self.span_from(start, end),
        )
        let decl = ModuleDecl::new(m, name, current_body)
        current_body = Some(ModuleBody::ModuleDecl(decl))
      }
      let body_decl = match current_body {
        Some(ModuleBody::ModuleDecl(decl)) => decl
        _ =>
          raise self.parse_error_at(
            start,
            self.current().start,
            ParseErrorKind::InvalidModuleBody,
          )
      }
      Stmt::new(
        StmtKind::ModuleDecl(body_decl),
        self.span_from(start, self.current().start),
      )
    }
  }
}

///|
fn Parser::parse_module_decl(self : Parser) -> Stmt raise ParseError {
  let start = self.current().start
  self.parse_module_decl_with_modifiers(start, None)
}

///|
fn Parser::parse_global_module_decl_with_modifiers(
  self : Parser,
  start : Int,
  modifiers : NodeArray[ModifierKind]?,
) -> Stmt raise ParseError {
  let tok = self.advance()
  let name = Identifier::new("global", self.span_from(tok.start, tok.end))
  let body = if self.at(LexKind::LBrace) {
    Some(self.parse_module_block())
  } else {
    self.parse_semicolon()
    None
  }
  let span = match modifiers {
    Some(m) => m.start
    None => name.span
  }
  let top_mods = parse_top_level_modifiers(modifiers, false, false, span)
  let decl = ModuleDecl::new(top_mods, ModuleName::Identifier(name), body)
  Stmt::new(
    StmtKind::ModuleDecl(decl),
    self.span_from(start, self.current().start),
  )
}

///|
fn Parser::parse_global_module_decl(self : Parser) -> Stmt raise ParseError {
  let start = self.current().start
  self.parse_global_module_decl_with_modifiers(start, None)
}

///|
fn Parser::parse_import_attribute_name(
  self : Parser,
) -> ImportAttributeName raise ParseError {
  let tok = self.current()
  match tok.kind {
    Identifier(_) => ImportAttributeName::Identifier(self.parse_identifier())
    String(value) => {
      self.advance() |> ignore
      let lit = StringLiteral::new(value, self.span_from(tok.start, tok.end))
      ImportAttributeName::StringLiteral(lit)
    }
    _ =>
      raise self.parse_error_at(
        tok.start,
        tok.end,
        ParseErrorKind::UnexpectedToken(tok.kind),
      )
  }
}

///|
fn Parser::parse_import_attributes(
  self : Parser,
) -> ImportAttributes? raise ParseError {
  if self.has_preceding_line_break() {
    return None
  }
  if !self.at(LexKind::KeywordWith) && !self.at(LexKind::KeywordAssert) {
    return None
  }
  let start = self.advance().start
  self.expect(LexKind::LBrace) |> ignore
  if self.at(LexKind::Comma) {
    let tok = self.current()
    raise self.parse_error_at(
      tok.start,
      tok.end,
      ParseErrorKind::LeadingCommaInImportAttributes,
    )
  }
  let items : Array[ImportAttribute] = []
  while !self.at(LexKind::RBrace) && !self.at(LexKind::Eof) {
    if self.at(LexKind::Comma) {
      self.advance() |> ignore
      continue
    }
    let name = self.parse_import_attribute_name()
    self.expect(LexKind::Colon) |> ignore
    let value = self.parse_assignment_expr()
    items.push(ImportAttribute::new(name, value))
    if self.at(LexKind::Comma) {
      self.advance() |> ignore
      continue
    }
    break
  }
  let end_tok = self.expect(LexKind::RBrace)
  Some(ImportAttributes::new(self.node_array(items, start, end_tok.end)))
}

///|
fn Parser::parse_module_specifier(self : Parser) -> Expr raise ParseError {
  let tok = self.current()
  match tok.kind {
    String(value) => {
      self.advance() |> ignore
      let lit = StringLiteral::new(value, self.span_from(tok.start, tok.end))
      Expr::new(
        ExprKind::StringLiteral(lit),
        self.span_from(tok.start, tok.end),
      )
    }
    _ =>
      raise self.parse_error_at(
        tok.start,
        tok.end,
        ParseErrorKind::ExpectedStringLiteralInModuleSpecifier(tok.kind),
      )
  }
}

///|
fn Parser::parse_import_specifier(
  self : Parser,
) -> ImportSpecifier raise ParseError {
  let mut is_type_only = false
  let mut property_name : Identifier? = None
  let mut can_parse_as_keyword = true
  let mut name : Identifier = if self.at(LexKind::KeywordType) {
    let mut parsed_name = self.parse_identifier_name()
    if self.at(LexKind::KeywordAs) {
      let first_as = self.parse_identifier_name()
      if self.at(LexKind::KeywordAs) {
        let second_as = self.parse_identifier_name()
        if self.is_module_export_name_start() {
          is_type_only = true
          property_name = Some(first_as)
          parsed_name = self.parse_module_export_name()
          can_parse_as_keyword = false
        } else {
          property_name = Some(parsed_name)
          parsed_name = second_as
          can_parse_as_keyword = false
        }
      } else if self.is_module_export_name_start() {
        property_name = Some(parsed_name)
        parsed_name = self.parse_module_export_name()
        can_parse_as_keyword = false
      } else {
        is_type_only = true
        parsed_name = first_as
      }
    } else if self.is_module_export_name_start() {
      is_type_only = true
      parsed_name = self.parse_module_export_name()
    }
    parsed_name
  } else {
    self.parse_module_export_name()
  }
  if can_parse_as_keyword && self.at(LexKind::KeywordAs) {
    self.advance() |> ignore
    property_name = Some(name)
    name = self.parse_module_export_name()
  }
  ImportSpecifier::new(is_type_only, property_name, name)
}

///|
fn Parser::parse_named_import_bindings(
  self : Parser,
) -> NamedImportBindings raise ParseError {
  if self.at(LexKind::Star) {
    self.advance() |> ignore
    self.expect(LexKind::KeywordAs) |> ignore
    let name = self.parse_identifier()
    return NamedImportBindings::NamespaceImport(name)
  }
  let open = self.expect(LexKind::LBrace)
  if self.at(LexKind::Comma) {
    let tok = self.current()
    raise self.parse_error_at(
      tok.start,
      tok.end,
      ParseErrorKind::LeadingCommaInNamedImports,
    )
  }
  let specifiers : Array[ImportSpecifier] = []
  while !self.at(LexKind::RBrace) && !self.at(LexKind::Eof) {
    if self.at(LexKind::Comma) {
      self.advance() |> ignore
      continue
    }
    specifiers.push(self.parse_import_specifier())
    if self.at(LexKind::Comma) {
      self.advance() |> ignore
      continue
    }
    break
  }
  let end_tok = self.expect(LexKind::RBrace)
  NamedImportBindings::NamedImports(
    self.node_array(specifiers, open.start, end_tok.end),
  )
}

///|
fn Parser::parse_import_equals_module_ref(
  self : Parser,
) -> ImportEqualsModuleRef raise ParseError {
  match self.current().kind {
    Identifier(name) if name == "require" &&
      self.peek(1).kind == LexKind::LParen => {
      self.advance() |> ignore
      self.expect(LexKind::LParen) |> ignore
      let module_specifier = self.parse_module_specifier()
      self.expect(LexKind::RParen) |> ignore
      ImportEqualsModuleRef::ExternalModuleRef(module_specifier)
    }
    Identifier(_) => {
      let first = self.parse_identifier()
      let (entity, _) = self.parse_entity_name(first)
      ImportEqualsModuleRef::EntityName(entity)
    }
    _ =>
      raise self.parse_error_at(
        self.current().start,
        self.current().end,
        ParseErrorKind::UnexpectedToken(self.current().kind),
      )
  }
}

///|
fn Parser::parse_import_equals_decl(
  self : Parser,
  start : Int,
  is_type_only : Bool,
  name : Identifier,
) -> Stmt raise ParseError {
  self.expect(LexKind::Eq) |> ignore
  let module_ref = self.parse_import_equals_module_ref()
  self.parse_semicolon()
  let decl = ImportEqualsDecl::new(is_type_only, name, module_ref)
  Stmt::new(
    StmtKind::ImportEqualsDecl(decl),
    self.span_from(start, self.current().start),
  )
}

///|
fn Parser::parse_import_decl(self : Parser) -> Stmt raise ParseError {
  let start = self.expect(LexKind::KeywordImport).start
  self.has_import_syntax = true
  let mut phase = ImportPhase::Normal
  let mut is_type_only = false
  if self.at(LexKind::KeywordType) {
    let mut is_phase = true
    if self.peek(1).kind == LexKind::KeywordFrom {
      if self.peek(2).kind is String(_) {
        is_phase = false
      }
    }
    if is_phase {
      self.advance() |> ignore
      phase = ImportPhase::Type
      is_type_only = true
    }
  } else if self.current().kind is Identifier(text) && text == "defer" {
    let next_kind = self.peek(1).kind
    let mut is_phase = true
    if next_kind == LexKind::KeywordFrom {
      if self.peek(2).kind is String(_) {
        is_phase = false
      }
    } else if next_kind == LexKind::Comma || next_kind == LexKind::Eq {
      is_phase = false
    }
    if is_phase {
      self.advance() |> ignore
      phase = ImportPhase::Defer
    }
  }
  if self.current().kind is String(_) {
    let module_specifier = self.parse_module_specifier()
    let attributes = self.parse_import_attributes()
    self.parse_semicolon()
    let span = self.span_from(start, module_specifier.span.end)
    let decl = ImportDecl::new(None, module_specifier, attributes, phase)
    return Stmt::new(StmtKind::ImportDecl(decl), span)
  }
  let mut name : Identifier? = None
  let mut named_bindings : NamedImportBindings? = None
  if self.current().kind is Identifier(_) {
    let id = self.parse_identifier()
    if self.at(LexKind::Eq) {
      if phase == ImportPhase::Defer {
        let tok = self.current()
        raise self.parse_error_at(
          tok.start,
          tok.end,
          ParseErrorKind::UnexpectedToken(tok.kind),
        )
      }
      return self.parse_import_equals_decl(start, is_type_only, id)
    }
    name = Some(id)
    if self.at(LexKind::Comma) {
      self.advance() |> ignore
      named_bindings = Some(self.parse_named_import_bindings())
    }
  } else {
    named_bindings = Some(self.parse_named_import_bindings())
  }
  self.expect(LexKind::KeywordFrom) |> ignore
  let module_specifier = self.parse_module_specifier()
  let attributes = self.parse_import_attributes()
  self.parse_semicolon()
  let import_clause = ImportClause::new(is_type_only, name, named_bindings)
  let decl = ImportDecl::new(
    Some(import_clause),
    module_specifier,
    attributes,
    phase,
  )
  Stmt::new(
    StmtKind::ImportDecl(decl),
    self.span_from(start, self.current().start),
  )
}

///|
fn Parser::parse_export_specifier(
  self : Parser,
) -> ExportSpecifier raise ParseError {
  let mut is_type_only = false
  let mut property_name : Identifier? = None
  let mut can_parse_as_keyword = true
  let mut name : Identifier = if self.at(LexKind::KeywordType) {
    let mut parsed_name = self.parse_identifier_name()
    if self.at(LexKind::KeywordAs) {
      let first_as = self.parse_identifier_name()
      if self.at(LexKind::KeywordAs) {
        let second_as = self.parse_identifier_name()
        if self.is_module_export_name_start() {
          is_type_only = true
          property_name = Some(first_as)
          parsed_name = self.parse_module_export_name()
          can_parse_as_keyword = false
        } else {
          property_name = Some(parsed_name)
          parsed_name = second_as
          can_parse_as_keyword = false
        }
      } else if self.is_module_export_name_start() {
        property_name = Some(parsed_name)
        parsed_name = self.parse_module_export_name()
        can_parse_as_keyword = false
      } else {
        is_type_only = true
        parsed_name = first_as
      }
    } else if self.is_module_export_name_start() {
      is_type_only = true
      parsed_name = self.parse_module_export_name()
    }
    parsed_name
  } else {
    self.parse_module_export_name()
  }
  if can_parse_as_keyword && self.at(LexKind::KeywordAs) {
    self.advance() |> ignore
    property_name = Some(name)
    name = self.parse_module_export_name()
  }
  ExportSpecifier::new(is_type_only, property_name, name)
}

///|
fn Parser::parse_namespace_export_decl(
  self : Parser,
  start : Int,
) -> Stmt raise ParseError {
  self.expect(LexKind::KeywordAs) |> ignore
  self.expect(LexKind::KeywordNamespace) |> ignore
  let name = self.parse_identifier()
  self.parse_semicolon()
  let decl = NamespaceExportDecl::new(name)
  Stmt::new(
    StmtKind::NamespaceExportDecl(decl),
    self.span_from(start, self.current().start),
  )
}

///|
fn Parser::parse_export_decl(self : Parser) -> Stmt raise ParseError {
  let start = self.expect(LexKind::KeywordExport).start
  self.has_export_syntax = true
  if self.at(LexKind::Eq) {
    if !(self.script_kind is TSDeclarations) {
      raise self.parse_error_at(
        start,
        self.current().end,
        ParseErrorKind::ExportAssignmentOnlyInDeclarationFile,
      )
    }
    if self.has_non_namespace_export {
      raise self.parse_error_at(
        start,
        self.current().end,
        ParseErrorKind::ExportAssignmentCannotBeUsedWithOtherExports,
      )
    }
    self.advance() |> ignore
    let expr = self.parse_expr()
    self.parse_semicolon()
    let mods = self.node_array([ModifierKind::Export], start, start)
    let assign = ExportAssignment::new(Some(mods), true, expr)
    self.has_export_assignment = true
    return Stmt::new(
      StmtKind::ExportAssignment(assign),
      self.span_from(start, self.current().start),
    )
  }
  if self.at(LexKind::KeywordDefault) {
    let default_tok = self.advance()
    let mods = self.node_array(
      [ModifierKind::Export, ModifierKind::Default],
      start,
      default_tok.end,
    )
    if self.at(LexKind::KeywordClass) {
      self.mark_non_namespace_export(start, self.current().end)
      return self.parse_class_decl_with_modifiers(start, None, Some(mods))
    }
    if self.at(LexKind::KeywordFunction) {
      self.mark_non_namespace_export(start, self.current().end)
      return self.parse_function_decl_with_modifiers(start, Some(mods))
    }
    let expr = self.parse_expr()
    self.try_parse_semicolon() |> ignore
    let assign = ExportAssignment::new(Some(mods), false, expr)
    self.mark_non_namespace_export(start, self.current().end)
    return Stmt::new(
      StmtKind::ExportAssignment(assign),
      self.span_from(start, self.current().start),
    )
  }
  if self.at(LexKind::KeywordAs) {
    if !(self.script_kind is TSDeclarations) {
      raise self.parse_error_at(
        start,
        self.current().end,
        ParseErrorKind::ExportNamespaceOnlyInDeclarationFile,
      )
    }
    if self.export_namespace_range is None {
      self.export_namespace_range = Some((start, self.current().end))
    }
    return self.parse_namespace_export_decl(start)
  }
  let mut is_type_only = false
  if self.at(LexKind::KeywordType) {
    let next_kind = self.peek(1).kind
    if next_kind == LexKind::LBrace || next_kind == LexKind::Star {
      self.advance() |> ignore
      is_type_only = true
    }
  }
  let items : Array[ModifierKind] = [ModifierKind::Export]
  let mut end_start = self.current().start
  if self.current().kind is Identifier(text) {
    match modifier_kind_from_name(text) {
      Some(_) => {
        let extra = self.parse_modifiers(start)
        if extra is Some(list) {
          for item in list.elements.iter() {
            items.push(item)
          }
          end_start = list.end.end
        }
      }
      None => ()
    }
  }
  let mods = self.node_array(items, start, end_start)
  if self.at(LexKind::KeywordConst) && self.peek(1).kind == LexKind::KeywordEnum {
    self.mark_non_namespace_export(start, self.current().end)
    let const_tok = self.advance()
    let enum_items = mods.elements + [ModifierKind::Const]
    let enum_mods = self.node_array(enum_items, start, const_tok.end)
    return self.parse_enum_decl_with_modifiers(start, Some(enum_mods))
  }
  if self.at(LexKind::KeywordClass) {
    self.mark_non_namespace_export(start, self.current().end)
    return self.parse_class_decl_with_modifiers(start, None, Some(mods))
  }
  if self.at(LexKind::KeywordFunction) {
    self.mark_non_namespace_export(start, self.current().end)
    return self.parse_function_decl_with_modifiers(start, Some(mods))
  }
  if self.at(LexKind::KeywordInterface) {
    self.mark_non_namespace_export(start, self.current().end)
    return self.parse_interface_decl_with_modifiers(start, Some(mods))
  }
  if self.at(LexKind::KeywordType) {
    self.mark_non_namespace_export(start, self.current().end)
    return self.parse_type_alias_decl_with_modifiers(start, Some(mods))
  }
  if self.at(LexKind::KeywordEnum) {
    self.mark_non_namespace_export(start, self.current().end)
    return self.parse_enum_decl_with_modifiers(start, Some(mods))
  }
  if self.at(LexKind::KeywordModule) || self.at(LexKind::KeywordNamespace) {
    self.mark_non_namespace_export(start, self.current().end)
    return self.parse_module_decl_with_modifiers(start, Some(mods))
  }
  let is_var_decl = self.at(LexKind::KeywordLet) ||
    self.at(LexKind::KeywordConst) ||
    self.at(LexKind::KeywordVar) ||
    self.is_using_stmt_start() ||
    self.is_await_using_stmt_start()
  if is_var_decl {
    self.mark_non_namespace_export(start, self.current().end)
    if self.is_using_stmt_start() {
      return self.parse_using_stmt_with_modifiers(start, Some(mods), false)
    }
    if self.is_await_using_stmt_start() {
      return self.parse_using_stmt_with_modifiers(start, Some(mods), true)
    }
    return self.parse_variable_stmt_with_modifiers(start, Some(mods))
  }
  if self.at(LexKind::Star) {
    self.mark_non_namespace_export(start, self.current().end)
    self.advance() |> ignore
    let mut export_clause : NamedExportBindings? = None
    if self.at(LexKind::KeywordAs) {
      self.advance() |> ignore
      let name = self.parse_identifier()
      export_clause = Some(NamedExportBindings::NamespaceExport(name))
    }
    self.expect(LexKind::KeywordFrom) |> ignore
    let module_specifier = self.parse_module_specifier()
    let attributes = self.parse_import_attributes()
    self.parse_semicolon()
    let decl = ExportDecl::new(
      Some(mods),
      is_type_only,
      export_clause,
      Some(module_specifier),
      attributes,
    )
    return Stmt::new(
      StmtKind::ExportDecl(decl),
      self.span_from(start, self.current().start),
    )
  }
  if self.at(LexKind::LBrace) {
    self.mark_non_namespace_export(start, self.current().end)
    let open = self.advance()
    if self.at(LexKind::Comma) {
      let tok = self.current()
      raise self.parse_error_at(
        tok.start,
        tok.end,
        ParseErrorKind::LeadingCommaInNamedExports,
      )
    }
    let specifiers : Array[ExportSpecifier] = []
    while !self.at(LexKind::RBrace) && !self.at(LexKind::Eof) {
      if self.at(LexKind::Comma) {
        self.advance() |> ignore
        continue
      }
      specifiers.push(self.parse_export_specifier())
      if self.at(LexKind::Comma) {
        self.advance() |> ignore
        continue
      }
      break
    }
    let end_tok = self.expect(LexKind::RBrace)
    let export_clause = Some(
      NamedExportBindings::NamedExports(
        self.node_array(specifiers, open.start, end_tok.end),
      ),
    )
    let mut module_specifier : Expr? = None
    if self.at(LexKind::KeywordFrom) {
      self.advance() |> ignore
      module_specifier = Some(self.parse_module_specifier())
    }
    let attributes = self.parse_import_attributes()
    self.parse_semicolon()
    let decl = ExportDecl::new(
      Some(mods),
      is_type_only,
      export_clause,
      module_specifier,
      attributes,
    )
    return Stmt::new(
      StmtKind::ExportDecl(decl),
      self.span_from(start, self.current().start),
    )
  }
  let tok = self.current()
  raise self.parse_error_at(
    tok.start,
    tok.end,
    ParseErrorKind::UnexpectedToken(tok.kind),
  )
}

///|
fn Parser::parse_expr_stmt(self : Parser) -> Stmt raise ParseError {
  if self.script_kind is TSDeclarations {
    let tok = self.current()
    raise self.parse_error_at(
      tok.start,
      tok.end,
      ParseErrorKind::DeclarationFileStatementNotAllowed,
    )
  }
  let start = self.current().start
  let expr = self.parse_expr()
  self.parse_semicolon()
  let span = self.span_from(start, expr.span.end)
  Stmt::new(StmtKind::ExprStmt(expr), span)
}

///|
fn Parser::is_using_stmt_start(self : Parser) -> Bool {
  self.at(LexKind::KeywordUsing) &&
  is_identifier_or_contextual(self.peek(1).kind)
}

///|
fn Parser::is_await_using_stmt_start(self : Parser) -> Bool {
  self.at(LexKind::KeywordAwait) &&
  self.peek(1).kind == LexKind::KeywordUsing &&
  is_identifier_or_contextual(self.peek(2).kind)
}

///|
fn Parser::parse_stmt(self : Parser) -> Stmt raise ParseError {
  let is_declare_only = self.script_kind is TSDeclarations &&
    (
      self.at(LexKind::KeywordExport) ||
      self.current().kind is Identifier("declare")
    )
  if self.script_kind is TSDeclarations && !is_declare_only {
    let tok = self.current()
    raise self.parse_error_at(
      tok.start,
      tok.end,
      ParseErrorKind::DeclarationFileStatementNotAllowed,
    )
  }
  match self.current().kind {
    At => {
      let start = self.current().start
      let decorators = self.parse_decorators(start)
      let modifiers = self.parse_modifiers(start)
      if self.at(LexKind::KeywordClass) {
        return self.parse_class_decl_with_modifiers(
          start, decorators, modifiers,
        )
      }
      if decorators is Some(list) {
        raise self.parse_error_at(
          list.start.start,
          list.end.end,
          ParseErrorKind::DecoratorsNotAllowedHere,
        )
      }
      let tok = self.current()
      raise self.parse_error_at(
        tok.start,
        tok.end,
        ParseErrorKind::MissingDeclarationAfterModifiers(tok.kind),
      )
    }
    Identifier(text) => {
      if self.peek(1).kind == LexKind::Colon {
        return self.parse_labeled_stmt()
      }
      match modifier_kind_from_name(text) {
        Some(_) => {
          let next_kind = self.peek(1).kind
          let is_decl = next_kind == LexKind::KeywordClass ||
            next_kind == LexKind::KeywordFunction ||
            next_kind == LexKind::KeywordInterface ||
            next_kind == LexKind::KeywordType ||
            next_kind == LexKind::KeywordEnum ||
            next_kind == LexKind::KeywordModule ||
            next_kind == LexKind::KeywordNamespace ||
            next_kind == LexKind::KeywordGlobal ||
            next_kind == LexKind::KeywordLet ||
            next_kind == LexKind::KeywordConst ||
            next_kind == LexKind::KeywordVar ||
            (
              next_kind == LexKind::KeywordUsing &&
              is_identifier_or_contextual(self.peek(2).kind)
            ) ||
            (
              next_kind == LexKind::KeywordAwait &&
              self.peek(2).kind == LexKind::KeywordUsing &&
              is_identifier_or_contextual(self.peek(3).kind)
            )
          if is_decl {
            let start = self.current().start
            let modifiers = self.parse_modifiers(start)
            if self.at(LexKind::KeywordConst) &&
              self.peek(1).kind == LexKind::KeywordEnum {
              let const_tok = self.advance()
              let items : Array[ModifierKind] = []
              let start_start = match modifiers {
                Some(list) => {
                  for item in list.elements.iter() {
                    items.push(item)
                  }
                  list.start.start
                }
                None => start
              }
              items.push(ModifierKind::Const)
              let combined = self.node_array(items, start_start, const_tok.end)
              return self.parse_enum_decl_with_modifiers(start, Some(combined))
            }
            if self.at(LexKind::KeywordClass) {
              return self.parse_class_decl_with_modifiers(
                start,
                None,
                modifiers,
              )
            }
            if self.at(LexKind::KeywordFunction) {
              return self.parse_function_decl_with_modifiers(start, modifiers)
            }
            if self.at(LexKind::KeywordInterface) {
              return self.parse_interface_decl_with_modifiers(start, modifiers)
            }
            if self.at(LexKind::KeywordType) {
              return self.parse_type_alias_decl_with_modifiers(start, modifiers)
            }
            if self.at(LexKind::KeywordEnum) {
              return self.parse_enum_decl_with_modifiers(start, modifiers)
            }
            if self.at(LexKind::KeywordModule) ||
              self.at(LexKind::KeywordNamespace) {
              return self.parse_module_decl_with_modifiers(start, modifiers)
            }
            if self.at(LexKind::KeywordGlobal) {
              return self.parse_global_module_decl_with_modifiers(
                start, modifiers,
              )
            }
            if self.is_using_stmt_start() {
              return self.parse_using_stmt_with_modifiers(
                start, modifiers, false,
              )
            }
            if self.is_await_using_stmt_start() {
              return self.parse_using_stmt_with_modifiers(
                start, modifiers, true,
              )
            }
            return self.parse_variable_stmt_with_modifiers(start, modifiers)
          }
          self.parse_expr_stmt()
        }
        None => self.parse_expr_stmt()
      }
    }
    KeywordLet => self.parse_variable_stmt()
    KeywordConst =>
      if self.peek(1).kind == LexKind::KeywordEnum {
        let start = self.advance().start
        let modifiers = self.node_array(
          [ModifierKind::Const],
          start,
          self.current().start,
        )
        self.parse_enum_decl_with_modifiers(start, Some(modifiers))
      } else {
        self.parse_variable_stmt()
      }
    KeywordVar => self.parse_variable_stmt()
    KeywordUsing =>
      if self.is_using_stmt_start() {
        self.parse_using_stmt_with_modifiers(self.current().start, None, false)
      } else {
        self.parse_expr_stmt()
      }
    KeywordAwait =>
      if self.is_await_using_stmt_start() {
        self.parse_using_stmt_with_modifiers(self.current().start, None, true)
      } else {
        self.parse_expr_stmt()
      }
    KeywordImport =>
      if self.peek(1).kind == LexKind::LParen ||
        self.peek(1).kind == LexKind::Dot {
        self.parse_expr_stmt()
      } else {
        self.parse_import_decl()
      }
    KeywordExport => self.parse_export_decl()
    KeywordInterface => self.parse_interface_decl()
    KeywordType => self.parse_type_alias_decl()
    KeywordEnum => self.parse_enum_decl()
    KeywordModule => self.parse_module_decl()
    KeywordNamespace => self.parse_module_decl()
    KeywordGlobal => self.parse_global_module_decl()
    KeywordDo => self.parse_do_stmt()
    KeywordWhile => self.parse_while_stmt()
    KeywordFor => self.parse_for_stmt()
    KeywordBreak => self.parse_break_stmt()
    KeywordContinue => self.parse_continue_stmt()
    KeywordThrow => self.parse_throw_stmt()
    KeywordTry => self.parse_try_stmt()
    KeywordSwitch => self.parse_switch_stmt()
    KeywordWith => self.parse_with_stmt()
    KeywordDebugger => self.parse_debugger_stmt()
    KeywordIf => self.parse_if_stmt()
    KeywordReturn => self.parse_return_stmt()
    KeywordFunction => self.parse_function_decl()
    KeywordClass => self.parse_class_decl()
    Semicolon => {
      let start = self.advance().start
      Stmt::new(
        StmtKind::EmptyStmt,
        self.span_from(start, self.current().start),
      )
    }
    LBrace => {
      let (stmts, span) = self.parse_block()
      Stmt::new(StmtKind::Block(stmts), span)
    }
    _ => self.parse_expr_stmt()
  }
}

///|
pub fn Parser::parse_source_file(
  self : Parser,
  file_name : String,
  text : String,
) -> SourceFile raise ParseError {
  let stmts : Array[Stmt] = []
  while !self.at(LexKind::Eof) {
    stmts.push(self.parse_stmt())
  }
  let is_module = self.is_module ||
    self.has_import_syntax ||
    self.has_export_syntax
  if self.top_level_await_range is Some((start, end)) && !is_module {
    raise self.parse_error_at(
      start,
      end,
      ParseErrorKind::TopLevelAwaitOnlyInModule,
    )
  }
  if self.export_namespace_range is Some((start, end)) &&
    !(self.has_import_syntax ||
    self.has_non_namespace_export ||
    self.has_export_assignment) {
    raise self.parse_error_at(
      start,
      end,
      ParseErrorKind::ExportNamespaceOnlyInModule,
    )
  }
  if self.for_await_range is Some((start, end)) && !is_module {
    raise self.parse_error_at(start, end, ParseErrorKind::ForAwaitOnlyInModule)
  }
  if self.await_using_range is Some((start, end)) && !is_module {
    raise self.parse_error_at(
      start,
      end,
      ParseErrorKind::AwaitUsingOnlyInModule,
    )
  }
  let stmts_arr = self.node_array(stmts, 0, text.length())
  SourceFile::new(stmts_arr, file_name, text, is_module, self.script_kind)
}
