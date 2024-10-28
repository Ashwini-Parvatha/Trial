%{
#include "sdt.tab.h"
#include <string.h>
#include <stdlib.h>
%}

%%

if          { return IF; }
else        { return ELSE; }
while       { return WHILE; }
true        { return TRUE; }
false       { return FALSE; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.sval = strdup(yytext); return IDENTIFIER; }
[0-9]+      { yylval.ival = atoi(yytext); return NUMBER; }
"+"         { return PLUS; }
"-"         { return MINUS; }
"*"         { return MUL; }
"/"         { return DIV; }
"=="        { return EQUAL; }
"!="        { return NEQUAL; }
"<"         { return LT; }
"<="        { return LE; }
">"         { return GT; }
">="        { return GE; }
"&&"        { return AND; }
"||"        { return OR; }
"!"         { return NOT; }
"="         { return ASSIGN; }
"("         { return LPAREN; }
")"         { return RPAREN; }
";"         { return SEMICOLON; }
[ \t\n]     { /* Ignore whitespace */ }
.           { return yytext[0]; }

%% 
