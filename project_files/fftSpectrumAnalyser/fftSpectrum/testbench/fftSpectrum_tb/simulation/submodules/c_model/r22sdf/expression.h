// ================================================================================
// Legal Notice: Copyright (C) 1991-2007 Altera Corporation
// Any megafunction design, and related net list (encrypted or decrypted),
// support information, device programming or simulation file, and any other
// associated documentation or information provided by Altera or a partner
// under Altera's Megafunction Partnership Program may be used only to
// program PLD devices (but not masked PLD devices) from Altera.  Any other
// use of such megafunction design, net list, support information, device
// programming or simulation file, or any other related documentation or
// information is prohibited for any other purpose, including, but not
// limited to modification, reverse engineering, de-compiling, or use with
// any other silicon devices, unless such use is explicitly licensed under
// a separate agreement with Altera or a megafunction partner.  Title to
// the intellectual property, including patents, copyrights, trademarks,
// trade secrets, or maskworks, embodied in any such megafunction design,
// net list, support information, device programming or simulation file, or
// any other related documentation or information provided by Altera or a
// megafunction partner, remains with Altera, the megafunction partner, or
// their respective licensors.  No other licenses, including any licenses
// needed under any third party's intellectual property, are provided herein.
// ================================================================================
//
#ifndef EXPRESSION_H
#define EXPRESSION_H
#define ADD 0
#define SUB 1
#define MULT 2
#include <iostream>
using namespace std;

class fpCompiler;

class expression{
 public:
  expression(fpCompiler* lop_, fpCompiler* rop_, int op_);
  expression(expression const &other);
  ~expression();

  fpCompiler* getLop();
  fpCompiler* getRop();
  int getOp() ;

  expression  operator=( const expression& num);

 private:
  void copy(expression const &other);
  fpCompiler* lop;
  fpCompiler* rop;
  int op;

};
#endif


