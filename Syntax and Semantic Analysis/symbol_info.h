#pragma once

#include <bits/stdc++.h>
using namespace std;


class symbol_info
{
private:
    string name ;
    string type ;
    symbol_info *next = nullptr;
    
    string rule_name;
    string space;
    int start_line;
    int finish_line;
    //string lexeme_name;
    vector<symbol_info*>v;
    vector<pair<string,string>>List;
    
    string is;

public:


    symbol_info(string name, string type){
        this->name = name;
        this->type = type;
        is="";
    }
    symbol_info(){

    }
    
    symbol_info(string rule_name){
    	this->rule_name = rule_name;
    }
    
    ~symbol_info(){

    }
    
    
    
    void setIs(string s){
    	is = s;
    }
    void setRuleName(string name){
        rule_name = name;
    }
    void setSpace(string name){
        space = name;
    }
    void setStartLine(int name){
        start_line = name;
    }
    void setFinishLine(int name){
        finish_line = name;
    }
    string getIs(){return is;}
    string getRuleName(){
        return rule_name;
    }
    string getSpace(){
        return space;
    }
    int getStartLine(){
        return start_line;
    }
    int getFinishLine(){
        return finish_line;
    }
    void push(symbol_info* s){
        v.push_back(s);
    }
    symbol_info* getFirst(){
    	return v[0];
    }
    vector<symbol_info*> getVector(){
    	return v;
    }
    void pushElement(pair<string,string> p){
    	List.push_back(p);
    }
    vector<pair<string,string>> getList(){
    	return List;
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
