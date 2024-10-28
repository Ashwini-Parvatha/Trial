%{
#include "syntax.tab.h"
%}

%%

"int" { return INT; }
"if" { return IF; }
"else" { return ELSE; }
"while" { return WHILE; }
"for" { return FOR; }
[0-9]+ { yylval = atoi(yytext); return NUM; }
[a-zA-Z_][a-zA-Z_0-9]* { return ID; }

"==" { return EQ; }
"!=" { return NE; }
"<=" { return LE; }
">=" { return GE; }
"<" { return LT; }
">" { return GT; }
"++" { return INCR; }
"--" { return DECR; }

"+" { return PLUS; }
"-" { return MINUS; }
"*" { return MUL; }
"/" { return DIV; }
"=" { return ASSIGN; }

"(" { return LPAREN; }
")" { return RPAREN; }
"{" { return LBRACE; }
"}" { return RBRACE; }
"," { return COMMA; }
";" { return SEMICOLON; }

[ \t\n]+ { /* Ignore whitespaces */ }

. { printf("Unknown character: %s\n", yytext); exit(1); }

%%

int yywrap(void) {
    return 1;
}
