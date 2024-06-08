%option noyywrap

%{

#include<bits/stdc++.h>

#include"symbol_table.h"

#include <fstream>

using namespace std;



int line_count=1;

int error_count=0;

symbol_table* st = new symbol_table();

ofstream logout;

ofstream tokenout;



string toUpper(string s){

	string news="";

	for(int i=0; i<s.size(); i++)

		news+=s[i]-'a'+'A';



	return news;

}







%}



KEYWORD "if"|"else"|"switch"|"case"|"for"|"do"|"while"|"int"|"float"|"char"|"double"|"void"|"default"|"break"|"return"|"continue"

WHITESPACE [ \t\f\r\v]+ 

LETTER [a-zA-Z]

DIGIT [0-9]

NEWLINE \n

FLOAT ({DIGIT}*(\.{DIGIT}+)|{DIGIT}+(\.{DIGIT}*))(E[+-]?{DIGIT}+)?

CHAR (\'[!-~]\')|(\'\\[ntarfbv0\"\'\\]\')



ADDOP "+"|"-"

MULOP "*"|"/"|"%"

INCOP "++"|"--"

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

RTHIRD("]")

COMMA [,]

SEMICOLON [;]



IDENTIFIER [_a-zA-Z][_a-zA-Z0-9]*



STRING \"([ -~]{-}["\n]|\\[\n])*\"



cha [ -~]

COMMENT ("//")((({cha}{-}[\'])+)(\\[\n])*)*

MULTICOMMENT ("/*")([\n]|("*"[^/])|{cha}{-}[*])*("*/")



ERROR \'[^\\]{cha}+\'?|\'\\[^(\'\"\\natrfbv0)]\'?|\'\'|\'{cha}*|({DIGIT}+)(E[+-]?{DIGIT}+)(\.{DIGIT}+)|{DIGIT}*(\.{DIGIT}+)*|[0-9][_a-zA-Z0-9]*|\"{cha}*|("\*"){cha}*







%%

{WHITESPACE}+ {}

{NEWLINE}   {

			line_count++;

}



{KEYWORD}	{

	tokenout<<"<"<<toUpper(yytext)<<"> ";

	logout<<"Line# "<<line_count<<": TOKEN <"<<toUpper(yytext)<<"> Lexeme "<<yytext<<" found\n"<<endl;

}



{DIGIT}+ {

	tokenout<<"<CONST_INT, " <<yytext<<">";

	logout<<"Line# "<<line_count<<": TOKEN <CONST_INT> Lexeme "<<yytext<<" found\n"<<endl;

				

}



{FLOAT}  {

	tokenout<<"<CONST_FLOAT, " <<yytext<<">";

	logout<<"Line# "<<line_count<<": TOKEN <CONST_FLOAT> Lexeme "<<yytext<<" found\n"<<endl;

						

}

{CHAR}	{

	tokenout<<"<CONST_CHAR, " <<yytext<<">";

	logout<<"Line# "<<line_count<<": TOKEN <CONST_CHAR> Lexeme "<<yytext<<" found\n"<<endl;

}





"+" 	|

"-"  	{

			tokenout<<"<ADDOP, " <<yytext<<">";

			logout<<"Line# "<<line_count<<": TOKEN <ADDOP> Lexeme "<<yytext<<" found\n"<<endl;

		}



"*"		|

"/"		|

"%"		 {

			tokenout<<"<MULOP, " <<yytext<<">";

			logout<<"Line# "<<line_count<<": TOKEN <MULOP> Lexeme "<<yytext<<" found\n"<<endl;

		}



{INCOP} {

			tokenout<<"<INCOP, " <<yytext<<">";

			logout<<"Line# "<<line_count<<": TOKEN <INCOP> Lexeme "<<yytext<<" found\n"<<endl;



		}

{RELOP} {

			tokenout<<"<RELOP, " <<yytext<<">";

			logout<<"Line# "<<line_count<<": TOKEN <RELOP> Lexeme "<<yytext<<" found\n"<<endl;

		}





{LOGICOP} {

			tokenout<<"<LOGICOP, " <<yytext<<">";

			logout<<"Line# "<<line_count<<": TOKEN <LOGICOP> Lexeme "<<yytext<<" found\n"<<endl;

		}



"=" {

			tokenout<<"<ASSIGNOP, " <<yytext<<">";

			logout<<"Line# "<<line_count<<": TOKEN <ASSIGNOP> Lexeme "<<yytext<<" found\n"<<endl;

		}



"!"		{

			tokenout<<"<NOT, " <<yytext<<">";

			logout<<"Line# "<<line_count<<": TOKEN <NOT> Lexeme "<<yytext<<" found\n"<<endl;

}



"("		{

			tokenout<<"<LPAREN, " <<yytext<<">";

			logout<<"Line# "<<line_count<<": TOKEN <LPAREN> Lexeme "<<yytext<<" found\n"<<endl;

}



")"		{

			tokenout<<"<RPAREN, " <<yytext<<">";

			logout<<"Line# "<<line_count<<": TOKEN <RPAREN> Lexeme "<<yytext<<" found\n"<<endl;

}



"{"		{

			tokenout<<"<LCURL, " <<yytext<<">";

			logout<<"Line# "<<line_count<<": TOKEN <LCURL> Lexeme "<<yytext<<" found\n"<<endl;

			st->enterScope(new scope_table(7));

}





"}"		{

			tokenout<<"<RCURL, " <<yytext<<">";

			logout<<"Line# "<<line_count<<": TOKEN <RCURL> Lexeme "<<yytext<<" found\n"<<endl;

			st->exitScope();

}

"["		{

			tokenout<<"<LSQUARE, " <<yytext<<">";

			logout<<"Line# "<<line_count<<": TOKEN <LSQUARE> Lexeme "<<yytext<<" found\n"<<endl;

}



"]"		{

			tokenout<<"<RSQUARE, " <<yytext<<">";

			logout<<"Line# "<<line_count<<": TOKEN <RSQUARE> Lexeme "<<yytext<<" found\n"<<endl;

}



","		{

			tokenout<<"<COMMA, " <<yytext<<">";

			logout<<"Line# "<<line_count<<": TOKEN <COMMA> Lexeme "<<yytext<<" found\n"<<endl;

}



";"		{

			tokenout<<"<SEMICOLON, " <<yytext<<">";

			logout<<"Line# "<<line_count<<": TOKEN <SEMICOLON> Lexeme "<<yytext<<" found\n"<<endl;

}



{IDENTIFIER} {

			tokenout<<"<ID, " <<yytext<<">";

			logout<<"Line# "<<line_count<<": TOKEN <ID> Lexeme "<<yytext<<" found\n"<<endl;



			bool flag = st->insert(yytext, "ID" );



			if(flag==true){

				string print= st->printAllScopeTable();

                logout<<print;

                logout<<endl;

			}

			else if(flag==false)

			{

				logout<<yytext<<"\talready exists in current ScopeTable"<<endl;

				logout<<endl;

			}

}

{STRING}  {

			tokenout<<"<STRING>";

			logout<<"Line# "<<line_count<<": TOKEN <STRING> Lexeme "<<yytext<<" found\n"<<endl;

			

}



{COMMENT} {

			logout<<"Line# "<<line_count<<": TOKEN <COMMENT> Lexeme "<<yytext<<" found\n"<<endl;

			

} 



{MULTICOMMENT} {

			logout<<"Line# "<<line_count<<": TOKEN <MULTICOMMENT> Lexeme "<<yytext<<" found\n"<<endl;

			

} 



{ERROR} {

	logout << "Error at line no " <<line_count<< "lexical error"  << endl;

	error_count++;

}



%%



int main(int argc,char *argv[]){



	if(argc!=2){

		cout<<"Please provide input file name and try again\n";

		return 0;

	}



	FILE *fin=fopen(argv[1],"r");

	if(fin==NULL){

		cout<<"Cannot open specified file\n";

		return 0;

	}



	st->enterScope(new scope_table(7));

	logout.open("log.txt");

	tokenout.open("token.txt");



	yyin= fin;

	yylex();

	fclose(yyin);

	tokenout.close();

	logout.close();



	return 0;

}