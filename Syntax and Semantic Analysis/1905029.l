%option noyywrap

%{

#include<bits/stdc++.h>

#include"symbol_info.h"

#include "y.tab.h"



using namespace std;


extern YYSTYPE yylval;
int lineCount=1;

int errorCount=0;

extern FILE *logout;
void yyerror(char *);



string toUpper(string s){

	string news="";
	for(int i=0; i<s.size(); i++)
		news+=s[i]-'a'+'A';

	return news;
}

string toChar(string s)
{
	string str="";
	int i;
	for(i=1; i<s.size()-1; i++)
	{
		if(s[i]=='\\'&&i+1<s.size()-1)
		{
			if(s[i+1]=='n')
			{
				i++;
				str+='\n';
			}
			else if(s[i+1]=='v')
			{
				i++;
				str+='\v';
			}
			else if(s[i+1]=='t')
			{
				i++;
				str+='\t';
			}
			else if(s[i+1]=='r')
			{
				i++;
				str+='\r';
			}
			
			else if(s[i+1]=='b')
			{
				i++;
				str+='\b';
			}
			else if(s[i+1]=='a')
			{
				i++;
				str+='\a';
			}
			else if(s[i+1]=='f')
			{
				i++;
				str+='\f';
			}
			
			else
			{
				i++;
				str+=s[i];
			}
		}
		else if(s[i]!='\\')
		{
			str+=s[i];
		}
	}
	return str;
}




%}
WHITESPACE [ \t\f\r\v]+ 
LETTER [a-zA-Z]
DIGIT [0-9]
DIGITS {DIGIT}+
NEWLINE [\n]
FLOAT (({DIGIT}*(\.{DIGIT}+))|({DIGIT}+(\.{DIGIT}*))|{DIGITS})(E[+-]?{DIGIT}+)?
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
INVALID_SUFFIX_OR_PREFIX {DIGITS}{IDENTIFIER}
ILL_FORMED {DIGIT}+(E[+-]?{DIGIT}+)(.{FLOAT})*
UNFINISHED_COMMENT ("/*")(((\*[^\/])|[\n]|[^\*])*)
%%

{WHITESPACE}+ {}

{NEWLINE}   {

		lineCount++;

}




"if" {
	fprintf(logout,"Line# %d: Token <%s> Lexeme %s found\n",lineCount,toUpper(yytext).c_str(),yytext); 
	//fprintf(logout,"Line# %d: Token <CONST_INT> Lexeme %s found\n",lineCount,yytext);
	symbol_info *s = new symbol_info(yytext, "IF");
	yylval = (YYSTYPE)s;
	s->setStartLine(lineCount);
	s->setFinishLine(lineCount);
	return IF; 
	
	}
"else" {
	fprintf(logout,"Line# %d: Token <%s> Lexeme %s found\n",lineCount,toUpper(yytext).c_str(),yytext); 
	symbol_info *s = new symbol_info(yytext, "ELSE");
	yylval = (YYSTYPE)s;
	s->setStartLine(lineCount);
	s->setFinishLine(lineCount);
	return ELSE;
	
	 }
"for" {
	fprintf(logout,"Line# %d: Token <%s> Lexeme %s found\n",lineCount,toUpper(yytext).c_str(),yytext); 
	symbol_info *s = new symbol_info(yytext, "FOR");
	yylval = (YYSTYPE)s;
	s->setStartLine(lineCount);
	s->setFinishLine(lineCount);
	return FOR; 
	
	}
"do" {
	fprintf(logout,"Line# %d: Token <%s> Lexeme %s found\n",lineCount,toUpper(yytext).c_str(),yytext); 
	symbol_info *s = new symbol_info(yytext, "DO");
	yylval = (YYSTYPE)s;
	s->setStartLine(lineCount);
	s->setFinishLine(lineCount);
	return DO; 
	
	}
"while" {
	fprintf(logout,"Line# %d: Token <%s> Lexeme %s found\n",lineCount,toUpper(yytext).c_str(),yytext); 
	symbol_info *s = new symbol_info(yytext, "WHILE");
	yylval = (YYSTYPE)s;
	s->setStartLine(lineCount);
	s->setFinishLine(lineCount);
	return WHILE; 
	}
"int" {
	fprintf(logout,"Line# %d: Token <%s> Lexeme %s found\n",lineCount,toUpper(yytext).c_str(),yytext); 
	symbol_info *s = new symbol_info(yytext, "INT");
	yylval = (YYSTYPE)s;
	s->setStartLine(lineCount);
	s->setFinishLine(lineCount);
	return INT; 
	}
"float" {
	fprintf(logout,"Line# %d: Token <%s> Lexeme %s found\n",lineCount,toUpper(yytext).c_str(),yytext); 
	symbol_info *s = new symbol_info(yytext, "FLOAT");
	yylval = (YYSTYPE)s;
	s->setStartLine(lineCount);
	s->setFinishLine(lineCount);
	return FLOAT; 
	}
"double" {
	fprintf(logout,"Line# %d: Token <%s> Lexeme %s found\n",lineCount,toUpper(yytext).c_str(),yytext); 
	symbol_info *s = new symbol_info(yytext, "DOUBLE");
	yylval = (YYSTYPE)s;
	s->setStartLine(lineCount);
	s->setFinishLine(lineCount);
	return DOUBLE; 
	}
"char" {
	fprintf(logout,"Line# %d: Token <%s> Lexeme %s found\n",lineCount,toUpper(yytext).c_str(),yytext); 
	symbol_info *s = new symbol_info(yytext, "CHAR");
	yylval = (YYSTYPE)s;
	s->setStartLine(lineCount);
	s->setFinishLine(lineCount);
	return CHAR; 
	}
"return" {
	fprintf(logout,"Line# %d: Token <%s> Lexeme %s found\n",lineCount,toUpper(yytext).c_str(),yytext); 
	symbol_info *s = new symbol_info(yytext, "RETURN");
	yylval = (YYSTYPE)s;
	s->setStartLine(lineCount);
	s->setFinishLine(lineCount);
	return RETURN; 
	}
"void" {
	fprintf(logout,"Line# %d: Token <%s> Lexeme %s found\n",lineCount,toUpper(yytext).c_str(),yytext); 
	symbol_info *s = new symbol_info(yytext, "VOID");
	yylval = (YYSTYPE)s;
	s->setStartLine(lineCount);
	s->setFinishLine(lineCount);
	return VOID; 
	}
"default" {
	fprintf(logout,"Line# %d: Token <%s> Lexeme %s found\n",lineCount,toUpper(yytext).c_str(),yytext); 
	symbol_info *s = new symbol_info(yytext, "DEFAULT");
	yylval = (YYSTYPE)s;
	s->setStartLine(lineCount);
	s->setFinishLine(lineCount);
	return DEFAULT; 
	}
"continue" {
	fprintf(logout,"Line# %d: Token <%s> Lexeme %s found\n",lineCount,toUpper(yytext).c_str(),yytext); 
	symbol_info *s = new symbol_info(yytext, "CONTINUE");
	yylval = (YYSTYPE)s;
	s->setStartLine(lineCount);
	s->setFinishLine(lineCount);
	return CONTINUE; 
	}
"println" {
	fprintf(logout,"Line# %d: Token <%s> Lexeme %s found\n",lineCount,toUpper(yytext).c_str(),yytext); 
	symbol_info *s = new symbol_info(yytext, "PRINTLN");
	yylval = (YYSTYPE)s;
	s->setStartLine(lineCount);
	s->setFinishLine(lineCount);
	return PRINTLN; 
	}



{DIGITS} {

	//fprintf(tokenout,"<CONST_INT, %s>\n", yytext);

	fprintf(logout,"Line# %d: Token <CONST_INT> Lexeme %s found\n",lineCount,yytext);
	symbol_info *s = new symbol_info(yytext, "CONST_INT");
	yylval = (YYSTYPE)s;
	s->setStartLine(lineCount);
	s->setFinishLine(lineCount);
	return CONST_INT;

}



{FLOAT}  {

	//fprintf(tokenout,"<CONST_FLOAT, %s>\n", yytext);
	fprintf(logout,"Line# %d: Token <CONST_FLOAT> Lexeme %s found\n",lineCount,yytext);
	symbol_info *s = new  symbol_info(yytext, "CONST_FLOAT");
	yylval = (YYSTYPE)s;
	s->setStartLine(lineCount);
	s->setFinishLine(lineCount);
	return CONST_FLOAT; 
						

}






"+" 	|

"-"  	{

			//fprintf(tokenout,"<ADDOP, %s>\n", yytext);
			fprintf(logout,"Line# %d: Token <ADDOP> Lexeme %s found\n",lineCount,yytext);
			symbol_info *s = new  symbol_info(yytext, "ADDOP");
			yylval = (YYSTYPE)s;
			s->setStartLine(lineCount);
			s->setFinishLine(lineCount);
			return ADDOP; 

		}



"*"		|

"/"		|

"%"		 {

			//fprintf(tokenout,"<MULOP, %s>\n", yytext);
			fprintf(logout,"Line# %d: Token <MULOP> Lexeme %s found\n",lineCount,yytext);
			symbol_info *s = new  symbol_info(yytext, "MULOP");
			yylval = (YYSTYPE)s;
			s->setStartLine(lineCount);
			s->setFinishLine(lineCount);
			return MULOP; 

		}



{INCOP} {

			//fprintf(tokenout,"<INCOP, %s>\n", yytext);
			fprintf(logout,"Line# %d: Token <INCOP> Lexeme %s found\n",lineCount,yytext);
			symbol_info *s = new symbol_info(yytext, "INCOP");
			yylval = (YYSTYPE)s;
			s->setStartLine(lineCount);
			s->setFinishLine(lineCount);
			
			return INCOP;



		}
{DECOP} {

			//fprintf(tokenout,"<INCOP, %s>\n", yytext);
			fprintf(logout,"Line# %d: Token <INCOP> Lexeme %s found\n",lineCount,yytext);
			symbol_info *s = new symbol_info(yytext, "DECOP");
			yylval = (YYSTYPE)s;
			s->setStartLine(lineCount);
	s->setFinishLine(lineCount);
			return DECOP;



		}

{RELOP} {

			//fprintf(tokenout,"<RELOP, %s>\n", yytext);
			fprintf(logout,"Line# %d: Token <RELOP> Lexeme %s found\n",lineCount,yytext);
			symbol_info *s = new symbol_info(yytext, "RELOP");
			yylval = (YYSTYPE)s;
			s->setStartLine(lineCount);
	s->setFinishLine(lineCount);
			
			return RELOP;
		}





{LOGICOP} {

			//fprintf(tokenout,"<LOGICOP, %s>\n", yytext);
			fprintf(logout,"Line# %d: Token <LOGICOP> Lexeme %s found\n",lineCount,yytext);
			symbol_info *s = new symbol_info(yytext, "LOGICOP");
			yylval = (YYSTYPE)s;
			s->setStartLine(lineCount);
	s->setFinishLine(lineCount);
			return LOGICOP;
		}



"=" {

			//fprintf(tokenout,"<ASSIGNOP, %s>\n", yytext);
			fprintf(logout,"Line# %d: Token <ASSIGNOP> Lexeme %s found\n",lineCount,yytext);
			symbol_info *s = new symbol_info(yytext, "ASSIGNOP");
			yylval = (YYSTYPE)s;
			s->setStartLine(lineCount);
	s->setFinishLine(lineCount);
			return ASSIGNOP;

	}



"!"		{

			//fprintf(tokenout,"<NOT, %s>\n", yytext);
			fprintf(logout,"Line# %d: Token <NOT> Lexeme %s found\n",lineCount,yytext);
			symbol_info *s = new symbol_info(yytext, "NOT");
			yylval = (YYSTYPE)s;
			s->setStartLine(lineCount);
	s->setFinishLine(lineCount);
			return NOT;

}



"("		{

			//fprintf(tokenout,"<LPAREN, %s>\n", yytext);
			fprintf(logout,"Line# %d: Token <LPAREN> Lexeme %s found\n",lineCount,yytext);
			symbol_info *s = new symbol_info(yytext, "LPAREN");
			yylval = (YYSTYPE)s;
			s->setStartLine(lineCount);
	s->setFinishLine(lineCount);
			return LPAREN;

}



")"		{

			//fprintf(tokenout,"<RPAREN, %s>\n", yytext);
			fprintf(logout,"Line# %d: Token <RPAREN> Lexeme %s found\n",lineCount,yytext);
			symbol_info *s = new symbol_info(yytext, "RPAREN");
			yylval = (YYSTYPE)s;
			s->setStartLine(lineCount);
	s->setFinishLine(lineCount);
			return RPAREN;

}



"{"		{

			//fprintf(tokenout,"<LCURL, %s>\n", yytext);
			fprintf(logout,"Line# %d: Token <LCURL> Lexeme %s found\n",lineCount,yytext);
			symbol_info *s = new symbol_info(yytext, "LCURL");
			yylval = (YYSTYPE)s;
			s->setStartLine(lineCount);
	s->setFinishLine(lineCount);
			return LCURL;

			//st->enterScope(new scope_table(10));

}





"}"		{

			//fprintf(tokenout,"<RCURL, %s>\n", yytext);
			fprintf(logout,"Line# %d: Token <RCURL> Lexeme %s found\n",lineCount,yytext);
			symbol_info *s = new symbol_info(yytext, "RCURL");
			yylval = (YYSTYPE)s;
			s->setStartLine(lineCount);
	s->setFinishLine(lineCount);
			return RCURL;

			//st->exitScope();

}

"["		{

			//fprintf(tokenout,"<LSQUARE, %s>\n", yytext);
			fprintf(logout,"Line# %d: Token <LTHIRD> Lexeme %s found\n",lineCount,yytext);
			symbol_info *s = new symbol_info(yytext, "LTHIRD");
			yylval = (YYSTYPE)s;
			s->setStartLine(lineCount);
	s->setFinishLine(lineCount);
			return LTHIRD;

}



"]"		{

			//fprintf(tokenout,"<RSQUARE, %s>\n", yytext);
			fprintf(logout,"Line# %d: Token <RTHIRD> Lexeme %s found\n",lineCount,yytext);
			symbol_info *s = new symbol_info(yytext, "RTHIRD");
			yylval = (YYSTYPE)s;
			s->setStartLine(lineCount);
	s->setFinishLine(lineCount);
			return RTHIRD;

}



","		{

			//fprintf(tokenout,"<COMMA, %s>\n", yytext);
			fprintf(logout,"Line# %d: Token <COMMA> Lexeme %s found\n",lineCount,yytext);
			symbol_info *s = new symbol_info(yytext, "COMMA");
			yylval = (YYSTYPE)s;
			s->setStartLine(lineCount);
	s->setFinishLine(lineCount);
			return COMMA;

}



";"		{

			//fprintf(tokenout,"<SEMICOLON, %s>\n", yytext);
			fprintf(logout,"Line# %d: Token <SEMICOLON> Lexeme %s found\n",lineCount,yytext);
			symbol_info *s = new symbol_info(yytext, "SEMICOLON");
			yylval = (YYSTYPE)s;
			s->setStartLine(lineCount);
			s->setFinishLine(lineCount);
			return SEMICOLON;

}



{IDENTIFIER} {

			//fprintf(tokenout,"<ID, %s>\n", yytext);
			fprintf(logout,"Line# %d: Token <ID> Lexeme %s found\n",lineCount,yytext);
			symbol_info *s = new symbol_info(yytext, "ID");
			yylval = (YYSTYPE)s;
			s->setStartLine(lineCount);
			s->setFinishLine(lineCount);
			return ID;


			/*
			bool flag = st->insert(new symbol_info(yytext,"ID"));
			if(flag)
				{
					st->printAllScopeTable(logout);
				}
			else
				{
					fprintf(logout, "\t%s already exisits in the current ScopeTable\n", yytext);
				}

			*/
}





{SINGLECOMMENT} {

		fprintf(logout,"Line# %d: Token <SINGLE LINE COMMENT> Lexeme %s found\n",lineCount,yytext);
		string str = yytext;
		for(int i=0; i<str.size(); i++){
			if(str[i]=='\n') lineCount++;
		}
		
			

} 



{MULTICOMMENT} {

		fprintf(logout,"Line# %d: Token <MULTI LINE COMMENT> Lexeme %s found\n",lineCount,yytext);
		string str = yytext;
		for(int i=0; i<str.size(); i++){
			if(str[i]=='\n') lineCount++;
		}

			

}

{INVALID_SUFFIX_OR_PREFIX} {
		fprintf(logout, "Error at line# %d: INVALID_ID_SUFFIX_NUM_PREFIX %s\n", lineCount, yytext);
		errorCount++;		
		
}



{ILL_FORMED} {
		fprintf(logout, "Error at line# %d: ILLFORMED_NUMBER %s\n", lineCount, yytext);
		errorCount++;
}



{UNFINISHED_COMMENT} {
	fprintf(logout, "Error at line# %d: UNFINISHED_COMMENT %s\n", lineCount, yytext);
	string str = yytext;
	for(int i = 0; i < str.size(); ++i)
		if(str[i]=='\n') lineCount++;
	errorCount++;
}

. {
    	fprintf(logout, "Error at line# %d: UNRECOGNIZED_CHAR %s\n", lineCount, yytext);
   	errorCount++;
}

%%





