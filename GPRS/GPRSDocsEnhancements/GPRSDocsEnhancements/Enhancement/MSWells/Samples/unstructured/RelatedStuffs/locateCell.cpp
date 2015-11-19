//find cell number by input coordinates (X,Y,Z)
#include <iostream>
#include <fstream>
#include <string>
#include <cmath>

using namespace std;

void loadWriteCoords(ifstream& in);
int getCellNo(double *Z, double &dist);

const int cellNum = 11578;

double coords[cellNum][3];

void main()  {
	string coordFileName = "CVxyz.in";
	ifstream in(coordFileName.c_str());
	//loadWriteCoords(in);

	//double coords[cellNum][3];
	int i;
	for (i=0; i<cellNum; i++)  {
		in>>coords[i][0]>>coords[i][1]>>coords[i][2];
	}

	ifstream inxyz("input.in");
	ofstream outxyz("output.txt");

	double Z[3];
	int cellIndex;
	double dd=10000.0;

	while (!inxyz.eof())  {
		inxyz>>Z[0]>>Z[1]>>Z[2];
		outxyz<<"input coords: "<<Z[0]<<"\t"<<Z[1]<<"\t"<<Z[2]<<"\n";
		cellIndex=getCellNo(Z,dd);	
		outxyz<<"Cell No.="<<cellIndex<<endl;
		outxyz<<"Cell coords: "<<Z[0]<<"\t"<<Z[1]<<"\t"<<Z[2]<<"\n";
		outxyz<<"distance="<<dd<<endl;
		outxyz<<"\n\n";
		//exit(0);
	}	
}

int getCellNo(double *Z, double &dist)  {
	double dd=1.0e+10;
	int index = 0;
	double temd=0;

	for (int i=0; i<cellNum; i++)  {
		temd = fabs(coords[i][0]-Z[0])+fabs(coords[i][1]-Z[1])
			+fabs(coords[i][2]-Z[2]);
		if (temd<dd)  {
			dd=temd;
			index = i;
		}
	}
	dist = 	dd;
	Z[0]=coords[index][0];
	Z[1]=coords[index][1];
	Z[2]=coords[index][2];
	return index;
}

void loadWriteCoords(ifstream& in)  {
	cout<<"loading CVxyz.in file & write to cellCoords.in with cell index\n";

	ofstream out("cellCoords.in");

	char str[80];

	for (int i=0; i<cellNum; i++)  {
		in.getline(str, 79);
		out<<i<<"\t"<<str<<endl;
	}
	cout<<"ending loading CVxyz.in file\n"; 
}