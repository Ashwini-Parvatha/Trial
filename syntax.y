%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *s);
int yylex(void);
%}

%token INT IF ELSE WHILE ID NUM FOR
%token EQ NE LE GE LT GT
%token PLUS MINUS MUL DIV ASSIGN INCR DECR
%token LPAREN RPAREN LBRACE RBRACE COMMA SEMICOLON

%%
Program: Declarations Statements
       ;

Declarations: Declaration Declarations
            ;

Declaration: INT VarList SEMICOLON
           | ID ASSIGN NUM SEMICOLON
           ;

VarList: ID COMMA VarList
       | ID
       ;
       
Statements: Statement Statements
          ;
          
Statement: SimpleStatement 
          | ComplexStatement
          ;

ComplexStatement: IF LPAREN Condition RPAREN SimpleStatement ELSE SimpleStatement
                | IF LPAREN Condition RPAREN Block ELSE SimpleStatement
                | IF LPAREN Condition RPAREN Block ELSE Block
                | IF LPAREN Condition RPAREN SimpleStatement ELSE Block
                | Loop
                ;

Loop: WHILE LPAREN Condition RPAREN Block
    | WHILE LPAREN Condition RPAREN SimpleStatement
    | FOR LPAREN INT ID ASSIGN NUM SEMICOLON Condition SEMICOLON ID Opr RPAREN Block
    | FOR LPAREN ID ASSIGN NUM SEMICOLON Condition SEMICOLON ID Opr RPAREN Block
    | FOR LPAREN INT ID ASSIGN NUM SEMICOLON Condition SEMICOLON ID Opr RPAREN SimpleStatement
    | FOR LPAREN ID ASSIGN NUM SEMICOLON Condition SEMICOLON ID Opr RPAREN SimpleStatement
    ;

SimpleStatement: ID ASSIGN Expr SEMICOLON
               ;
               
Condition: Expr RelOp Expr
         ;

Opr: INCR
   | DECR
   ;
   
RelOp: EQ
     | NE
     | LE
     | GE
     | LT
     | GT
     ;

Expr: Expr PLUS Term
    | Expr MINUS Term
    | Term
    ;

Term: Term MUL Factor
    | Term DIV Factor
    | Factor
    ;

Factor: LPAREN Expr RPAREN
      | ID
      | NUM
      ;

Block: LBRACE Statements RBRACE
     ;

%% 

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main(void) {
    printf("Enter the code to be checked:\n");
    if (yyparse() == 0){
        printf("Syntactically Correct\n");
    }
    else{
        printf("Syntactically Incorrect\n");
    }
    return 0;
}
