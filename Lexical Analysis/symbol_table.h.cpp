#include <bits/stdc++.h>
using namespace std;

class symbol_info
{
private:
    string name ;
    string type ;
    symbol_info *next = nullptr;

public:


    symbol_info(string name, string type){
        this->name = name;
        this->type = type;
    }
    symbol_info(){

    }

    ~symbol_info(){

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

    symbol_info* getNext(){
        return next;
    }
    void setNext(symbol_info*  sm){
        this->next = sm;
    }


};


class scope_table
{
private:
    symbol_info** scopeTable = nullptr;
    scope_table* pr = nullptr;
    scope_table* nextTable = nullptr;
    int num_buckets;
    int id;
public:


    static int id_count;

    scope_table(int n){
        scopeTable = new symbol_info*[n];

        for(int i=0; i<n; i++)
            scopeTable[i] = nullptr;

        num_buckets = n;
        id_count++;
        id = id_count;
    }

    ~scope_table(){
        delete scopeTable;
    }

    int getId()
    {
        return id;
    }

    void setId(int id)
    {
        this->id = id;
    }
    void setPr(scope_table* sc){
        this->pr = sc;
    }
    void setNextTable(scope_table* sc){
        this->nextTable = sc;
    }
    scope_table* getPr(){
        return pr;
    }
    scope_table* getNextTable(){
        return nextTable;
    }

    bool insert(symbol_info* s)
    {
        if(lookUp(s->getName(),0)!=nullptr){
            return 0;
        }

        int index = SDBMHash(s->getName()) % num_buckets;
        symbol_info* now = scopeTable[index];
        int cnt=0;

        if(now == nullptr){
            scopeTable[index] = s;
        }
        else{
            while(now->getNext()!=nullptr){
                now = now->getNext();
                cnt++;
            }
            now->setNext(s);
            cnt++;
        }

        return 1;
    }

    symbol_info* lookUp(string name , int flag = 1)
    {
        int index = SDBMHash(name) % num_buckets;
        symbol_info* now = scopeTable[index];
        int cnt=0;

        while(now!=nullptr && now->getName() != name){
            now = now->getNext();
            cnt++;
        }

        return now;
    }

    bool Delete(string name)
    {
        int index = SDBMHash(name) % num_buckets;
        symbol_info* now = scopeTable[index];
        symbol_info* pre = nullptr;
        int cnt=0;

        while(now!=nullptr && now->getName() != name){
            pre = now;
            now = now->getNext();
            cnt++;
        }
        if(now == nullptr){
            return 0;
        }

        symbol_info* help = now;
        now = now->getNext();
        help->setNext(nullptr);
        if(pre != nullptr) pre->setNext(now);
        else scopeTable[index]=now;

        return 1;

    }

    void print()
    {
        cout<<"\tScopeTable# "<<id<<endl;
        for(int i=0; i<num_buckets; i++){
            symbol_info* now = scopeTable[i];
            cout<<"\t"<<i+1<<"--> ";
            while(now != nullptr){
                cout<<"<"<<now->getName()<<","<<now->getType()<<"> ";
                now = now->getNext();
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
    scope_table* current = nullptr;

public:
    symbol_table(){

    }
    ~symbol_table(){
      while(current->getPr()!=NULL){
            exitScope();
        }
        current = NULL;

    }

    scope_table* getCurrent()
    {
        return current;
    }
    void setCurrent(scope_table* sc)
    {
        this->current = sc;
    }

    void enterScope(scope_table* st)
    {
        if(current == nullptr){
            current = st;
        }
        else{
            scope_table* help = current;
            current = st;
            current->setPr(help);
            help->setNextTable(current);
        }

    }

    void exitScope()
    {
        if(current->getPr()!=nullptr){
            scope_table* help = current->getPr();
            help->setNextTable(nullptr);
            current->setPr(nullptr);
            current = help;
        }

    }

    bool insert(symbol_info* s)
    {

        if(current!=nullptr){
            return current->insert(s);
        }
        return 0;
    }

    bool remove(string name)
    {
        if(current!=nullptr){
            return current->Delete(name);
        }
        return 0;
    }

    symbol_info* lookUp(string name)
    {
        scope_table* now = current;
        symbol_info* paisi = nullptr;
        while(now !=nullptr)
        {
            paisi = now->lookUp(name);
            if(paisi!=nullptr){
                return paisi;
            }
            now=now->getPr();
        }
        return paisi;
    }


    void printCurrentScopeTable()
    {
        current->print();
    }

    void printAllScopeTable()
    {
        scope_table* now = current;
        while(now !=nullptr)
        {
            now->print();
            now = now->getPr();
        }
    }
};
