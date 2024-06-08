%{
#include<bits/stdc++.h>
#include "symbol_table.h"
#include "symbol_info.h"


using namespace std;

int yyparse(void);
int yylex(void);
extern FILE *yyin;
extern int lineCount;
FILE *logout;
FILE *parseTree;
FILE *errorout;
symbol_info* curr;

symbol_table *st = new symbol_table();


void yyerror(string s)
{
	fprintf(errorout,"Line# %d: %s\n",lineCount,s.c_str());
}


void generateParseTree(symbol_info* s, string space = ""){
	
	vector<symbol_info*> v = s->getVector();
	if(v.size()==0){
		fprintf(parseTree,"%s%s : %s\t<Line: %d>\n",space.c_str(),s->getType().c_str(),s->getName().c_str(),s->getStartLine());
	}
	else{
		fprintf(parseTree,"%s%s\t<Line: %d-%d>\n",space.c_str(),s->getRuleName().c_str(),s->getStartLine(), s->getFinishLine());
	}
	
	for(int i=0; i<v.size(); i++){
		generateParseTree(v[i],space+" ");
	}
	
}




%}
%code requires{
	#define YYSTYPE symbol_info*
}



%token IF ELSE FOR WHILE DO INT CHAR FLOAT DOUBLE VOID RETURN DEFAULT CONTINUE PRINTLN
%token ADDOP MULOP RELOP LOGICOP INCOP DECOP ASSIGNOP NOT LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD COMMA SEMICOLON CONST_INT CONST_FLOAT CONST_CHAR ID
%type variable factor term unary_expression simple_expression rel_expression logic_expression expression expression_statement statement statements compound_statement
%type type_specifier var_declaration func_declaration func_definition unit program declaration_list parameter_list argument_list arguments
%start start

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE



%%

start : program
	{
		//write your code in this block in all the similar blocks below
		$$ = new symbol_info("start : program");
		$$->push($1);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($1->getFinishLine());
		//$$->setRuleName("start : program");
		fprintf(logout,"start : program\n");
		

		generateParseTree($$);
	}
	;

program : program unit 
	{
		$$ = new symbol_info("program : program unit");
		$$->push($1);$$->push($2);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($2->getFinishLine());
		//$$->setRuleName("program : program unit");
		fprintf(logout,"program : program unit\n");
	
	}
	| unit
	{
		$$ = new symbol_info("program : unit");
		$$->push($1);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($1->getFinishLine());
		//$$->setRuleName("program : unit");
		fprintf(logout,"program : unit\n");
	}
	;
	
unit : var_declaration
	{
		$$ = new symbol_info("unit : var_declaration");
		$$->push($1);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($1->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
		fprintf(logout,"unit : var_declaration\n");
		
	}
     | func_declaration
     {
     	$$ = new symbol_info("unit : func_declaration");
     	$$->push($1);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($1->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
     	fprintf(logout,"unit : func_declaration\n");
     }
     | func_definition
     {
     		$$ = new symbol_info("unit : func_definition");
     		$$->push($1);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($1->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
     	     fprintf(logout,"unit : func_definition\n");
     }
     ;
     
func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON
		{
			$$ = new symbol_info("func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON");
			$$->push($1);$$->push($2);$$->push($3);$$->push($4);$$->push($5);$$->push($6);
			$$->setStartLine($1->getStartLine());
			$$->setFinishLine($6->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
			vector<pair<string,string>> vp = $4->getList();
			
			for(int i=0; i<vp.size(); i++)
				$2->pushElement(vp[i]);
 		  	
			
			symbol_info* s  = new symbol_info($2->getName(),$1->getFirst()->getType());
				bool ok = st->insert(s);
				if(ok){
					s->setIs("FUNCTION");
				}
				else{
					symbol_info* ss = st->lookUp($2->getName());
					if(ss->getType()==s->getType())
						fprintf(errorout,"Line# %d: Redefinition of parameter '%s'\n",lineCount,s->getName().c_str());
					else fprintf(errorout,"Line# %d: Conflicting types for '%s'\n",lineCount,s->getName().c_str());
				}
			
			fprintf(logout,"func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON\n");
		}
		| type_specifier ID LPAREN RPAREN SEMICOLON
		{
			$$ = new symbol_info("func_declaration : type_specifier ID LPAREN RPAREN SEMICOLON");
			$$->push($1);$$->push($2);$$->push($3);$$->push($4);$$->push($5);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($5->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
			symbol_info* s  = new symbol_info($2->getName(),$1->getFirst()->getType());
				bool ok = st->insert(s);
				if(ok){
					s->setIs("FUNCTION");
				}
				else{
					symbol_info* ss = st->lookUp($2->getName());
					if(ss->getType()==s->getType())
						fprintf(errorout,"Line# %d: Redefinition of parameter '%s'\n",lineCount,s->getName().c_str());
					else fprintf(errorout,"Line# %d: Conflicting types for '%s'\n",lineCount,s->getName().c_str());
				}
			fprintf(logout,"func_declaration : type_specifier ID LPAREN RPAREN SEMICOLON\n");
		}
		;
		 
func_definition : type_specifier ID LPAREN parameter_list RPAREN {

			symbol_info* s  = new symbol_info($2->getName(),$1->getFirst()->getType());
				bool ok = st->insert(s);
				if(ok){
					s->setIs("FUNCTION");
				}
				else{
					symbol_info* ss = st->lookUp($2->getName());
					if(ss->getType()==s->getType()){ }
						
					else {
						if(ss->getIs()!="FUNCTION") fprintf(errorout,"Line# %d: '%s' redeclared as different kind of symbol\n",lineCount,s->getName().c_str());
						else fprintf(errorout,"Line# %d: Conflicting types for '%s'\n",lineCount,s->getName().c_str());
					}
				
				
					vector<pair<string,string>> vp = $4->getList();
					
					vector<pair<string,string>> vps = ss->getList();
					if(vp.size()!=vps.size()) fprintf(errorout,"Line# %d: Conflicting types for '%s'\n",lineCount,s->getName().c_str());
					else{
						int key=1;
						for(int i=0; i<vp.size(); i++){
							if(vp[i].second!=vps[i].second) key=0;
						}
						if(!key) fprintf(errorout,"Line# %d: Conflicting types for '%s'\n",lineCount,s->getName().c_str());
						
					}
					
				
			
			}
			}compound_statement
		{
			$$ = new symbol_info("func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement");
			$$->push($1);$$->push($2);$$->push($3);$$->push($4);$$->push($5);$$->push($7);
			$$->setStartLine($1->getStartLine());
			$$->setFinishLine($7->getFinishLine());
			//$$->setRuleName("unit : var_declaration");
			
			
			
			
			fprintf(logout,"func_definition : type_specifier ID LPAREN parameter_list RPAREN compound_statement\n");
		}
		| type_specifier ID LPAREN RPAREN{

			symbol_info* s  = new symbol_info($2->getName(),$1->getFirst()->getType());
				bool ok = st->insert(s);
				if(ok){
					s->setIs("FUNCTION");
				}
				else{
					symbol_info* ss = st->lookUp($2->getName());
					if(ss->getType()==s->getType()){ }
						
					else {
						if(ss->getIs()!="FUNCTION") fprintf(errorout,"Line# %d: '%s' redeclared as different kind of symbol\n",lineCount,s->getName().c_str());
						else fprintf(errorout,"Line# %d: Conflicting types for '%s'\n",lineCount,s->getName().c_str());
					}
				}
				curr=new symbol_info();
			}
		 compound_statement
		{
			$$ = new symbol_info("func_definition : type_specifier ID LPAREN RPAREN compound_statement");
			$$->push($1);$$->push($2);$$->push($3);$$->push($4);$$->push($6);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($6->getFinishLine());
		//$$->setRuleName("unit : var_declaration");

			fprintf(logout,"func_definition : type_specifier ID LPAREN RPAREN compound_statement\n");
		}
 		;				


parameter_list  : parameter_list COMMA type_specifier ID{
			$$ = new symbol_info("parameter_list  : parameter_list COMMA type_specifier ID");
			$$->push($1);$$->push($2);$$->push($3);$$->push($4);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($4->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
		
			
			
			vector<pair<string,string>> vp = $1->getList();
			for(int i=0; i<vp.size(); i++)
				$$->pushElement(vp[i]);
 		  	$$->pushElement(make_pair($4->getName(),$3->getFirst()->getType()));
 		  	curr = $$;
			fprintf(logout,"parameter_list  : parameter_list COMMA type_specifier ID\n");
		}
		| parameter_list COMMA type_specifier
		{
			$$ = new symbol_info("parameter_list  : parameter_list COMMA type_specifier");
			$$->push($1);$$->push($2);$$->push($3);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($3->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
		curr = $$;
			fprintf(logout,"parameter_list  : parameter_list COMMA type_specifier\n");
		}
 		| type_specifier ID{
 			$$ = new symbol_info("parameter_list  : type_specifier ID");
 			$$->push($1); $$->push($2);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($2->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
 
 		  	$$->pushElement(make_pair($2->getName(),$1->getFirst()->getType()));
 		  	curr = $$;
 			fprintf(logout,"parameter_list  : type_specifier ID\n");
 		}
		| type_specifier
		{
			$$ = new symbol_info("parameter_list  : type_specifier");
			$$->push($1);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($1->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
		curr = $$;
			fprintf(logout,"parameter_list  : type_specifier\n");	
		}
 		;

 		
compound_statement : LCURL { 	st->enterScope(30); 
				vector<pair<string,string>> vp = curr->getList();
			for(int i=0; i<vp.size(); i++){
				symbol_info* s  = new symbol_info(vp[i].first,vp[i].second);
				bool ok = st->insert(s);
				if(ok){
					s->setIs("");
				}
				else{
					symbol_info* ss = st->lookUp(vp[i].first);
					if(ss->getType()==s->getType())
						fprintf(errorout,"Line# %d: Redefinition of parameter '%s'\n",lineCount,s->getName().c_str());
					else fprintf(errorout,"Line# %d: Conflicting types for '%s'\n",lineCount,s->getName().c_str());
				}
				}
				
			
				
			
			 } statements RCURL
			{
				$$ = new symbol_info("compound_statement : LCURL statements RCURL");
				$$->push($1);$$->push($3);$$->push($4);
				$$->setStartLine($1->getStartLine());
				$$->setFinishLine($4->getFinishLine());
				fprintf(logout,"compound_statement : LCURL statements RCURL\n");
				st->printAllScopeTable(logout); st->exitScope(); 
			}
			
 		    | LCURL{ st->enterScope(30); } RCURL 
 		    {
 		    	$$ = new symbol_info("compound_statement : LCURL RCURL");
 		    	$$->push($1);$$->push($3);
			$$->setStartLine($1->getStartLine());
			$$->setFinishLine($3->getFinishLine());
 		    	fprintf(logout,"compound_statement : LCURL RCURL\n");
 		    	st->printAllScopeTable(logout); st->exitScope();
 		    }
 		    ;
 		    
var_declaration : type_specifier declaration_list SEMICOLON
		{
			string type = $1->getFirst()->getType();
			
			$$ = new symbol_info("var_declaration : type_specifier declaration_list SEMICOLON");
			$$->push($1);$$->push($2);$$->push($3);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($3->getFinishLine());
			
			vector<pair<string,string>> vp = $2->getList();
			for(int i=0; i<vp.size(); i++){
				symbol_info* s  = new symbol_info(vp[i].first,type);
				bool ok = st->insert(s);
				if(ok){
					s->setIs(vp[i].second);
				}
				else{
					symbol_info* ss = st->lookUp(vp[i].first);
					if(ss->getType()==s->getType())
						fprintf(errorout,"Line# %d: Redefinition of parameter '%s'\n",lineCount,s->getName().c_str());
					else fprintf(errorout,"Line# %d: Conflicting types for '%s'\n",lineCount,s->getName().c_str());
				}
			}
			
		
		//$$->setRuleName("unit : var_declaration");
			fprintf(logout,"var_declaration : type_specifier declaration_list SEMICOLON\n");
		}
 		 ;
 		 
type_specifier : INT
		{
			$$ = new symbol_info("type_specifier  : INT");
			$$->push($1);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($1->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
			fprintf(logout,"type_specifier  : INT\n");
		}
 		| FLOAT
 		{
 			$$ = new symbol_info("type_specifier  : FLOAT");
 			$$->push($1);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($1->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
 			fprintf(logout,"type_specifier  : FLOAT\n");
 		}
 		| VOID
 		{
 			$$ = new symbol_info("type_specifier  : VOID");
 			$$->push($1);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($1->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
 			fprintf(logout,"type_specifier  : VOID\n");
 		}
 		;
 		
declaration_list : declaration_list COMMA ID{
				$$ = new symbol_info("declaration_list : declaration_list COMMA ID");
				$$->push($1);$$->push($2);$$->push($3);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($3->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
			vector<pair<string,string>> vp = $1->getList();
			for(int i=0; i<vp.size(); i++)
				$$->pushElement(vp[i]);
 		  	$$->pushElement(make_pair($3->getName(),""));
				fprintf(logout,"declaration_list : declaration_list COMMA ID\n");
			}
 		  | declaration_list COMMA ID LTHIRD CONST_INT RTHIRD
 		  {
 		  	$$ = new symbol_info("declaration_list : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD");
 		  	$$->push($1);$$->push($2);$$->push($3);$$->push($4);$$->push($5);$$->push($6);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($6->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
		
			vector<pair<string,string>> vp = $1->getList();
			for(int i=0; i<vp.size(); i++)
				$$->pushElement(vp[i]);
 		  	$$->pushElement(make_pair($3->getName(),"ARRAY"));
 		  	fprintf(logout,"declaration_list : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD\n");
 		  }
 		  | ID{
 		  	$$ = new symbol_info("declaration_list : ID");
 		  	$$->push($1);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($1->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
 		  	$$->pushElement(make_pair($1->getName(),""));
 		  	fprintf(logout,"declaration_list : ID\n");
 		  	
 		  }
 		  | ID LTHIRD CONST_INT RTHIRD
 		  {
 		  	$$ = new symbol_info("declaration_list : ID LTHIRD CONST_INT RTHIRD");
 		  	$$->push($1);$$->push($2);$$->push($3);$$->push($4);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($4->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
 		  	
 		  	$$->pushElement(make_pair($1->getName(),"ARRAY"));
 		  	fprintf(logout,"declaration_list : ID LTHIRD CONST_INT RTHIRD\n");
 		  }
 		  ;
 		  
statements : statement
		{
			$$ = new symbol_info("statements : statement");
			$$->push($1);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($1->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
			fprintf(logout,"statements : statement\n");
		}
	   | statements statement
	   {
	   	$$ = new symbol_info("statements : statements statement");
	   	$$->push($1);$$->push($2);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($2->getFinishLine());
	   	fprintf(logout,"statements : statements statement\n");
	   }
	   ;
	   
statement : var_declaration
		{
			$$ = new symbol_info("statement : var_declaration");
			$$->push($1);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($1->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
			fprintf(logout,"statement : var_declaration\n");
		}
	  | expression_statement
	  {
	  	$$ = new symbol_info("statement : expression_statement");
	  	$$->push($1);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($1->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
	  	fprintf(logout,"statement : expression_statement\n");
	  }
	  | compound_statement
	  {
	  	$$ = new symbol_info("statement : compound_statement");
	  	$$->push($1);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($1->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
	  	fprintf(logout,"statement : compound_statement\n");
	  }
	  | FOR LPAREN expression_statement expression_statement expression RPAREN statement
	  {
	  	$$ = new symbol_info("statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement");
	  	$$->push($1);$$->push($2);$$->push($3);$$->push($4);$$->push($5);$$->push($6);$$->push($7);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($7->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
	  	fprintf(logout,"statement : FOR LPAREN expression_statement expression_statement expression RPAREN statement\n");
	  }
	  | IF LPAREN expression RPAREN statement %prec LOWER_THAN_ELSE
	  {
	  	$$ = new symbol_info("statement : IF LPAREN expression RPAREN statement");
	  	$$->push($1);$$->push($2);$$->push($3);$$->push($4);$$->push($5);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($5->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
	  	fprintf(logout,"statement : IF LPAREN expression RPAREN statement\n");
	  }
	  | IF LPAREN expression RPAREN statement ELSE statement
	  {
	  	$$ = new symbol_info("statement : IF LPAREN expression RPAREN statement ELSE statement");
	  	$$->push($1);$$->push($2);$$->push($3);$$->push($4);$$->push($5);$$->push($6);$$->push($7);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($7->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
	  	fprintf(logout,"statement : IF LPAREN expression RPAREN statement ELSE statement\n");
	  }
	  | WHILE LPAREN expression RPAREN statement
	  {
	  	$$ = new symbol_info("statement : WHILE LPAREN expression RPAREN statement");
	  	$$->push($1);$$->push($2);$$->push($3);$$->push($4);$$->push($5);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($5->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
	  	fprintf(logout,"statement : WHILE LPAREN expression RPAREN statement\n");
	  }
	  | PRINTLN LPAREN ID RPAREN SEMICOLON
	  {
	  	$$ = new symbol_info("statement : PRINTLN LPAREN ID RPAREN SEMICOLON");
	  	$$->push($1);$$->push($2);$$->push($3);$$->push($4);$$->push($5);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($5->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
	  	fprintf(logout,"statement : PRINTLN LPAREN ID RPAREN SEMICOLON\n");
	  }
	  | RETURN expression SEMICOLON
	  {
	  	$$ = new symbol_info("statement : RETURN expression SEMICOLON");
	  	$$->push($1);$$->push($2);$$->push($3);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($3->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
	  	fprintf(logout,"statement : RETURN expression SEMICOLON\n");
	  }
	  ;
	  
expression_statement : SEMICOLON
			{
				$$ = new symbol_info("expression_statement : SEMICOLON");
				$$->push($1);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($1->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
				fprintf(logout,"expression_statement : SEMICOLON\n");
			}		
			| expression SEMICOLON
			{
				$$ = new symbol_info("expression_statement : expression SEMICOLON");
				$$->push($1);$$->push($2);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($2->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
				fprintf(logout,"expression_statement : expression SEMICOLON\n");
			}
			;
	  
variable : ID		
		{
			$$ = new symbol_info("variable : ID");
			$$->push($1);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($1->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
			
			fprintf(logout,"variable : ID\n");
		}
	 | ID LTHIRD expression RTHIRD
	 {
	 	$$ = new symbol_info("variable : ID LTHIRD expression RTHIRD");
	 	$$->push($1);$$->push($2);$$->push($3);$$->push($4);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($4->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
	 	fprintf(logout,"variable : ID LTHIRD expression RTHIRD\n");
	 }
	 ;
	 
expression	: logic_expression	
		{
			$$ = new symbol_info("expression	: logic_expression");
			$$->push($1);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($1->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
			fprintf(logout,"expression	: logic_expression\n");
		}
	   | variable ASSIGNOP logic_expression 
	   {
	   	$$ = new symbol_info("expression	: variable ASSIGNOP logic_expression");
	   	$$->push($1);$$->push($2);$$->push($3);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($3->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
	   	fprintf(logout,"expression	: variable ASSIGNOP logic_expression\n");
	   }	
	   ;
			
logic_expression : rel_expression 
		{
			$$ = new symbol_info("logic_expression : rel_expression");
			$$->push($1);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($1->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
			fprintf(logout,"logic_expression : rel_expression\n");
		}
		 | rel_expression LOGICOP rel_expression 
		 {
		 	$$ = new symbol_info("logic_expression : rel_expression LOGICOP rel_expression");
		 	$$->push($1);$$->push($2);$$->push($3);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($3->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
		 	fprintf(logout,"logic_expression : rel_expression LOGICOP rel_expression\n");
		 }
		 ;
			
rel_expression	: simple_expression 
		{
			$$ = new symbol_info("rel_expression	: simple_expression");
			$$->push($1);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($1->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
			fprintf(logout,"rel_expression	: simple_expression\n");
		}
		| simple_expression RELOP simple_expression
		{
			$$ = new symbol_info("rel_expression	: simple_expression RELOP simple_expression");
			$$->push($1);$$->push($2);$$->push($3);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($3->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
			fprintf(logout,"rel_expression	: simple_expression RELOP simple_expression\n");
		}
		;
				
simple_expression : term 
			{
				$$ = new symbol_info("simple_expression : term");
				$$->push($1);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($1->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
				fprintf(logout,"simple_expression : term\n");
			}
		  | simple_expression ADDOP term 
		  {
		  	$$ = new symbol_info("simple_expression : simple_expression ADDOP term");
		  	$$->push($1);$$->push($2);$$->push($3);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($3->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
		  	fprintf(logout,"simple_expression : simple_expression ADDOP term\n");
		  }
		  ;
					
term :  unary_expression
	{
		$$ = new symbol_info("term :  unary_expression");
		$$->push($1);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($1->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
		fprintf(logout,"term :  unary_expression\n");
	}
     |  term MULOP unary_expression
     {
     	$$ = new symbol_info("term :  term MULOP unary_expression");
     	$$->push($1);$$->push($2);$$->push($3);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($3->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
     	fprintf(logout,"term :  term MULOP unary_expression\n");
     }
     ;

unary_expression : ADDOP unary_expression
			{
			$$ = new symbol_info("unary_expression : ADDOP unary_expression");
				$$->push($1);$$->push($2);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($2->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
				fprintf(logout,"unary_expression : ADDOP unary_expression\n");
			}  
		 | NOT unary_expression 
		 {
		 $$ = new symbol_info("unary_expression : NOT unary_expression");
		 	$$->push($1);$$->push($2);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($2->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
		 	fprintf(logout,"unary_expression : NOT unary_expression\n");
		 }
		 | factor 
		 {
		 $$ = new symbol_info("unary_expression : factor");
		 	$$->push($1);
		$$->setStartLine($1->getStartLine());				
		$$->setFinishLine($1->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
		 	fprintf(logout,"unary_expression : factor\n");	
		 }
		 ;
	
factor	: variable
	{
		$$ = new symbol_info("factor	: variable");
		$$->push($1);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($1->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
		fprintf(logout,"factor	: variable\n");
	}
	| ID LPAREN argument_list RPAREN
	{
		$$ = new symbol_info("factor	: ID LPAREN argument_list RPAREN");
		$$->push($1);$$->push($2);$$->push($3);$$->push($4);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($4->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
		fprintf(logout,"factor	: ID LPAREN argument_list RPAREN\n");
	}
	| LPAREN expression RPAREN
	{
		$$ = new symbol_info("factor  : LPAREN expression RPAREN");
		$$->push($1);$$->push($2);$$->push($3);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($3->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
		fprintf(logout,"factor  : LPAREN expression RPAREN\n");
	}
	| CONST_INT 
	{
		$$ = new symbol_info("factor	: CONST_INT");
		$$->push($1);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($1->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
		fprintf(logout,"factor	: CONST_INT\n");
	}
	| CONST_FLOAT
	{
		$$ = new symbol_info("factor	: CONST_FLOAT");
		$$->push($1);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($1->getFinishLine());		
		//$$->setRuleName("unit : var_declaration");
		fprintf(logout,"factor	: CONST_FLOAT\n");
	}
	| variable INCOP 
	{
		$$ = new symbol_info("factor	: variable INCOP");
		$$->push($1);$$->push($2);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($2->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
		fprintf(logout,"factor	: variable INCOP\n");
	}
	| variable DECOP
	{
		$$ = new symbol_info("factor	: variable DECOP");
		$$->push($1);$$->push($2);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($2->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
		fprintf(logout,"factor	: variable DECOP\n");
	}
	;
	
argument_list : arguments
		{
			$$ = new symbol_info("argument_list : arguments");
			$$->push($1);
			$$->setStartLine($1->getStartLine());
			$$->setFinishLine($1->getFinishLine());
			//$$->setRuleName("unit : var_declaration");
			fprintf(logout,"argument_list : arguments\n");
		}
		| //empty
		{
			symbol_info* s1 = new symbol_info("empty","EMPTY");
			s1->setStartLine(lineCount);
			s1->setFinishLine(lineCount);
			
			$$ = new symbol_info("argument_list : ");
			$$->push(s1);
			$$->setStartLine(s1->getStartLine());
			$$->setFinishLine(s1->getFinishLine());
			//$$->setRuleName("unit : var_declaration");
			fprintf(logout,"argument_list : \n");
		}
		;
	
arguments : arguments COMMA logic_expression
		{
			$$ = new symbol_info("rguments : arguments COMMA logic_expression");
			$$->push($1);$$->push($2);$$->push($3);
			$$->setStartLine($1->getStartLine());
			$$->setFinishLine($3->getFinishLine());
			//$$->setRuleName("unit : var_declaration");
			fprintf(logout,"arguments : arguments COMMA logic_expression\n");
		}
	      | logic_expression
	      {
	      	$$ = new symbol_info("arguments : logic_expression");
	      	$$->push($1);
		$$->setStartLine($1->getStartLine());
		$$->setFinishLine($1->getFinishLine());
		//$$->setRuleName("unit : var_declaration");
	      	fprintf(logout,"arguments : logic_expression\n");
	      }
	      ;
 

%%
int main(int argc,char *argv[]){
	
	if(argc!=2){
		printf("Please provide input file name and try again\n");
		return 0;
	}
	
	FILE *fin=fopen(argv[1],"r");
	if(fin==NULL){
		printf("Cannot open specified file\n");
		return 0;
	}
	
	st->enterScope(30);

	logout= fopen("log.txt","w");
	parseTree = fopen("parseTree.txt","w");
	errorout = fopen("error.txt","w");
	//tokenout= fopen("token.txt","w");
	
	
	

	yyin = fin;
	yyparse();
	//st->printAllScopeTable(logout);
	fprintf(logout, "Total lines: %d\n", lineCount);
	//fprintf(logout, "Total lexical errors: %d\n", errorCount);
	fclose(yyin);
	//fclose(tokenout);
	fclose(logout);
	fclose(parseTree);
	fclose(errorout);
	
	return 0;
}
/*
int main(int argc,char *argv[])
{

	if((fp=fopen(argv[1],"r"))==NULL)
	{
		printf("Cannot Open Input File.\n");
		exit(1);
	}

	fp2= fopen(argv[2],"w");
	fclose(fp2);
	fp3= fopen(argv[3],"w");
	fclose(fp3);
	
	fp2= fopen(argv[2],"a");
	fp3= fopen(argv[3],"a");
	

	yyin=fp;
	yyparse();
	

	fclose(fp2);
	fclose(fp3);
	
	return 0;
}
*/
