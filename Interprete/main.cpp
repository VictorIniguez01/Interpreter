#include "parser.hpp"
#include <iostream>
#include <string>



extern FILE *yyin;          
extern int yyparse();       
extern char *yytext;
extern int line;     


int main(){

    std::string archivo;

    printf("Nombre del archivo de texto: "); std::cin >> archivo;
    yyin = fopen(archivo.c_str(), "r");
    
    if(yyin == nullptr) {
        printf("Archivo no encontrado\n");
        return false;
    }

    if(!yyparse()) printf("OK ");
    else printf("Error[%s] en la linea : %i", yytext, line);

    fclose(yyin);

    return 0;
}