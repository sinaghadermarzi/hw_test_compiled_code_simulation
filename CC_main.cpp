#include <string>
#include <iostream>
#include <fstream>
#include <sstream>
#include "prop.h"


using namespace std;


int main()
{
	int time[100];
	
	char vect_in[100][n_PI];

	string line;
	int i;
	string temp,time_str, vect_in_str;
	ifstream vect_in_file("vectors.txt");
	int index=0;
	while(getline(vect_in_file,line))
	{
		stringstream line_strm(line);
		getline(line_strm,temp,'@');
		getline(line_strm,time_str,' ');
		getline(line_strm,vect_in_str);
		cout<<time_str<<","<<vect_in_str<<";"<<endl;
		for(i=0 ; i < n_PI ;i++)
		{
			if(vect_in_str.at(i)=='0')vect_in[index][i] = 0;
			else 
				if (vect_in_str.at(i)=='1')vect_in[index][i] = 1;
				else
					vect_in[index][i] = -1;
		}
		time[index] = stoi(time_str);
		index++;
	}
	int vect_count = index;
	cout<<vect_count;
	int j = 0;
	for (i = 0 ; i< vect_count ; i++)
	{
		cout<<"@"<<time[i];
		for (j = 0 ; j < n_PI; j++)
		{
			cout<<vect_in[i][j]+0;
		}
		cout<<endl;
	}
	



	ofstream log_file("log.txt",ofstream::out); 
	for(index = 0 ; index <vect_count ; index++)
	{
		//initialize primary inputs with current vector
		for(i = 0; i<n_PI;i++)
		{
			net[PI[i]] = vect_in[index][i];
		}
		//propagate;
		propagate();
		//
		log_file<<"@"<<time[index]<<"\t";
		for(i = 0; i < n_NET; i++)
		{
			log_file<<net_lbl[i]<<" = "<<(net[i]+0)<<" , "; 
			if(i != n_NET-1)
				log_file<<" , ";
		}
	
	}
	log_file.close();

	cin.ignore();
}
