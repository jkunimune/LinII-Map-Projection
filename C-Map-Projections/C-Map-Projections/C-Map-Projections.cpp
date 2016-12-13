// C-Map-Projections.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"  // standard library
#include <iostream>  // namespaces
#include <graphics.h> // graphics library
//#include <conio.h>    // ?
using namespace std;


typedef struct {
	double x, y, z;
} CartPt;

typedef struct {
	double x, y;
	double m;
} Point;

typedef struct {
	signed int i, j;
	double k, rest;
} Spring;


const double PHI = (1 + sqrt(5)) / 2;

static int numMasses;
static int numSprings;


CartPt newCart(double x0, double y0, double z0) {
	CartPt output;
	output.x = x0;
	output.y = y0;
	output.z = z0;
}


void** generateGeodesicGrid(signed short int numIterate, signed short int numSprings, bool cutPM, string filename) {
	/** generates a geodesic grid with weights based on filename
	  * numIterate: number of points is 10 * 4 ^ numIterate
	  * numSprings: points will be attached to all springs within a radius of numSprings.
	  * filename : the name of the file that contains the weights data
	  * cutPM : should the prime meridian be cut?
	  * returns: a pointer array of length two, pointing to Points and Springs
	  * Points : an nx3 array where each row is a point, [x0, y0, m]
	  * Springs : an mx4 array where each row is a spring, [i, j, k, l0]
	  */
	void** output = (void**)malloc(sizeof(void*));

	const double p = PHI / hypot(1, PHI);
	const double o = 1 / hypot(1, PHI);

	CartPt ptsOld[] = {
		newCart(0, p, o),
		newCart(0, -p, o),
		newCart(0, p, -o),
		newCart(0, -p, -o),
		newCart(o, 0, p),
		newCart(-o, 0, p),
		newCart(o, 0, -p),
		newCart(-o, 0, -p),
		newCart(p, o, 0),
		newCart(-p, o, 0),
		newCart(p, -o, 0),
		newCart(-p, -o, 0)
	};
	
	unsigned int TriOld[] = {
		1, 9, 3,
		1, 3, 10,
		1, 10, 6,
		1, 6, 5,
		1, 5, 9,
		2, 4, 11,
		2, 11, 5,
		2, 5, 6,
		2, 6, 12,
		2, 12, 4,
		3, 9, 7,
		3, 7, 8,
		3, 8, 10,
		4, 12, 8,
		4, 8, 7,
		4, 7, 11,
		5, 11, 9,
		6, 10, 12,
		7, 9, 11,
		8, 12, 10
	};
	numSprings = 12;
	int numFaces = 20;

	for (int i = 0; i < numIterate; i ++) {
		numFaces = size(TriOld, 1);

	PtsNew = [PtsOld; zeros(numFaces * 3, 3)];
	TriNew = zeros(numFaces * 4, 3);
	p_i = numPoints + 1;
	t_i = 1;

	for j = 1:size(TriOld, 1)
		Face = TriOld(j, :);

	% add the midpoint of each line to the grid
		PtsNew(p_i, :) = (PtsOld(Face(1), :) + PtsOld(Face(2), :)) / 2;
	PtsNew(p_i, :) = PtsNew(p_i, :) / norm(PtsNew(p_i, :));
	p_i = p_i + 1;
	PtsNew(p_i, :) = (PtsOld(Face(2), :) + PtsOld(Face(3), :)) / 2;
	PtsNew(p_i, :) = PtsNew(p_i, :) / norm(PtsNew(p_i, :));
	p_i = p_i + 1;
	PtsNew(p_i, :) = (PtsOld(Face(3), :) + PtsOld(Face(1), :)) / 2;
	PtsNew(p_i, :) = PtsNew(p_i, :) / norm(PtsNew(p_i, :));
	p_i = p_i + 1;

	% add new triangles with the new vertices
		TriNew(t_i, :) = [Face(1), p_i - 3, p_i - 1];
	t_i = t_i + 1;
	TriNew(t_i, :) = [Face(2), p_i - 2, p_i - 3];
	t_i = t_i + 1;
	TriNew(t_i, :) = [Face(3), p_i - 1, p_i - 2];
	t_i = t_i + 1;
	TriNew(t_i, :) = [p_i - 3, p_i - 2, p_i - 1];
	t_i = t_i + 1;
	end

		% now remove duplicates
		PtsOld = PtsNew;
	PtsNew = zeros(numPoints + numFaces * 3 / 2, 3);
	p_i = 1;
	for j_old = 1:size(PtsOld, 1)
		[~, j_new] = ismember(PtsOld(j_old, :), PtsNew, 'rows');
	if j_new == 0
		PtsNew(p_i, :) = PtsOld(j_old, :);
	j_new = p_i;
	p_i = p_i + 1;
	else
		end

		for k = 1:size(TriNew, 1) % update all references
			for l = 1 : size(TriNew, 2)
				if TriNew(k, l) == j_old
					TriNew(k, l) = j_new;
	end
		end
		end
		end

		PtsOld = PtsNew;
	TriOld = TriNew;

	end

		Img = rgb2gray(imread(filename));   % load the image
		[img_H, img_W] = size(Img);

	COLORMAP = [...
		linspace(.5, 0, 10).', linspace(.5,0,10).', ones(10, 1); ...
		zeros(10, 1), linspace(1, .5, 10).', zeros(10,1)];

		% build the output arrays
		Points = zeros(size(PtsOld, 1), 3);
	Springs = zeros(size(TriOld, 1) * 3 / 2, 4);
	s_i = 1;
	for i = 1:size(PtsOld, 1) % assign mass
		LatLon = getLatLon(PtsOld(i, :));
	idx1 = int32((pi / 2 - LatLon(1)) / pi*img_H) + 1;
	idx2 = int32((LatLon(2) + pi) / (2 * pi)*img_W) + 1;
	if idx1 >= img_H
		idx1 = img_H;
	end
		if idx2 >= img_W
			idx2 = img_W;
	end
		mass = double(Img(idx1, idx2) + 10) / 265.0;
	ph = LatLon(1);
	th = LatLon(2);
	Points(i, :) = [th / 1.7, (1 + sqrt(2) / 2)*tan(ph / 2) / 1.7, mass];
	end
		for i = 1:size(TriOld, 1) % assign spring constants
			for j = 1 : 3
				v1 = TriOld(i, j);
	v2 = TriOld(i, mod(j, 3) + 1);
	if v1 < v2
		P1 = PtsOld(v1, :);
	P2 = PtsOld(v2, :);
	there_should_be_a_spring = ...
		~cut || ...
		(P1(2)<0) == (P2(2)<0) || ...
		P1(1) > 0 || P2(1) > 0;
	if there_should_be_a_spring
		m1 = Points(v1, 3);
	m2 = Points(v2, 3);
	k = (m1 + m2);
	else
		k = 0;
	end
		d = pdist([PtsOld(v1, :); PtsOld(v2, :)]);
	Springs(s_i, :) = [v1, v2, k, d];
	s_i = s_i + 1;
	end
		end
		end

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
	while (true)
	{
		printf("HA");
	}
}



int main()
{
	cout << "begin" << endl;

	void** mesh = generateGeodesicGrid(2, 1, true, "weights/landmass.jpg");
	Point* masses = (Point*) *(mesh + 0);
	Spring* springs = (Spring*) *(mesh + sizeof(void*));

	Point* animation = simulateSprings(5, 60, masses, springs);

	playAnimation(animation);
	
	return 0;
}
