#include "HexLagrangeBasis.h"
#include "HexReferenceSpace.h"
#include "pointsGenerators.h"
#include "ElementType.h"

HexLagrangeBasis::HexLagrangeBasis(size_t order){
  // If order 0 (Nedelec): use order 1
  if(order == 0)
    order = 1;

  // Set Basis Type //
  this->order = order;

  type = 0;
  dim  = 3;

  nVertex   =  8;
  nEdge     = 12 * (order - 1);
  nFace     =  6 * (order - 1) * (order - 1);
  nCell     =      (order - 1) * (order - 1) * (order - 1);
  nFunction = nVertex + nEdge + nFace + nCell;

  // Init polynomialBasis //
  lBasis = new polynomialBasis(ElementType::getTag(TYPE_HEX, order, false));

  // Init Lagrange Point //
  lPoint = new fullMatrix<double>(gmshGeneratePointsHexahedron(order, false));

  // Reference Space //
  refSpace  = new HexReferenceSpace;
  nRefSpace = getReferenceSpace().getNReferenceSpace();
}

HexLagrangeBasis::~HexLagrangeBasis(void){
  delete lBasis;
  delete lPoint;
  delete refSpace;
}
