%{
#include <stdio.h>
#include "y.tab.h"
int c;
%}
%%
" "       ;
[0-9]+    {
            yylval.numero = atoi(yytext);
            return(NUMBER);
          }
\n        {return 0;}

.         {
            yylval.operador = yytext[0];
            return(yytext[0]);
          }
