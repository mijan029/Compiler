#include <bits/stdc++.h>
using namespace std;

class symbol_info
{
private:
    string name = "";
    string type = "";


public:
    symbol_info *next = NULL;
    symbol_info(){

    }

    ~symbol_info(){
        delete this;
    }

    void setName(string name){
        this->name = name;
    }

    void setType(string type){
        this->type = type;
    }

    string getName(){
        return name;
    }

    string getType(){
        return type;
    }




};


class scope_table
{
private:
    symbol_info** scopeTable = NULL;
    int num_buckets;
    int id;
public:

    scope_table* pr = NULL;
    scope_table* nextTable = NULL;
    static int id_count;
    scope_table(int n){
        scopeTable = new symbol_info*[n];

        for(int i=0; i<n; i++)
            scopeTable[i] = NULL;

        num_buckets = n;
        id_count++;
        id = id_count;
    }

    ~scope_table(){
        delete scopeTable;
        delete this;
    }

    int getId()
    {
        return id;
    }

    bool insert(symbol_info* s)
    {
        int index = SDBMHash(s->getName()) % num_buckets;
        symbol_info* now = scopeTable[index];
        int cnt=0;

        if(now == NULL){
            scopeTable[index] = s;
        }
        else{
            while(now->next!=NULL){
                now = now->next;
                cnt++;
            }
            now->next = s;
            cnt++;
        }
        cout<<"Inserted in ScopeTable# "<<id<<" at position "<<index+1<<", "<<cnt+1<<endl;

        return 1;
    }

    symbol_info* lookUp(string name)
    {
        int index = SDBMHash(name) % num_buckets;
        symbol_info* now = scopeTable[index];
        int cnt=0;

        while(now!=NULL && now->getName() != name){
            now = now->next;
            cnt++;
        }
        if(now !=NULL){

            cout<<"\'"<<name<<"\' found"<<" in ScopeTable# "<<id<<" at position "<<index+1<<", "<<cnt+1<<endl;
        }
        return now;
    }

    bool search(string name)
    {
        int index = SDBMHash(name) % num_buckets;
        symbol_info* now = scopeTable[index];

        while(now!=NULL && now->getName() != name){
            now = now->next;
        }

        if(now==NULL) return 0;
        return 1;
    }

    bool Delete(string name)
    {
        int index = SDBMHash(name) % num_buckets;
        symbol_info* now = scopeTable[index];
        symbol_info* pre = NULL;
        int cnt=0;

        while(now!=NULL && now->getName() != name){
            pre = now;
            now = now->next;
            cnt++;
        }
        if(now == NULL){
            return 0;
        }

        symbol_info* help = now;
        now = now->next;
        help->next = NULL;
        if(pre != NULL) pre->next = now;
        else scopeTable[index]=now;

        cout<<"Deleted "<<"\'"<<name<<"\' from ScopeTable# "<<id<<" at position "<<index+1<<", "<<cnt+1<<endl;
        return 1;

    }

    void print()
    {
        cout<<"ScopeTable# "<<id<<endl;
        for(int i=0; i<num_buckets; i++){
            symbol_info* now = scopeTable[i];
            cout<<"    "<<i+1<<"--> ";
            while(now != NULL){
                cout<<"<"<<now->getName()<<","<<now->getType()<<">";
                now = now->next;
            }
            cout<<endl;
        }
    }


    unsigned long long SDBMHash(string str) {
        unsigned long long hash = 0;
        unsigned long long i = 0;
        unsigned long long len = str.length();

        for (i = 0; i < len; i++)
        {
            hash = (str[i]) + (hash << 6) + (hash << 16) - hash;
        }

        return hash;
    }


};
int scope_table::id_count=0;

class symbol_table
{
private:
    scope_table* current = NULL;

public:
    symbol_table(){

    }
    ~symbol_table(){
        while(current->pr!=NULL){
            exitScope();
        }
        current = NULL;
        cout<<"    ScopeTable# 1 removed"<<endl;
        delete this;
    }

    scope_table* currentScopeTable()
    {
        return current;
    }

    void enterScope(scope_table* st)
    {
        if(current == NULL){
            current = st;
        }
        else{
            scope_table* help = current;
            current = st;
            current->pr = help;
            help->nextTable = current;
        }

        cout<<"ScopeTable# "<<current->getId()<<" created"<<endl;
    }

    void exitScope()
    {
        if(current->pr!=NULL){
            scope_table* help = current->pr;
            help->nextTable = NULL;
            current->pr = NULL;
            cout<<"ScopeTable# "<<current->getId()<<" removed"<<endl;
            current = help;
        }
        else {
            cout<<"ScopeTable# 1 cannot be removed"<<endl;
        }
    }

    bool insert(symbol_info* s)
    {
        if(current!=NULL){
            return current->insert(s);
        }
        return 0;
    }

    bool remove(string name)
    {
        if(current!=NULL){
            return current->Delete(name);
        }
        return 0;
    }

    symbol_info* lookUp(string name)
    {
        scope_table* now = current;
        symbol_info* paisi = NULL;
        while(now !=NULL)
        {
            paisi = now->lookUp(name);
            if(paisi!=NULL){
                return paisi;
            }
            now=now->pr;
        }
        return paisi;
    }

    bool search(string name)
    {
        return current->search(name);
    }


    void printCurrentScopeTable()
    {
        current->print();
    }

    void printAllScopeTable()
    {
        scope_table* now = current;
        while(now !=NULL)
        {
            now->print();
            now = now->pr;
        }
    }
};


void printmismatch( string s)
{
    cout<<"Number of parameters mismatch for the command "<<s<<endl;
}


int main()
{

    freopen("input.txt", "r", stdin);
    freopen("output.txt", "w", stdout);
    int n;
    string s, line, str[100], T;

    cin>>n; cout<<"    ";
    symbol_table* symbolTable = new symbol_table();
    symbolTable->enterScope(new scope_table(n));

    int cmd=0;
    char ch = getchar();
    while(1){
        //cin.flush();
        getline(cin, line);
        stringstream X(line);

        int len=0;
        while (getline(X, T, ' ')) {
            str[len]=T;
            len++;
        }


        s = str[0];
        len--; cmd++;
        cout<<"Cmd "<<cmd<<": "<<line<<endl;
        cout<<"    ";
        if(s=="I"){
            if(len!=2) printmismatch(s);
            else{
                if(symbolTable->search(str[1])){
                    cout<<"\'"<<str[1]<<"\' already exists in the current ScopeTable"<<endl;
                }
                else{
                    symbol_info* si = new symbol_info();
                    si->setName(str[1]);
                    si->setType(str[2]);
                    symbolTable->insert(si);
                }
            }
        }
        if(s=="L"){
            if(len!=1) printmismatch(s);
            else {
                    symbol_info* now = symbolTable->lookUp(str[1]);
                    if(now==NULL){
                        cout<<"\'"<<str[1]<<"\'"<<" not found in any of the ScopeTables"<<endl;
                    }
            }

        }
        if(s=="D"){
            if(len!=1) printmismatch(s);
            else{
                bool b = symbolTable->remove(str[1]);
                if(!b) cout<<"Not found in the current ScopeTable"<<endl;
            }
        }
        if(s=="P"){
            if(len!=1) printmismatch(s);
            else{
                if(str[1]=="C"){
                    symbolTable->printCurrentScopeTable();
                }
                else if(str[1]=="A"){
                    symbolTable->printAllScopeTable();
                }
                else printmismatch(s);
            }
        }
        if(s=="S"){
            if(len!=0) printmismatch(s);
            else symbolTable->enterScope(new scope_table(n));
        }
        if(s=="E"){
            if(len!=0) printmismatch(s);
            else symbolTable->exitScope();
        }
        if(s=="Q"){
            if(len!=0) printmismatch(s);
            delete(symbolTable);
            return 0;
        }
    }

    return 0;

}
