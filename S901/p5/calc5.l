%{
 
#include <stdio.h>
#include "y.tab.h"
int c;
extern int yylval;
%}
%%
" "       ;
[0-9]+    {
            yylval = atoi(yytext);
            return(NUMBER);
          }
\n        {return 0;}

.         {
            yylval = yytext[0];
            return(yytext[0]);
          }
