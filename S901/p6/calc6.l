%{
#include <stdio.h>
#include "y.tab.h"
%}


%%
" "       ;

[0-9]+(\.[0-9]+)? {
                      yylval.fval = atof(yytext);
                      return(NUMBER);
                      }
\n {return 0;}

.          {
            yylval.charVal = yytext[0];
            return(yytext[0]);
           }
