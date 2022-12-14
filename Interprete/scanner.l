%{


#include "parser.hpp"
extern YYSTYPE yylval;

const int _error = -1;
int line = 1;


%}


A               [a-zA-Z]
N               [0-9]

nigual          "!="
condi           "->"
true            "true"
false           "false"
or              "or"
and             "and"
not             "not"
result           "<<"

single          [;:?()=]

id              ({A}|_(_|{N})*{A})({A}|{N}|[_])*("'")?

sp              [ \t]
nl              \n


%%


{single}        return *yytext;

{true}          {
                    yylval.values.val = 1;
                    return _true;
                }

{false}         {
                    yylval.values.val = 0;
                    return _false;
                }

{condi}         return _condi;                
{or}            return _or;
{and}           return _and;
{not}           return _not;
{nigual}        return _nigual;
{result}        return _result;

{id}            {
                    yylval.values.var = yytext;
                    char *  aux = new char[strlen(yytext) + 1];
                    strcpy(aux, yytext);
                    yylval.values.var = aux;

                    return _id;
                }

{sp}            ;
{nl}            line++;
                
.               return _error;        

<<EOF>>         return 0;      


%%


int yywrap() {  return 1; }