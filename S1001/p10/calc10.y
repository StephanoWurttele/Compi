%{
    #include <stdio.h>
    #include <ctype.h>
%}

%token NUMBER
%token EOL
%start command


%%
command:
       | command exp EOL {printf("Answer is %d\n",$2);} 
       | command error EOL { yyerrok; }
                    ;
exp: exp opsuma term {if ($2 == '+' ) { $$ = $1+$3; } else { $$ = $1-$3;}
    }
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
int yyerror(const char *s){
  extern int yylineno;
  printf("0\n");
}

yywrap(){
  return(1);
}
