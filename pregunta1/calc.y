%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
char* reverse(char* input);
char* concatmin(char* input1, char* input2);
char* supress(char* x, char* y);
%}

%union {
	int ival;
	float fval;
	char* str;
}

%token<ival> T_INT
%token<fval> T_FLOAT
%token<str> T_STRING

%token T_PLUS T_MINUS T_MULTIPLY T_DIVIDE T_LEFT T_RIGHT 
%token T_NEWLINE T_QUIT

%token T_REVERSE T_CONCATMIN T_SUPRESS

%left T_PLUS T_MINUS
%left T_MULTIPLY T_DIVIDE

%left T_REVERSE
%left T_CONCATMIN
%left T_SUPRESS

%type<ival> expression
%type<fval> mixed_expression
%type<str> string_expression 

%start calculation

%%

calculation:
	   | calculation line
;

line: T_NEWLINE
    | mixed_expression T_NEWLINE { printf("\tResult: %f\n", $1);}
    | expression T_NEWLINE 		 { printf("\tResult: %i\n", $1); }
	| string_expression T_NEWLINE { printf("\tResult: %s\n", $1); }
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

string_expression: T_STRING { $$ = $1; }
	  | T_REVERSE string_expression 		{ $$ = reverse($2); }
	  | string_expression T_CONCATMIN string_expression  	 {$$ = concatmin($1,$3); }
	  | string_expression T_SUPRESS string_expression {$$ = supress($1,$3); }
	  | T_LEFT string_expression T_RIGHT	{ $$ = $2; }
;

%%

int main() {
	yyin = stdin;

	do {
		yyparse();
	} while(!feof(yyin));

	return 0;
}

char* reverse(char* input){
	char* response = malloc((strlen(input)+1)*sizeof(char));
	for(int i = 0; i < strlen(input); ++i){
		if(97 <= input[i] && input[i] <= 122) { response[i] = toupper(input[i]); }
		else { response[i] = tolower(input[i]); }	
	}
	return response;
}

char* concatmin(char* input1, char* input2){
	char* response = malloc((strlen(input1)+strlen(input2)+1)*sizeof(char));
	strcat(response,input1);
	strcat(response,input2);
	for(int i = 0; i <strlen(response); ++i)
		response[i] = tolower(response[i]);
	return response;
}
char* supress(char* input1, char* input2){
	int temp = 0;
	char* primera = malloc((strlen(input1)+1)*sizeof(char));
	// casi funciona profe, estuve cerca
	// for(int i = 0; i < strlen(input1); ++i){
	// 	char* nueva = malloc((strlen(input2)+1)*sizeof(char));
	// 	for(int j = 0; j < strlen(input2); ++j){
	// 		if(j < strlen(input1)){
	// 			nueva[j] = input1[j+i]; 
	// 		}
	// 	}
	// }
	return primera;
}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}
