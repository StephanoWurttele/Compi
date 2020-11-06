%{
 
#include <stdio.h>
#include "y.tab.h"
int yylineno;
extern int yylval;
%}
%option yylineno
%%
" "       ;
[0-9]+    {
            yylval = atoi(yytext);
            return(NUMBER);
          }
\n        {
            yylineno++;
            yylval = yytext[0];
            return(EOL);
          }

.         {
            yylval = yytext[0];
            return(yytext[0]);
          }
