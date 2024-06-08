%option noyywrap

%{

#include<bits/stdc++.h>

#include"symbol_info.h"

#include "y.tab.h"



using namespace std;


extern YYSTYPE yylval;
int lineCount=1;

int errorCount=0;

void yyerror(char *);



string toUpper(string s){

	string news="";
	for(int i=0; i<s.size(); i++)
		news+=s[i]-'a'+'A';

	return news;
}






%}
WHITESPACE [ \t\f\r\v]+ 
LETTER [a-zA-Z]
DIGIT [0-9]
DIGITS {DIGIT}+
NEWLINE [\n]
ADDOP "+"|"-"
MULOP "*"|"/"|"%"
INCOP "++"
DECOP "--"
RELOP "=="|"!="|"<"|"<="|">"|">="
ASSIGNOP "="
LOGICOP "&&"|"||"
BITOP "&"|"|"|"^"|"<<"|">>"
NOT [!]
LPAREN [(]
RPAREN [)]
LCURL [{]
RCURL [}]
LTHIRD ("[")
RTHIRD ("]")
COMMA [,]
SEMICOLON [;]
IDENTIFIER [_a-zA-Z][_a-zA-Z0-9]*
SINGLECOMMENT ("//")([^\n\r]*(\\\n)*)*
MULTICOMMENT ("/*")(((\*[^\/])|[\n]|[^\*])*)("*/")

%%

{WHITESPACE}+ {}

{NEWLINE}   {

		lineCount++;

}




"if" {
	symbol_info *s = new symbol_info(yytext, "IF");
	yylval = (YYSTYPE)s;
	return IF; 
	
	}
"else" {
	symbol_info *s = new symbol_info(yytext, "ELSE");
	yylval = (YYSTYPE)s;
	return ELSE;
	
	 }
"for" {
	symbol_info *s = new symbol_info(yytext, "FOR");
	yylval = (YYSTYPE)s;
	return FOR; 
	
	}
"do" {
	symbol_info *s = new symbol_info(yytext, "DO");
	yylval = (YYSTYPE)s;
	return DO; 
	
	}
"while" {
	symbol_info *s = new symbol_info(yytext, "WHILE");
	yylval = (YYSTYPE)s;
	return WHILE; 
	}
"int" {
	symbol_info *s = new symbol_info(yytext, "INT");
	yylval = (YYSTYPE)s;
	return INT; 
	}

"char" {
	symbol_info *s = new symbol_info(yytext, "CHAR");
	yylval = (YYSTYPE)s;
	return CHAR; 
	}
"return" {
	symbol_info *s = new symbol_info(yytext, "RETURN");
	yylval = (YYSTYPE)s;
	return RETURN; 
	}
"void" {
	symbol_info *s = new symbol_info(yytext, "VOID");
	yylval = (YYSTYPE)s;
	return VOID; 
	}
"default" {
	symbol_info *s = new symbol_info(yytext, "DEFAULT");
	yylval = (YYSTYPE)s;
	return DEFAULT; 
	}
"continue" {
	symbol_info *s = new symbol_info(yytext, "CONTINUE");
	yylval = (YYSTYPE)s;
	return CONTINUE; 
	}
"println" {
	symbol_info *s = new symbol_info(yytext, "PRINTLN");
	yylval = (YYSTYPE)s;
	return PRINTLN; 
	}



{DIGITS} {
	symbol_info *s = new symbol_info(yytext, "CONST_INT");
	yylval = (YYSTYPE)s;
	return CONST_INT;

}









"+" 	|

"-"  	{

			symbol_info *s = new  symbol_info(yytext, "ADDOP");
			yylval = (YYSTYPE)s;
			return ADDOP; 

		}



"*"		|

"/"		|

"%"		 {

			symbol_info *s = new  symbol_info(yytext, "MULOP");
			yylval = (YYSTYPE)s;
			return MULOP; 

		}



{INCOP} {

			symbol_info *s = new symbol_info(yytext, "INCOP");
			yylval = (YYSTYPE)s;
			return INCOP;



		}
{DECOP} {

			symbol_info *s = new symbol_info(yytext, "DECOP");
			yylval = (YYSTYPE)s;
			return DECOP;



		}

{RELOP} {

			symbol_info *s = new symbol_info(yytext, "RELOP");
			yylval = (YYSTYPE)s;
			return RELOP;
		}





{LOGICOP} {

			symbol_info *s = new symbol_info(yytext, "LOGICOP");
			yylval = (YYSTYPE)s;
			return LOGICOP;
		}



"=" {

			symbol_info *s = new symbol_info(yytext, "ASSIGNOP");
			yylval = (YYSTYPE)s;
			return ASSIGNOP;

	}



"!"		{

			symbol_info *s = new symbol_info(yytext, "NOT");
			yylval = (YYSTYPE)s;
			return NOT;

}



"("		{

			symbol_info *s = new symbol_info(yytext, "LPAREN");
			yylval = (YYSTYPE)s;
			return LPAREN;

}



")"		{

			symbol_info *s = new symbol_info(yytext, "RPAREN");
			yylval = (YYSTYPE)s;
			return RPAREN;

}



"{"		{

			symbol_info *s = new symbol_info(yytext, "LCURL");
			yylval = (YYSTYPE)s;
			return LCURL;


}





"}"		{

			symbol_info *s = new symbol_info(yytext, "RCURL");
			yylval = (YYSTYPE)s;
			return RCURL;


}

"["		{

			symbol_info *s = new symbol_info(yytext, "LTHIRD");
			yylval = (YYSTYPE)s;
			return LTHIRD;

}



"]"		{

			symbol_info *s = new symbol_info(yytext, "RTHIRD");
			yylval = (YYSTYPE)s;
			return RTHIRD;

}



","		{

			symbol_info *s = new symbol_info(yytext, "COMMA");
			yylval = (YYSTYPE)s;
			return COMMA;

}



";"		{

			symbol_info *s = new symbol_info(yytext, "SEMICOLON");
			yylval = (YYSTYPE)s;
			return SEMICOLON;

}



{IDENTIFIER} {

			symbol_info *s = new symbol_info(yytext, "ID");
			yylval = (YYSTYPE)s;
			return ID;

}





{SINGLECOMMENT} {

		string str = yytext;
		for(int i=0; i<str.size(); i++){
			if(str[i]=='\n') lineCount++;
		}
		
			

} 



{MULTICOMMENT} {

		string str = yytext;
		for(int i=0; i<str.size(); i++){
			if(str[i]=='\n') lineCount++;
		}

			

}



. {
   	errorCount++;
}

%%





