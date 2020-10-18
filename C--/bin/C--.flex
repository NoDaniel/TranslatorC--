package jflex;

import java_cup.runtime.Symbol;
%%

%unicode
%class Lexer
%cup
%implements sym 

%line
%column
 
%{
private Symbol symbol(int sym) {
    return new Symbol(sym, yyline+1, yycolumn+1);
}
  
private Symbol symbol(int sym, Object val) {
   return new Symbol(sym, yyline+1, yycolumn+1, val);
}

private void error(String message) {
   System.out.println("Error at line "+ (yyline+1) + ", column " + (yycolumn+ 1)+ " : "+message);
}
%} 

/*  WhiteSpaces - C-- */
LineEnd = [\r\n]|\r\n
Character = [^\r\n]
WhiteSpace = {LineEnd} | [ \t\f]
 
/* Comments - C-- */
LineComment = "//" {Character}* {LineEnd}
LineComment2 = "#" {Character}* {LineEnd}
Comment = {LineComment} | {LineComment2}


/* String - C-- */
String = "\"" ~"\""
 
Identifier = [:jletter:][:jletterdigit:]*
IdentifierError = \w*[a-zA-Z]\w*
 
NumericConstant = [0-9]+
 
%%
<YYINITIAL> {
 
   /* Arithmetic Operations */
   "," { return symbol(COMMA); }
   "=" { return symbol(EQL); }
   ";" { return symbol(SEMI); }
   "+" { return symbol(ADD); } 
   "-" { return symbol(SUB);}  
   "*" { return symbol(MULT); }
   "/" { return symbol(DIV); }
   "!" { return symbol(BANG); }
    "&&" { return symbol(AND); }
   "||" { return symbol(OR); }
   "==" { return symbol(DEQL); }
   "!=" {return symbol(NEQL);}
   "<" { return symbol(LT); }
   ">" { return symbol(GT); }
   "<=" { return symbol(LTEQL); }
   ">=" { return symbol(GTEQL); }
   "<<" { return symbol(DLT); }
   ">>" { return symbol(DGT); }
 
   
   /* Keywords  - C-- */
   "int"     { return symbol(INT); }
   "bool" { return symbol(BOOL); }
   "void"    { return symbol(VOID); }
   "true"    { return symbol(TRUE); }
   "false"  { return symbol(FALSE); }
   "if" { return symbol(IF); }
   "else"    { return symbol(ELSE); }
   "while"   { return symbol(WHILE); }
   "return"  { return symbol(RETURN); }
   "cin" { return symbol(CIN); }
   "cout" { return symbol(COUT); }
   
 
   "(" { return symbol(LPAREN); }
   ")" { return symbol(RPAREN); }
   "[" { return symbol(LSQBKT); }
   "]" { return symbol(RSQBKT); }
   "{" { return symbol(LBRKT); }
   "}" { return symbol(RBRKT); }
   
   {Comment} {}
   {String}  { System.out.println("STRING"); }
   {Identifier} { return symbol(ID, yytext());}
   {NumericConstant} { return symbol(NUMERIC_CONSTANT, new Integer(Integer.parseInt(yytext()))); }
   {IdentifierError} { System.out.println("ERROR");error(yytext()); }
   {WhiteSpace} { /* Ignore */ }
 
 }
 
.|\n { System.out.println("ERROR");error(yytext());}