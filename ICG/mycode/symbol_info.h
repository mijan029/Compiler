#pragma once

#include <bits/stdc++.h>
using namespace std;


class symbol_info
{
private:
    string name ;
    string type ;
    symbol_info *next = nullptr;
    int isArray;
    int offset;
    //int global;

public:

    string code;
    int value;
    int global;
    int arrPos;
    string level_1;
    string level_2;
    string level_3;
    string level_4;
    symbol_info(string name, string type){
        this->name = name;
        this->type = type;
        isArray = 0;
        code = "";
        offset=0;
        value=0;
        global=0;
        arrPos=0;
        level_1 = level_2 = level_3 = level_4 = "";
    }
    symbol_info(){
        isArray = 0;
        code = "";
        offset=0;
        value=0;
        global=0;
        arrPos=0;
        level_1 = level_2 = level_3 = level_4 = "";
    }
    

    
    ~symbol_info(){

    }
    
    
    
    void setIsArray(int n){
    	isArray = n;
    }
    
    int getIsArray(){
        return isArray;
    }
    void setOffset(int n){
    	offset = n;
    }
    
    int getOffset(){
        return offset;
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
