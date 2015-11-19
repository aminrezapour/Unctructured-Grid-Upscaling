//reform input data from MP to 2P format for connection list
#include <iostream>
#include <fstream>

using namespace std;

void main()  {

	ifstream in("connectivity.in");
	ofstream out("connectivity.txt");

	int nConn;
	int itemp;
	int a;
	double dtemp;
	int b;
	double T;	

	in>>nConn;
	out<<nConn<<endl;

	for (int i=0; i<nConn; i++)  {
		in>>itemp>>a>>dtemp>>b>>T;
		out<<a<<"\t"<<b<<"\t"<<T<<endl;
	}
}
