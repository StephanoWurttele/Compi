%{
    #include <stdio.h>
    #include <ctype.h>
%}

%union
{
  int intValue;
  double fval;
  char charVal;
}
%token NUMBER
%type<fval> exp
%type<fval> term
%type<fval> factor
%type<fval> NUMBER
%type<charVal> opsuma
%type<charVal> opmult

%start command

%%
command: exp {printf("Result = %.2f\n",$1);}
                    ;
exp: exp opsuma term { $$ = ($2 == '+' ) ? $1+$3 : $1-$3;}
    |term {$$=$1;}
    ;

opsuma: '+' | '-' ;

term: term opmult factor {$$ = $1*$3;}
    | factor {$$ = $1;};

opmult: '*'

factor: NUMBER  {$$ = $1;}
      | '(' exp ')' { $$ = $2; }
      ;
%%
main(){
  do {
    yyparse();
  } while (!feof(stdin));
}
int yyerror(char *s){
    fprintf(stderr,"%s\n",s);
}

yywrap(){
  return(1);
}
