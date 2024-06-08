%{
#include<bits/stdc++.h>
#include "symbol_table.h"
#include "symbol_info.h"
#include<fstream>

using namespace std;

int yyparse(void);
int yylex(void);
extern FILE *yyin;
extern int lineCount;
ofstream fout, datasegout;


symbol_table *st = new symbol_table();
vector<symbol_info*> param;
int lebel=0;

string toString(int);
void yyerror(string s)
{
	
}

string newLebel(){
    lebel++;
    string str = toString(lebel);
    str="L"+str;
    return str;
}

void newLine()
{
    string str = "\n\tPRINT_NEWLINE PROC\r"
                 "\n"
                 "        PUSH AX\r\n"
                 "        PUSH DX\r\n"
                 "        MOV AH, 2\r"
                 "\n"
                 "        MOV DL, 0Dh"
                 "\r\n"
                 "        INT 21h\r\n"
                 "        MOV DL, 0Ah"
                 "\r\n"
                 "        INT 21h\r\n"
                 "        POP DX\r\n"
                 "        POP AX\r\n"
                 "        RET\r\n"
                 "    PRINT_NEWLINE EN"
                 "DP";
    fout << str << endl;
}

void println()
{


    string str = "\tprint_from_ax proc  ;print what is in ax\n"
                "\t\tpush ax\n"
                "\t\tpush bx\n"
                "\t\tpush cx\n"
                "\t\tpush dx\n"
                "\t\tpush si\n"
                "\t\tlea si,number\n"
                "\t\tmov bx,10\n"
                "\t\tadd si,4\n"
                "\t\tcmp ax,0\n"
                "\t\tjnge negate\n"
                "\t\tprint:\n"
                "\t\txor dx,dx\n"
                "\t\tdiv bx\n"
                "\t\tmov [si],dl\n"
                "\t\tadd [si],'0'\n"
                "\t\tdec si\n"
                "\t\tcmp ax,0\n"
                "\t\tjne print\n"
                "\t\tinc si\n"
                "\t\tlea dx,si\n"
                "\t\tmov ah,9\n"
                "\t\tint 21h\n"
                "\t\tpop si\n"
                "\t\tpop dx\n"
                "\t\tpop cx\n"
                "\t\tpop bx\n"
                "\t\tpop ax\n"
                "\t\tcall PRINT_NEWLINE\n"
                "\t\tret\n"
                "\t\tnegate:\n"
                "\t\tpush ax\n"
                "\t\tmov ah,2\n"
                "\t\tmov dl,'-'\n"
                "\t\tint 21h\n"
                "\t\tpop ax\n"
                "\t\tneg ax\n"
                "\t\tjmp print\n"
            "\tprint_from_ax endp";
    
    fout << str << endl;
}
vector<string> tokens(string line){
    vector<string> v;
    string str="";
    for(int i=0; i<line.size(); i++){
        if(line[i]==' ' || line[i]=='\t' || line[i]=='\n'){
            if(str.size()>0) v.push_back(str);
            str="";
        }
        else str+=line[i];
    }
    if(str.size()>0) v.push_back(str);
    return v;
}
void optimize()
{
    ifstream in("code.asm");
    ofstream out("optimizedCode.asm", ios::out);
    vector<string> lines;
    string str;
    while (getline(in, str))
    {
        if(str.size()>0) lines.push_back(str);
    }
    lines.push_back(";");
    for (int i = 0; i < lines.size()-1; i++)
    {
        vector <string> tokens1;
        tokens1 = tokens(lines[i]);

        tokens1.push_back(".");
        tokens1.push_back("..");
        tokens1.push_back("...");

        vector <string> tokens2;
        tokens2 = tokens(lines[i+1]);
        tokens2.push_back(",");
        tokens2.push_back(",,");
        tokens2.push_back(",,,");

        if(tokens1[0]=="add" && tokens1[1]=="ax" && tokens1[3]=="0") {

        }
        else if(tokens1[0]=="mul" && tokens1[1]=="ax" && tokens1[3]=="1"){

        }
        else if (tokens1[0]=="push"&&tokens1[1]=="ax"&&tokens2[0]=="pop" &&tokens2[1]=="ax"){
            i++; 
        }
        else if (tokens1[0]=="pop"&&tokens1[1]=="ax"&&tokens2[0]=="push" &&tokens2[1]=="ax"){
            i++;
        }
        else if(tokens1[0]=="mov"&&tokens2[0]=="mov"&&tokens1[1]==tokens2[3]&&tokens1[3]==tokens2[1]){
            out<<lines[i]<<endl;
            i++;
        }
        else{
            out<<lines[i]<<endl;
        }

    }

    out.close();
    in.close();
}

string toString(int n){
    string str="";
    while(n){
        int r = n%10;
        char ch = '0'+r;
        str+=ch;
        n/=10;
    }
    reverse(str.begin(),str.end());
    return str;
}

int toInt(string str){
    int n=0;
    for(int i=0; i<str.size(); i++){
        n = n*10+(str[i]-'0');
    }
    return n;
}

void generateMainFile()
{
    if (datasegout.is_open())
    {
        datasegout.close();
    }
    if (fout.is_open())
    {
        fout.close();
    }
    ifstream datain("temp2.asm");
    ifstream fin("temp1.asm");
    ofstream mainout("code.asm", ios::out);
    string line;
    while (getline(datain, line))
    {
        mainout << line << endl;
    }
    mainout << endl;
    while (getline(fin, line))
    {
        mainout << line << endl;
    }

    mainout << endl;

    datain.close();
    fin.close();
    mainout.close();
}

%}

%code requires{
	#define YYSTYPE symbol_info*
}



%token IF ELSE FOR WHILE DO INT CHAR FLOAT DOUBLE VOID RETURN DEFAULT CONTINUE PRINTLN
%token ADDOP MULOP RELOP LOGICOP INCOP DECOP ASSIGNOP NOT LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD COMMA SEMICOLON CONST_INT CONST_FLOAT CONST_CHAR ID
%type variable if_common_part factor term unary_expression simple_expression rel_expression logic_expression expression expression_statement statement statements compound_statement
%type type_specifier var_declaration func_declaration func_definition unit program declaration_list parameter_list argument_list arguments
%start start

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE



%%


start : {
    datasegout << ".MODEL SMALL\n.STACK 100H\n.DATA\n\n";
    datasegout<<"\t\tnumber DB \"00000$\"\n";
    //here datasegment is required
	
}program
	{
		//write your code in this block in all the similar blocks below
		
		//fout << $1->code;
        datasegout << ".CODE\n";


       
		newLine(); 
		println();
		fout<<"END MAIN\n";

        generateMainFile();
        optimize();
	}
	;

program : program unit 
	| unit
	;
	
unit : var_declaration
     | func_declaration
     | func_definition
     ;
     
func_declaration : type_specifier ID LPAREN parameter_list RPAREN SEMICOLON
		| type_specifier ID LPAREN RPAREN SEMICOLON
		;
		
func_definition : type_specifier ID LPAREN parameter_list RPAREN{
            fout<<"\t"<<$2->getName()<<" proc\n";
            fout<<"\t\tpush bp\n"; 
            fout<<"\t\tmov bp, sp\n";
        } compound_statement{
                
                fout<<"\t\tpop bp\n";
                fout<<"\t\tret\n";
                fout<<"\t"<<$2->getName()<<" endp\n";
        }
		| type_specifier ID LPAREN RPAREN {
            fout<<"\t"<<$2->getName()<<" proc\n";
            if($2->getName()=="main"){
                    fout<<"\t\tmov ax, @DATA\n";
                    fout<<"\t\tmov ds, ax\n";
                }
            fout<<"\t\tpush bp\n"; 
            fout<<"\t\tmov bp, sp\n"; 
            } compound_statement{
                if($2->getName()=="main"){
                    fout<<"\t\tmov ax,4ch\n";
	                fout<<"\t\tint 21H\n";
                }else{
                    fout<<"\t\tpop bp\n";
                    fout<<"\t\tret\n";
                }
                
                fout<<"\t"<<$2->getName()<<" endp\n";
            }
 		;				


parameter_list  : parameter_list COMMA type_specifier ID{
            param.push_back($4);
    }
		| parameter_list COMMA type_specifier
 		| type_specifier ID{
            param.push_back($2);
        }
		| type_specifier
 		;

 		
compound_statement : LCURL{
            st->enterScope(30);
            int offset=4;
            for(int i=param.size()-1; i>=0; i--){
                st->insert(param[i]);
                param[i]->setOffset(-offset);
                offset+=2;
            }
            param.clear();
        } statements RCURL{
            if(st->getRet()!="") fout<<st->getRet()<<":\n";
            fout<<"\t\tadd sp,"<<st->getOffset()<<"\n";
            st->exitScope();
        }
 		    | LCURL RCURL
 		    ;
 		    
var_declaration : type_specifier declaration_list SEMICOLON
 		 ;
 		 
type_specifier	: INT
 		| FLOAT
 		| VOID
 		;
 		
declaration_list : declaration_list COMMA ID {
            if(st->getCurrent()->getId()!=1){
                st->insert($3);
                int offset = st->getOffset()+2;
                $3->setOffset(offset);
                st->setOffset(offset);
                fout<<"\t\tsub sp, 2\n";
            }
            else{
                $3->global=1;
                st->insert($3);
                datasegout<<"\t\t"<<$3->getName()<<" DW 0\n";
            }
        }
 		  | declaration_list COMMA ID LTHIRD CONST_INT RTHIRD
        {
            if(st->getCurrent()->getId()!=1){
                st->insert($3);
                int offset = st->getOffset()+2;
                int n = toInt($5->getName());
                $3->setOffset(offset);
                st->setOffset(offset+(n-1)*2);
                $3->setIsArray(n);
                fout<<"\t\tsub sp, "<<n*2<<"\n";
            }
            else{
                $3->global=1;
                st->insert($3);
                int n = toInt($5->getName());
                datasegout<<"\t\t"<<$3->getName()<<" DW "<<n<<" DUP(0)\n";
            }
        }
 		  | ID{

            if(st->getCurrent()->getId()!=1){
                st->insert($1);
                int offset = st->getOffset()+2;
                $1->setOffset(offset);
                st->setOffset(offset);
                fout<<"\t\tsub sp, 2\n";
            }
            else{
                $1->global=1;
                st->insert($1);
                datasegout<<"\t\t"<<$1->getName()<<" DW 0\n";
            }

          }
 		  | ID LTHIRD CONST_INT RTHIRD{
             if(st->getCurrent()->getId()!=1){
                st->insert($1);
                int offset = st->getOffset()+2;
                int n = toInt($3->getName());
                $1->setOffset(offset);
                st->setOffset(offset+(n-1)*2);
                $1->setIsArray(n);
                fout<<"\t\tsub sp, "<<n*2<<"\n";
            }
            else{
                $1->global=1;
                st->insert($1);
                int n = toInt($3->getName());
                datasegout<<"\t\t"<<$1->getName()<<" DW "<<n<<"DUP(0)\n";
            }
          }
 		  ;

statements : statement
	   | statements statement 
	   ;

if_common_part : IF LPAREN expression{
                $3 = new symbol_info();
                $3->level_1 = newLebel();
                $3->level_2 = newLebel();
                fout<<"\t\tpop ax\n";
                fout<<"\t\tcmp ax,0\n";
                fout<<"\t\tje "<<$3->level_1<<"\n";
        }RPAREN statement{
                fout<<"\t\tjmp "<<$3->level_2<<"\n";
                fout<<$3->level_1<<":\n"; 
                $$ = new symbol_info(); 
                $$ = $3;
        }


statement : var_declaration
	  | expression_statement{
        fout<<"\t\tpop ax\n";
      }
	  | compound_statement
	  | FOR LPAREN {
            $1->level_1 = newLebel();
            $1->level_2 = newLebel();
            $1->level_3 = newLebel();
            $1->level_4 = newLebel();
      }expression_statement{
            fout<<$1->level_1<<":\n";
            fout<<"\t\tpop ax\n";
      } expression_statement{
            fout<<"\t\tpop ax\n";
            fout<<"\t\tcmp ax,0\n";
            fout<<"\t\tje "<<$1->level_4<<"\n";
            fout<<"\t\tjmp "<<$1->level_3<<"\n";
            fout<<$1->level_2<<":\n";
      } expression {
            fout<<"\t\tjmp "<<$1->level_1<<"\n";
            fout<<$1->level_3<<":\n";
      }RPAREN statement{
            fout<<"\t\tjmp "<<$1->level_2<<"\n";
            fout<<$1->level_4<<":\n";
      }
      | if_common_part %prec LOWER_THAN_ELSE
	  {
            fout<<$1->level_2<<":\n"; 
      }
	  | if_common_part ELSE statement{
            fout<<$1->level_2<<":\n"; 
      }
	  | WHILE LPAREN {
            $1->level_1 = newLebel();
            $1->level_2 = newLebel();
            fout<<$1->level_1<<":\n";
      }expression {
            fout<<"\t\tpop ax\n";
            fout<<"\t\tcmp ax,0\n";
            fout<<"\t\tje "<<$1->level_2<<"\n";
      } RPAREN statement{
            fout<<"\t\tjmp "<<$1->level_1<<"\n";
            fout<<$1->level_2<<":\n";
      }
	  | PRINTLN LPAREN ID RPAREN SEMICOLON {
        $3 = st->lookUp($3->getName());
        int offset = $3->getOffset();
        int global = $3->global;
        if(!global){
            fout<<"\t\tmov ax, "<<"[bp-"<<offset<<"]\n";
        }else{
            fout<<"\t\tmov ax, "<<$3->getName()<<"\n";
        }
        fout<<"\t\tcall print_from_ax\n";
      }
	  | RETURN expression SEMICOLON{
        fout<<"\t\tpop ax\n";
        $1->level_1 = newLebel();
        fout<<"\t\tjmp "<<$1->level_1<<"\n";
        st->setRet($1->level_1);
      }
	  ;


	  
expression_statement 	: SEMICOLON
			| expression SEMICOLON {
                //fout<<"\t\tpop ax\n";
            }
			;
	  
variable : ID {$$=st->lookUp($1->getName());}
	 | ID LTHIRD expression RTHIRD {
        $$=st->lookUp($1->getName());
     }
	 ;
	 
 expression : logic_expression	{ }
	   | variable ASSIGNOP logic_expression{
        fout<<"\t\tpop ax\n";

        if($1->getIsArray()==0){
            if($1->global){
                fout<<"\t\tmov "<<$1->getName()<<", ax\n";
            }
            else{
                fout<<"\t\tmov [bp-"<<$1->getOffset()<<"], ax\n";
            }
        }else{
            fout<<"\t\tpop bx\n";
            if($1->global){
                fout<<"\t\tlea si,"<<$1->getName()<<"\n";
                fout<<"\t\tshl bx,1\n";
                fout<<"\t\tadd si,bx\n";
                fout<<"\t\tmov [si],ax\n";
            }
            else{
                fout<<"\t\tmov si, [bp-"<<$1->getOffset()<<"]\n";
                fout<<"\t\tshl bx,1\n";
                fout<<"\t\tsub si,bx\n";
                fout<<"\t\tmov [si],ax\n";
            }
        }
        fout<<"\t\tpush ax\n";
       }
	   ;
			
logic_expression : rel_expression {}
		 | rel_expression LOGICOP rel_expression {
            fout<<"\t\tpop bx\n";
            fout<<"\t\tpop ax\n";
            if($2->getName() == "&&"){
                fout<<"\t\tand ax,bx\n";
                fout<<"\t\tpush ax\n";
            }
            else {
                fout<<"\t\tor ax,bx\n";
                fout<<"\t\tpush ax\n";
            }
         }
		 ;
			
rel_expression	: simple_expression { }
		| simple_expression RELOP simple_expression	{
            fout<<"\t\tpop bx\n";
            fout<<"\t\tpop ax\n";
            fout<<"\t\tcmp ax,bx\n";
            string l1 = newLebel();
            string l2 = newLebel();
            if($2->getName() == "<"){
                fout<<"\t\tjl "<<l1<<"\n";
                fout<<"\t\tmov ax,0\n";
                fout<<"\t\tjmp "<<l2<<"\n";
                fout<<l1<<":\n";      
                fout<<"\t\tmov ax,1\n";
                fout<<l2<<":\n";
                fout<<"\t\tpush ax\n";         
            }
            else if($2->getName() == "<="){
                fout<<"\t\tjle "<<l1<<"\n";
                fout<<"\t\tmov ax,0\n";
                fout<<"\t\tjmp "<<l2<<"\n";
                fout<<l1<<":\n";      
                fout<<"\t\tmov ax,1\n";
                fout<<l2<<":\n";
                fout<<"\t\tpush ax\n";
            }
            else if($2->getName() == ">"){
                fout<<"\t\tjg "<<l1<<"\n";
                fout<<"\t\tmov ax,0\n";
                fout<<"\t\tjmp "<<l2<<"\n";
                fout<<l1<<":\n";      
                fout<<"\t\tmov ax,1\n";
                fout<<l2<<":\n";
                fout<<"\t\tpush ax\n";
            }
            else if($2->getName() == ">="){
                fout<<"\t\tjge "<<l1<<"\n";
                fout<<"\t\tmov ax,0\n";
                fout<<"\t\tjmp "<<l2<<"\n";
                fout<<l1<<":\n";      
                fout<<"\t\tmov ax,1\n";
                fout<<l2<<":\n";
                fout<<"\t\tpush ax\n";
            }
            else if($2->getName() == "=="){
                fout<<"\t\tje "<<l1<<"\n";
                fout<<"\t\tmov ax,0\n";
                fout<<"\t\tjmp "<<l2<<"\n";
                fout<<l1<<":\n";      
                fout<<"\t\tmov ax,1\n";
                fout<<l2<<":\n";
                fout<<"\t\tpush ax\n";
            }
            else if($2->getName() == "!="){
                fout<<"\t\tjne "<<l1<<"\n";
                fout<<"\t\tmov ax,0\n";
                fout<<"\t\tjmp "<<l2<<"\n";
                fout<<l1<<":\n";      
                fout<<"\t\tmov ax,1\n";
                fout<<l2<<":\n";
                fout<<"\t\tpush ax\n";
            }
        }
		;
				
simple_expression : term  {  }
		  | simple_expression ADDOP term 
          {
            fout<<"\t\tpop bx\n";
            fout<<"\t\tpop ax\n";
            if($2->getName()=="+"){
                fout<<"\t\tadd ax,bx\n";
                fout<<"\t\tpush ax\n";
            }
            else{
                fout<<"\t\tsub ax,bx\n";
                fout<<"\t\tpush ax\n";
            }

          }
		  ;
					
term :	unary_expression {  }
     |  term MULOP unary_expression {
            fout<<"\t\tpop bx\n";
            fout<<"\t\tpop ax\n";
            if($2->getName()=="*"){
                fout<<"\t\tmul bx\n";
                fout<<"\t\tpush ax\n";
            }
            else if($2->getName()=="/"){
                fout<<"\t\tmov dx,0\n";
                fout<<"\t\tdiv bx\n";
                fout<<"\t\tpush ax\n";
            }else{
                fout<<"\t\tmov dx,0\n";
                fout<<"\t\tdiv bx\n";
                fout<<"\t\tpush dx\n";
            }
     }
     ;

unary_expression : ADDOP unary_expression {
            fout<<"\t\tpop bx\n";
            fout<<"\t\tmov ax,0\n";
            if($1->getName()=="-"){
                fout<<"\t\tsub ax,bx\n";
                fout<<"\t\tpush ax\n";
            }else{
                fout<<"\t\tadd ax,bx\n";
                fout<<"\t\tpush ax\n";
            }
      }
		 | NOT unary_expression{
            fout<<"\t\tpop ax\n";
            fout<<"\t\tnot ax\n";
            fout<<"\t\tpush ax\n";
        }
        | factor {  }
		;
	
factor : variable {
            if($1->getIsArray()==0){
                if($1->global==0){
                    fout<<"\t\tmov ax, [bp-"<<$1->getOffset()<<"]\n";
                }else{
                    fout<<"\t\tmov ax,"<<$1->getName()<<"\n";
                }
            }else{
                fout<<"\t\tpop bx\n";
                if($1->global){
                    fout<<"\t\tlea si,"<<$1->getName()<<"\n";
                    fout<<"\t\tshl bx,1\n";
                    fout<<"\t\tadd si,bx\n";
                    fout<<"\t\tmov ax,[si]\n";
                    
                }else{
                    fout<<"\t\tmov si, [bp-"<<$1->getOffset()<<"]\n";
                    fout<<"\t\tshl bx,1\n";
                    fout<<"\t\tsub si,bx\n";
                    fout<<"\t\tmov ax,[si]\n";
                }
            }
            fout<<"\t\tpush ax\n";
    }
	| ID LPAREN argument_list RPAREN {
        fout<<"\t\tcall "<<$1->getName()<<"\n";
        fout<<"\t\tadd sp,"<<$3->getOffset()<<"\n";
        fout<<"\t\tpush ax\n";
    }
	| LPAREN expression RPAREN
    {
        
    }
	| CONST_INT{
                int n = toInt($1->getName()); //$$->value=$1->value=n;
                fout<<"\t\tmov ax,"<<n<<"\n"; fout<<"\t\tpush ax\n";
             }
	| CONST_FLOAT
	| variable INCOP{
        if($1->global==0){
            int offset;
            if($1->getIsArray()==0){
                offset = $1->getOffset();
                fout<<"\t\tmov ax, [bp-"<<offset<<"]\n";
                fout<<"\t\tpush ax\n";
                fout<<"\t\tadd ax,1\n";
                fout<<"\t\tmov [bp-"<<offset<<"],ax\n";
                
            }
            else{
                fout<<"\t\tpop bx\n";
                fout<<"\t\tmov si, [bp-"<<$1->getOffset()<<"]\n";
                fout<<"\t\tshl bx,1\n";
                fout<<"\t\tsub si,bx\n";
                fout<<"\t\tmov ax,[si]\n";
                fout<<"\t\tpush ax\n";
                fout<<"\t\tadd ax,1\n";
                fout<<"\t\tmov [si],ax\n";
            }
        }
        else{
            if($1->getIsArray()==0){
                fout<<"\t\tmov ax,"<<$1->getName()<<"\n";
                fout<<"\t\tpush ax\n";
                fout<<"\t\tadd ax,1\n";
                fout<<"\t\tmov "<<$1->getName()<<",ax\n";
                
            }
            else{
                // fout<<"\t\tlea si, "<<$1->getName()<<"\n";
                // int offset = $1->value*2;
                // fout<<"\t\tinc [si + "<<offset<<"]\n";
            }
            
            
        }
    }
	| variable DECOP{
        if($1->global==0){
            int offset;
            if($1->getIsArray()==0){
                offset = $1->getOffset();
                fout<<"\t\tmov ax, [bp-"<<offset<<"]\n";
                fout<<"\t\tpush ax\n";
                fout<<"\t\tsub ax,1\n";
                fout<<"\t\tmov [bp-"<<offset<<"],ax\n";
                
            }
            else{
                fout<<"\t\tpop bx\n";
                fout<<"\t\tmov si, [bp-"<<$1->getOffset()<<"]\n";
                fout<<"\t\tshl bx,1\n";
                fout<<"\t\tsub si,bx\n";
                fout<<"\t\tmov ax,[si]\n";
                fout<<"\t\tpush ax\n";
                fout<<"\t\tsub ax,1\n";
                fout<<"\t\tmov [si],ax\n";
            }
        }
        else{
            if($1->getIsArray()==0){
                fout<<"\t\tmov ax,"<<$1->getName()<<"\n";
                fout<<"\t\tpush ax\n";
                fout<<"\t\tsub ax,1\n";
                fout<<"\t\tmov "<<$1->getName()<<",ax\n";
                
            }
            else{
                // fout<<"\t\tlea si, "<<$1->getName()<<"\n";
                // int offset = $1->value*2;
                // fout<<"\t\tinc [si + "<<offset<<"]\n";
            }
            
            
        }
    }
	;
	
argument_list : arguments {
            $$=$1;
}
			  | 
			  ;
	
arguments : arguments COMMA logic_expression{
            $$ = new symbol_info();
            $$->setOffset($1->getOffset()+2);
        }
	      | logic_expression {
            $$ = new symbol_info();
            $$->setOffset(2);
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
	fout.open("temp1.asm",ios::out);
    datasegout.open("temp2.asm",ios::out);
	st->enterScope(30);

	yyin = fin;
	yyparse();
	fclose(yyin);

	
	return 0;
}
