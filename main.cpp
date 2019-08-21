/** Author: Martin Roebke 2018
Side project inspired by Mathematical Physics 05 - Carl Bender
https://www.youtube.com/watch?v=LMw0NZDM5B4

Implementation of a "long double"-precision-implementation
for computing convergence-criteria of continued exponentials.
The result is a human-readable output of integer values approximating the number of accumulation points
in a user defined rectangle with evenly distributed selectable resolution.

The results can be further visualized in additional (Mathematica) applications.

Pretty cool points:
		-2.5 + 1 I
		-1.3333333 + 2 I
*/

#include <iostream>
#include <iomanip>
#include <stdlib.h>
#include <complex>
#include <vector>
#include <limits>       // std::numeric_limits
#include <time.h>	    // Time Measurement

// constant long double
#define CLD const long double

//==============================================================
using namespace std;

/**Routine description:
Arguments:
Return Value:
*/
template<class T>
void calcVectorAtZ(T z, vector<T> *vec)
{
    T result = 1;
    for (typename vector<T>::iterator iter = vec->begin(); iter != vec->end(); ++iter)
    {
        result = exp(z * result);
        *iter = result; // Write result at position iter.
    }
}

/**Routine description:
Arguments:
Return Value:
 return 0: everything filled, nothing found
 return positive: found cycle over (0.0, 0.0)
 return negative: found NaN, calculation interrupted!
*/
int safeCalcLongAtZ(complex<long double> z, vector<complex<long double> > *myvec)
{
    complex<long double> func = 1.;     // Current value of function
    double safezero = pow(10., -18.);   // Null detection

    int n = 1;                          // Count the order
    for (vector<complex<long double> >::iterator iter = myvec->begin(); iter != myvec->end(); iter++)
    {
        ++n;
        func = exp(z * func);
        *iter = func;
        if (func != func)
        {
            // Found NaN:
            return -1;
        }
        if (abs(func) < safezero)
        {
            return n;
        }
    }
    return 0;
}

/**Routine description:
Arguments:
Return Value:
*/
int CycleDetectDLONG(vector<complex<long double> > *myvec, double eps = pow(10, -6), int mymax = 255)
{
    //    cout << "cycleDetect1 with eps= "<<eps<<endl;
    int result = 0;
    int last = myvec->size() - 1;
    complex<long double> lastElem = myvec->at(last);
    complex<long double> nowElem;
    for (int i = last - 1; i >= 0 && i >= last - mymax; --i)
    {
        ++result;
        nowElem = myvec->at(i);
        if (abs(nowElem - lastElem) < eps)
        {
            // cout << "cycleDetect1 with eps= "<<abs(myvec->at(i) - lastElem)<<endl;
            return result;
        }
    }
    return 0;
}

/** Helper function to manipulate output of values at z.
*/
template<class T, class S>
inline void printmy(T m, S z, bool printz = false)
{
    printz ? cout << m << " at z=" << z << '\n' : cout << m << " ";
}

/**Routine description: Handler function for calculation of different starting points.
Ranges:     endpoint=false

Output like normal reading direction:
maxIm - maxIm       first column Re @ maxIm
|minRe      |maxRe  second column
|           |
|minRe      |maxRe
minIm - minIm       last column
Arguments:
- minRe
- maxRe
- minIm
- maxIm
- numRe
- numIm
- myvec
- eps
Return Value:
*/
/**


*/
void calcMField(CLD minRe, CLD maxRe, CLD minIm, CLD maxIm,
                const unsigned int numRe, const unsigned int numIm,
                vector<complex<long double> > *myvec, double eps)
{
    if (minRe > maxRe || minIm > maxIm)
    {
        cout << "Invalid area " << minRe << "," << maxRe << " ; " << minIm << "," << maxIm << '\n';
        return;
    }

    // StartVal:
    const complex<long double> z0 = complex<long double>(minRe, maxIm);

    complex<long double> z = z0;
    CLD reD = (maxRe - minRe) / (long double)(1. + numRe);
    CLD imD = (maxIm - minIm) / (long double)(1. + numIm);

    int iksdeh;

    cout << "\ncalcMField [" << minRe << ", " << maxRe << "][" << minIm << ", " << maxIm << "]";
    cout << "\nd(Re)=" << reD << " d(Im)=" << imD << '\n';
    for (unsigned int imn = 0; imn < numIm; ++imn)
    {
        z = z0;
        z.imag(z.imag() - ((long double)imn)*imD);

        iksdeh = safeCalcLongAtZ(z, myvec);
        if (iksdeh == 0)
        {
            iksdeh = CycleDetectDLONG(myvec, eps);
        }
        cout << '\n';
        printmy(iksdeh, z);

        // Add dRe:
        for (unsigned int ren = 0; ren < numRe; ++ren)
        {
            z += reD;
            iksdeh = safeCalcLongAtZ(z, myvec);
            if (iksdeh == 0)
            {
                iksdeh = CycleDetectDLONG(myvec, eps);
            }
            printmy(iksdeh, z);
        }
    }
}

/**Routine description:
Arguments:
Return Value:
*/
inline void precision()
{
    CLD pi = std::acos(-1.L);
    std::cout << "'double' precision:          "
              << std::setprecision(std::numeric_limits<double>::digits10 + 1)
              << pi << '\n'
              << "'long double' precision:     "
              << std::setprecision(std::numeric_limits<long double>::digits10 + 1)
              << pi << '\n'
              << "size of long double: " << sizeof pi << '\n'
              << "size of double: " << sizeof((double)pi) << '\n';
}

/**Routine description:
Arguments:
Return Value:
*/
inline void mylimits()
{
    std::cout << std::boolalpha;
    std::cout << "Minimum value for long double: " << std::numeric_limits<long double>::min() << '\n';
    std::cout << "Maximum value for long double: " << std::numeric_limits<long double>::max() << '\n';
    std::cout << "epsilon for long double: " << std::numeric_limits<long double>::epsilon() << '\n';
    std::cout << "long double is signed: " << std::numeric_limits<long double>::is_signed << '\n';
    std::cout << "Non-sign bits in long double: " << std::numeric_limits<long double>::digits << '\n';
    std::cout << "long double has infinity: " << std::numeric_limits<long double>::has_infinity << '\n';
    string s_round;
    switch (std::numeric_limits<long double>::round_style)
    {
    case -1:
        s_round = "Rounding style cannot be determined at compile time";
        break;
    case 0:
        s_round = "Rounding style toward zero";
        break;
    case +1:
        s_round = "Rounding style to the nearest representable value";
        break;
    case 2:
        s_round = "Rounding style toward infinity";
        break;
    case 3:
        s_round = "Rounding style toward negative infinity";
        break;
    default:
        s_round = "COULD NOT DETERMINE R";
    }
    //round_indeterminate	-1	Rounding style cannot be determined at compile time
    //round_toward_zero	0	Rounding style toward zero
    //round_to_nearest	1	Rounding style to the nearest representable value
    //round_toward_infinity	2	Rounding style toward infinity
    //round_toward_neg_infinity	3	Rounding style toward negative infinity
    std::cout << "long double round_style: " << s_round << '\n';

}

/**Routine description:
Arguments:
Return Value:
*/
template <class T>
inline void printvec(vector<T> *vec)
{
    int  n = 1;
    cout << '\n';
    for (typename vector<T>::const_iterator iter = vec->begin(); iter != vec->end(); ++iter)
    {
        cout << n++ << ": " << *iter << " ";
    }
}

/**Routine description:
Arguments:
Return Value:
*/
int main(int argc, char *argv[])
{
    cout << "-------- Program to calculate Continued Exponential --------\n"
            "F(n) = exp(z * F(n-1)\n"
            "with dtype: long double.\n";

    precision();
    mylimits();

    // TestArea: =================================
    // =================================

    complex<long double> z1 = -2.475409836065573771 + 4.175609756097561132i;
    vector<complex<long double> > *testvec = new vector<complex<long double> >(10);
    int cycle = 0; // Saves exit code of the calculation.
    cycle = safeCalcLongAtZ(z1, testvec);
    cout << "Ergebnis Berechung: " << cycle;
    printvec(testvec);

    // Implementation: ===========================
    // ===========================================
    cout << "\n\nProceeding with specific calculation...";
    // Standard-Parameter:
    long double minRe = -1., maxRe = 0.5;
    long double minIm = 2., maxIm = 3.;

    unsigned int numRe = 20;
    unsigned int numIm = 20;

    double eps = pow(10, -16);
    unsigned int VECLENGTH = 1900;

    // Input of parameters via arguments:
    // arg: [minRe, maxRe, minIm, maxIm], [numRe, numIm], [eps], [VECLENGTH]

    if (argc <= 4)      // Show explanation for parameters and the input thereof
    {
        if (argc > 1) // User entered some parameters
            cout << "\nError parsing parameters: Using STANDARDPARAMETERS";

        cout << "\nInput of parameters via arguments:\narg: [min Real="
                << minRe << ", maxReal=" << maxRe << ", minImaginary=" << minIm
                << ", maxImaginary=" << maxIm << "], [ticks on real-axis=" << numRe << ", ticks on imag-axis="
                << numIm << "], [epsilon for zero-detection=" << eps
                << "], [maximum steps for computation at every point=" << VECLENGTH << "]" << '\n';
    }

    if (argc > 4)
    {
        minRe = atof(argv[1]);
        maxRe = atof(argv[2]);
        minIm = atof(argv[3]);
        maxIm = atof(argv[4]);
        if (argc > 6)
        {
            numRe = atof(argv[5]);
            numIm = atof(argv[6]);
            if (argc > 7)
            {
                eps = atof(argv[7]);
            }
            if (argc > 8)
            {
                VECLENGTH = atoi(argv[8]);
            }
        }
        cout << "\nusing eps= " << eps << "\nticks on real/imag axis: (" << numRe << ", " << numIm <<")"
             << "\nusing vector of length " << VECLENGTH;
    }

    vector<complex<long double> > *implVec = new vector<complex<long double> >(VECLENGTH);

    calcMField(minRe, maxRe, minIm, maxIm, numRe, numIm, implVec, eps);

    return 0;
}
