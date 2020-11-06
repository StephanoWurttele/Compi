%{
    #include <stdio.h>
    #include <ctype.h>

    struct Node{
      int val;
      int result;
      struct Node* right;
      struct Node* left;
    };

    struct Node* initNode(char value){
      struct Node* node = (struct Node*) malloc (sizeof(struct Node));
      node->val = value;
      node->right = NULL;
      node->left = NULL;
      return node;
    }


    void printTree(struct Node* nodo, int space){
      if(nodo == NULL) return(NULL);
      space += 10;
      printTree(nodo->right,space);
      printf("\n");
      for(int i=10; i<space; i++){
        printf(" ");
      };
      if(nodo->left==NULL && nodo->right==NULL)
        printf("%d ", nodo->result);
      else printf("%c ", (char)nodo->val);
        printTree(nodo->left,space);
      printf("\n");
    }

%}

%union
{
  struct Node* nodo;
  int numero;
  char operador;
}
%token NUMBER
%type<nodo> exp
%type<nodo> term
%type<nodo> factor
%type<operador> opsuma
%type<numero> NUMBER
%type<operador> opmult

%start command
%%
command: exp {printf("%d\n",$1->result);
              printTree($1, 2);}
                    ;
exp: exp opsuma term {if ($2 == '+' ) { 
                        $$ = initNode('+');
                        $$->left = $1;
                        $$->right = $3;
                        $$->result= $1->result + $3->result;
                     }else { 
                        $$ = initNode('-');
                        $$->left = $1;
                        $$->right = $3;
                        $$->result = $1->result - $3->result;
                     }
    };
    |term {$$=$1;}
    ;

opsuma: '+' | '-' ;

term: term opmult factor {
                          $$ = initNode('*');
                          $$->left = $1;
                          $$->right = $3;
                          $$->result = $1->result * $3->result;
                         }
    | factor {$$ = $1;};

opmult: '*'

factor: NUMBER  {
                  $$ = initNode(' ');
                  $$->result = $1;
                }
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
