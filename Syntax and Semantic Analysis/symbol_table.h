#pragma once

#include <bits/stdc++.h>
#include "symbol_info.h"
using namespace std;




class scope_table
{
private:
    symbol_info** scopeTable = nullptr;
    scope_table* pr = nullptr;
    scope_table* nextTable = nullptr;
    int num_buckets;
    int id;
public:


    

    scope_table(int n, int id){
        scopeTable = new symbol_info*[n];

        for(int i=0; i<n; i++)
            scopeTable[i] = nullptr;

        num_buckets = n;
        this->id = id;
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

    void print(FILE* logout=NULL)
    {
    	fprintf(logout,"\tScopeTable# %d\n",id);
       //cout<<"\tScopeTable# "<<id<<endl;
        for(int i=0; i<num_buckets; i++){
            symbol_info* now = scopeTable[i];
          // cout<<"\t"<<i+1<<"--> ";
            if(now!=nullptr) 
            {
		    fprintf(logout,"\t%d-->",i+1);
		    while(now != nullptr){
		    	fprintf(logout," <%s,%s>",now->getName().c_str(),now->getType().c_str());
		        //cout<<"<"<<now->getName()<<","<<now->getType()<<"> ";
		        now = now->getNext();
		    }
		    fprintf(logout,"\n");
		    //cout<<endl;
            }
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


class symbol_table
{
private:
    scope_table* current = nullptr;
    int scope_table_count;

public:
    symbol_table(){
	scope_table_count=0;
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

    void enterScope(int n)
    {
    	scope_table_count++;
    	scope_table* st = new scope_table(n,scope_table_count);
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

    void printAllScopeTable(FILE* logout)
    {
        scope_table* now = current;
        while(now !=nullptr)
        {
            now->print(logout);
            now = now->getPr();
        }
    }
};

