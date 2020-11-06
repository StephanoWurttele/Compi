%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
char* caracteresInversos(char* x);
char* operatorAnds(char* x, char* y);
char* operatorNumerals(char* x, char* y);
%}

%union {
	int ival;
	float fval;
	char* word;
}

%token<ival> T_INT
%token<fval> T_FLOAT
%token<word> T_STRING

%token T_PLUS T_MINUS T_MULTIPLY T_DIVIDE T_LEFT T_RIGHT 
%token T_NEWLINE T_QUIT

%token T_NOT T_ANDS T_NUMERALS

%left T_PLUS T_MINUS
%left T_MULTIPLY T_DIVIDE

%left T_NOT
%left T_ANDS
%left T_NUMERALS

%type<ival> expression
%type<fval> mixed_expression
%type<word> expressionString 

%start calculation

%%

calculation:
	   | calculation line
;

line: T_NEWLINE
    | mixed_expression T_NEWLINE { printf("\tResult: %f\n", $1);}
    | expression T_NEWLINE 		 { printf("\tResult: %i\n", $1); }
	| expressionString T_NEWLINE { printf("\tResult: %s\n", $1); }
    | T_QUIT T_NEWLINE 			 { printf("bye!\n"); exit(0); }
	| T_QUIT					 { printf("bye!\n"); exit(0); }
;

mixed_expression: T_FLOAT                 		 	 { $$ = $1; } 
	  | mixed_expression T_PLUS mixed_expression	 { $$ = $1 + $3; }
	  | mixed_expression T_MINUS mixed_expression	 { $$ = $1 - $3; }
	  | mixed_expression T_MULTIPLY mixed_expression { $$ = $1 * $3; }
	  | mixed_expression T_DIVIDE mixed_expression	 { $$ = $1 / $3; }
	  | T_LEFT mixed_expression T_RIGHT		 	 { $$ = $2; }
	  | expression T_PLUS mixed_expression	 	 { $$ = $1 + $3; }
	  | expression T_MINUS mixed_expression	 	 { $$ = $1 - $3; }
	  | expression T_MULTIPLY mixed_expression 	 { $$ = $1 * $3; }
	  | expression T_DIVIDE mixed_expression	 { $$ = $1 / $3; }
	  | mixed_expression T_PLUS expression	 	 { $$ = $1 + $3; }
	  | mixed_expression T_MINUS expression	 	 { $$ = $1 - $3; }
	  | mixed_expression T_MULTIPLY expression 	 { $$ = $1 * $3; }
	  | mixed_expression T_DIVIDE expression	 { $$ = $1 / $3; }
	  | expression T_DIVIDE expression		 	 { $$ = $1 / (float)$3; }
;

expression: T_INT				{ $$ = $1; }
	  | expression T_PLUS expression	{ $$ = $1 + $3; }
	  | expression T_MINUS expression	{ $$ = $1 - $3; }
	  | expression T_MULTIPLY expression	{ $$ = $1 * $3; }
	  | T_LEFT expression T_RIGHT		{ $$ = $2; }
;

expressionString: T_STRING { $$ = $1; }
	  | T_NOT expressionString 		{ $$ = caracteresInversos($2); }
	  | expressionString T_ANDS expressionString  	 {$$ = operatorAnds($1,$3); }
	  | expressionString T_NUMERALS expressionString {$$ = operatorNumerals($1,$3); }
	  | T_LEFT expressionString T_RIGHT		{ $$ = $2; }
;

%%

int main() {
	yyin = stdin;

	do {
		yyparse();
	} while(!feof(yyin));

	return 0;
}

char* caracteresInversos(char* x){
	char* nuevaCadena = malloc((strlen(x)+1)*sizeof(char));
	for(int i = 0; i < strlen(x); i++){
		if(97 <= x[i] && x[i] <= 122){
			nuevaCadena[i] = toupper(x[i]);	
		}else{
			nuevaCadena[i] = tolower(x[i]);
		}	
	}
	return nuevaCadena;
}

char* operatorAnds(char* x, char* y){
	char* nuevaCadena = malloc((strlen(x)+strlen(y)+1)*sizeof(char));
	strcat(nuevaCadena,x);
	strcat(nuevaCadena,y);
	for(int i = 0; i <strlen(nuevaCadena); i++){
		nuevaCadena[i] = tolower(nuevaCadena[i]);
	}
	return nuevaCadena;
}
char* operatorNumerals(char* x, char* y){
	int i;
	int index = 0;
	int a = 0;
	char* caracteres = malloc((strlen(x)+1)*sizeof(char));
	for(i = 0; i < strlen(x); i++){
		char* nueva = malloc((strlen(y)+1)*sizeof(char));
		for(int j = 0; j < strlen(y); j++){
			if(j < strlen(x)){
				nueva[j] = x[j+i]; 
			}
		}
		printf("!%s!",nueva);
		if(strcmp(nueva, y) == 0){
			int cont = 0;
			for(int m = index; m < i; m++){
				caracteres[a] = x[index]; 
				index += 1;
				a += 1;
			}
			index += strlen(y);
		}
	}
	for(int k = index; k < strlen(x); k++){
		caracteres[a] = x[k];
		a++;
	}
	return caracteres;
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}
