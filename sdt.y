%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int yylineno;

void emit(char *op, char *arg1, char *arg2, char *result);
void print_tac(char *op, char *arg1, char *arg2, char *result);
char* new_temp();

void yyerror(const char *s);
int yywrap(void);
%}

%union {
    char *sval; // for identifiers and strings
    int ival;   // for integers
}

%token <sval> IDENTIFIER NUMBER
%token ASSIGN PLUS MINUS MUL DIV LPAREN RPAREN SEMICOLON
%token TRUE FALSE IF ELSE WHILE
%token EQUAL NEQUAL LT LE GT GE OR AND NOT

%type <sval> Assignment BooleanAssignment BooleanExpression Expression

%left PLUS MINUS
%left MUL DIV
%nonassoc EQUAL NEQUAL 
%nonassoc LT LE GT GE   
%left AND
%left OR
%right UMINUS
%right NOT

%%

Program:
    Statements
;

Statements:
    Statement
    | Statements Statement
;

Statement:
    Assignment SEMICOLON
    | BooleanAssignment SEMICOLON
;

Assignment:
    IDENTIFIER ASSIGN Expression {
        emit("=", $3, NULL, $1); 
    }
;

BooleanAssignment: 
    IDENTIFIER ASSIGN BooleanExpression {
        emit("=", $3, NULL, $1); 
    }
;

BooleanExpression:
    IDENTIFIER EQUAL IDENTIFIER {
        char *temp = new_temp();
        emit("==", $1, $3, temp);
        $$ = temp; 
    }
    | IDENTIFIER NEQUAL IDENTIFIER {
        char *temp = new_temp();
        emit("!=", $1, $3, temp);
        $$ = temp; 
    }
    | IDENTIFIER LT IDENTIFIER {
        char *temp = new_temp();
        emit("<", $1, $3, temp);
        $$ = temp; 
    }
    | IDENTIFIER LE IDENTIFIER {
        char *temp = new_temp();
        emit("<=", $1, $3, temp);
        $$ = temp; 
    }
    | IDENTIFIER GT IDENTIFIER {
        char *temp = new_temp();
        emit(">", $1, $3, temp);
        $$ = temp;
    }
    | IDENTIFIER GE IDENTIFIER {
        char *temp = new_temp();
        emit(">=", $1, $3, temp);
        $$ = temp; 
    }
    | BooleanExpression AND BooleanExpression {
        char *temp = new_temp();
        emit("&&", $1, $3, temp);
        $$ = temp; 
    }
    | BooleanExpression OR BooleanExpression {
        char *temp = new_temp();
        emit("||", $1, $3, temp);
        $$ = temp; 
    }
    | NOT BooleanExpression {
        char *temp = new_temp();
        emit("!", $2, NULL, temp);
        $$ = temp; 
    }
;

Expression:
    Expression PLUS Expression {
        char *temp = new_temp();
        emit("+", $1, $3, temp);
        $$ = temp; 
    }
    | Expression MINUS Expression {
        char *temp = new_temp();
        emit("-", $1, $3, temp);
        $$ = temp; 
    }
    | Expression MUL Expression {
        char *temp = new_temp();
        emit("*", $1, $3, temp);
        $$ = temp; 
    }
    | Expression DIV Expression {
        char *temp = new_temp();
        emit("/", $1, $3, temp);
        $$ = temp; 
    }
    | MINUS Expression %prec UMINUS {
        char *temp = new_temp();
        emit("-", $2, NULL, temp);
        $$ = temp; 
    }
    | LPAREN Expression RPAREN {
        $$ = $2; 
    }
    | IDENTIFIER {
        $$ = $1;
    }
    | NUMBER {
        char *temp = new_temp();
        sprintf(temp, "%d", $1);
        $$ = temp; 
    }
;

%%

// Function to emit the 3 address code 
void emit(char *op, char *arg1, char *arg2, char *result) {
    if (arg2) {
        printf("%s = %s %s %s\n", result, arg1, op, arg2);
    } else {
        if (strcmp(op, "-") == 0) {
            printf("%s = %s %s\n", result, op, arg1); 
        } else if (strcmp(op, "!") == 0) {
            printf("%s = %s %s\n", result, op, arg1); 
        } else {
            printf("%s = %s\n", result, arg1); 
        }
    }
}

// Temporary variable generation
char* new_temp() {
    static int count = 1;
    char *temp = malloc(20);
    sprintf(temp, "t%d", count++);
    return temp;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int yywrap(void) {
    return 1;
}

int main() {
    printf("Enter the assignment / boolean statements : ");
    yyparse();
    return 0;
}
