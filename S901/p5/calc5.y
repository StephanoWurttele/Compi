%{
    #include <stdio.h>
    #include <ctype.h>
%}

%token NUMBER
%start command


%%
command: exp {printf("%d\n",$1);}
                    ;
exp: exp opsuma term {if ($2 == '+' ) { $$ = $1+$3; } else { $$ = $1-$3;}
    };
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
