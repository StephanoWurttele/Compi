%{
  #include <stdio.h>
  #include <ctype.h>
%}

%token a

%%

command: S {printf("%c\n",$1);}

S : A { $$ = $1; }
  | B { $$ = $1; }
  ;

A : a ;

B: a ;

%%

main(){
  return yyparse();
}

int yylex(void ){
    int c;
    while ((c=getchar())==' ');
    if(c == "a"){
        ungetc(c,stdin);
        scanf("%c",&yylval);
        return (a);        
    }
    if (c == '\n') return 0;
    return (c);
}
int yyerror(char *s){
    fprintf(stderr,"%s\n",s);
}
