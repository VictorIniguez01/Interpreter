%{


#include <stdio.h>
#include <iostream>
#include <map>
#include <string.h>

extern int line;
extern int yylex();
extern int yyerror(const char *);

using namespace std;


typedef map<string, int> table;

table attributes;


%}


%union{

    typedef struct{
        int val;
        char * var;
    } Values;

    Values values;
}

%token _condi _or _and _not _nigual _result

%token <values> _false _true _id

%start stseq

%type <values> quest argue prop clause atom



%%


stseq:      stseq ';' st
    |       st  ;

st:         assign
    |       output  ;

assign:     _id ':' quest {    attributes[$1.var] = $3.val;   } ;

quest:      argue '?' quest ':' quest{
                                        if(attributes[$1.var] == -1 || attributes[$3.var] == -1 || attributes[$5.var] == -1){
                                            printf("Error, alguna variable no tiene valor\n");
                                            return 1;
                                        }
                                        if(attributes[$1.var] == 0 )
                                            $$.val = $5.val; 
                                        else
                                            $$.val = $3.val;
                                     }
    |       argue { $$.val = $1.val; }  ;

argue:      prop _condi prop {
                                if(attributes[$1.var] == -1 || attributes[$3.var] == -1){
                                    printf("Error, alguna variable no tiene valor\n");
                                    return 1;
                                }
                                if(attributes[$1.var] == 0)
                                    $$.val = 1;
                                else if(attributes[$1.var] == 1 && attributes[$3.var] == 1)
                                    $$.val = 1;
                                else
                                    $$.val = 0;
                             }
    |       prop { $$.val = $1.val; }  ;

prop:       prop _or clause{
                                if(attributes[$1.var] == -1 || attributes[$3.var] == -1){
                                    printf("Error, alguna variable no tiene valor\n");
                                    return 1;
                                }
                                if(attributes[$1.var] == 1 || attributes[$3.var] == 1)
                                    $$.val = 1;
                                else
                                    $$.val = 0;
                            }
    |       clause { $$.val = $1.val; }  ;

clause:     clause _and atom {
                                if(attributes[$1.var] == -1 || attributes[$3.var] == -1){
                                    printf("Error, alguna variable no tiene valor\n");
                                    return 1;
                                }
                                if(attributes[$1.var] == 1 && attributes[$3.var] == 1)
                                    $$.val = 1;
                                else
                                    $$.val = 0;
                             }
    |       atom { $$.val = $1.val; }  ;

atom:       _not atom {
                        if(attributes[$2.var] == -1){
                            printf("Error, alguna variable no tiene valor\n");
                            return 1;
                        }
                        if(attributes[$2.var] == 0)
                            $$.val = 1;
                        else if(attributes[$2.var] == 1)
                            $$.val = 0;
                        }
    |       '(' quest ')' {
                            if(attributes[$2.var] == -1){
                                printf("Error, alguna variable no tiene valor\n");
                                return 1;
                            }
                            $$ = $2;
                           }
    |       _id {
                    if(attributes.find($1.var) == attributes.end())
                        attributes[$1.var] = -1;
                    else
                        $$.var = $1.var;
                }
    |       _false { $$.val = $1.val; }
    |       _true { $$.val = $1.val; } ;

output:     _result quest {
                            if(attributes[$2.var] == -1){
                                printf("Error, alguna variable no tiene valor\n");
                                return 1;
                            }
                            if(attributes[$2.var] == 1) printf("True\n");
                                else printf("False\n");
                          } ;


%%


int yyerror(const char *c) {    return 0;   }
