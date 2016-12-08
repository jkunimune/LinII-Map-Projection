// C-Map-Projections.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"  // standard library
#include <iostream>  // namespaces
#include <graphics.h> // graphics library
//#include <conio.h>    // ?
using namespace std;


typedef struct {
	double x, y;
	double m;
} Point;

typedef struct {
	signed int i, j;
	double k, rest;
} Spring;


static int numMasses;
static int numSprings;



void** generateGeodesicGrid(signed short int numIterate, signed short int numSprings, bool cutPM, string filename) {
	void** output = (void**) malloc(sizeof(void*));
	// TODO: initialize masses
	void* pointArray = malloc(sizeof(Point) * numMasses);
	void* springArray = malloc(sizeof(Spring) * numSprings);
	*(output + 0)             = pointArray;
	*(output + sizeof(void*)) = springArray;
	return output;
}


Point* simulateSprings(double tMax, double frmRate, Point* masses, Spring* springs) {
	// TODO: initialize animation
	double t_step = frmRate*tMax;
	Point* output = (Point*) malloc(sizeof(Point)*t_step*numMasses);
	return output;
}


void playAnimation(Point* input) {
	// TODO: display stuff
	return;
}



int main()
{
	cout << "begin" << endl;

	void** mesh = generateGeodesicGrid(2, 1, true, "weights/landmass.jpg");
	Point* masses = (Point*) *(mesh + 0);
	Spring* springs = (Spring*) *(mesh + sizeof(void*));

	Point* animation = simulateSprings(5, 60, masses, springs);

	playAnimation(animation);

	while (true)
	{
		printf("HA");
	}
	return 0;
}
