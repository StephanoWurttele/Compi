%{
    #include <stdio.h>
    #include <ctype.h>
%}

%token NUMBER

%%
command: exp {printf("%d\n",$1);}
                    ;
exp: exp opsuma term {if ($2 == '+' ) { $$ = $1+$3; } else { $$ = $1-$3;};}
    |term {$$=$1;}
    ;

opsuma: '+' | '-';

term: term opmult factor {$$ = $1*$3;}
    | factor {$$ = $1;};

opmult: '*'

factor: NUMBER  {$$ = $1;}
      | '(' exp ')' { $$ = $2; }
      ;
%%
main(){
    return yyparse();
}
int yylex(void ){
    int c;
    while ((c=getchar())==' ');
    if(isdigit(c)){
        ungetc(c,stdin);
        scanf("%d",&yylval);
        return (NUMBER);        
    }
    else{
      ungetc(c, stdin);
      scanf("%c", &yylval);
    }
    if (c == '\n') return 0;
    return (c);
}
int yyerror(char *s){
    fprintf(stderr,"%s\n",s);
}
