%{
#include "tokens.h"
#include "string.h"

int current_line_number = 0;

union {
    struct{
        int value;
        int line_number;
    } integer_value;
    struct{
        char *value;
        int line_number;
    } string_value;
    int line_number;
} yylval;

%}

%x COMMENT
DIGIT [0-9]

%%
"&&"                {return AND;}
"||"                {return OR;}
"!"                 {return NOT;}
and                 {return AND_LITERAL;}
class               {return CLASS;}
do                  {return DO;}
while               {return WHILE;}
false               {return FALSE;}
true                {return TRUE;}
for                 {return FOR;}
if                  {return IF;}
else                {return ELSE;}
"+"                 {return ADD;}
"-"                 {return SUB;}
"*"                 {return MUL;}
"/"                 {return DIV;}
"("                 {return OPEN_PARAENTHESES;}
")"                 {return CLOSE_PARAENTHESES;}
"["                 {return OPEN_BRACKET;}
"]"                 {return CLOSE_BRACKET;}
"{"                 {return OPEN_BRACES;}
"}"                 {return CLOSE_BRACES;}
"."                 {return PERIOD;}
";"                 {return COMMA;}
"=="                {return EQUALS;}
"!="                {return NOT_EQUALS;}
"<>"                {return GREATER_LESSER;}
">="                {return GREATER_EQUALS;}
"<="                {return LESSER_EQUALS;}
"="                 {return ASSIGN;}
";"                 {return SEMICOLON;}
{DIGIT}+            {yylval.integer_value.value = atoi(yytext);
                     yylval.integer_value.line_number = current_line_number++;
                     return INTERGER_LITERAL;}
[a-zA-Z][a-zA-Z]*   {yylval.string_value.value = malloc(sizeof(char) * (strlen(yytext)+1));
                     strcpy(yylval.string_value.value,yytext);
                     yylval.string_value.line_number = current_line_number++;
                     return IDENTIFIER;}
" "                 {}
\n                  {current_line_number++;}
\t                  {}
"/*"                {BEGIN(COMMENT);}
<COMMENT>"*/"       {BEGIN(INITIAL);}
<COMMENT>.          {}
<COMMENT>\n         {}
"//"[^\n]*\n        {}
%%

int yywrap(){return 0;}

int main(){
    yylex();
    return 0;
}
