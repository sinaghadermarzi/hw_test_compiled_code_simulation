#include <iostream> 
#include <string> 
#include "gates.h"

using namespace std;

#define n_PI 6
#define n_NET 14


string net_lbl[n_NET] = {"g" ,"a" ,"b" ,"l" ,"i" ,"m" ,"j" ,"h" ,"c" ,"d" ,"n" ,"k" ,"e" ,"f" };
int PI[n_PI] = {1,2,8,9,12,13};
char net[n_NET];

void propagate()
{
	net[1]	=	AND2( net[2] , net[3] );
	net[7]	=	OR2( net[10] , net[13] );
	net[8]	=	AND2( net[1] , net[9] );
	net[5]	=	OR2( net[8] , net[10] );
	net[12]	=	OR2( net[8] , net[14] );
	net[4]	=	OR2( net[1] , net[5] );
	net[11]	=	AND2( net[5] , net[12] );
	net[6]	=	AND2( net[4] , net[7] );
}
