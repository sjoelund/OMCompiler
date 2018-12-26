encapsulated package MidCode

import DAE;
import DAEDump;

uniontype Program
  record PROGRAM
    String name;
    list<Function> functions;
  end PROGRAM;
end Program;

uniontype Var
  record VAR
    String name;
    DAE.Type ty;
    Boolean volatile "Used for setjmp semantics in C."; // Codegen detail that doesn't really belong in midcode.
  end VAR;
end Var;

uniontype VarBuf
  /*
  A MidCode variable containing a jmp_buf for longjmp.
  */
  record VARBUF
    String name;
  end VARBUF;
end VarBuf;

uniontype VarBufPtr
  /*
  A MidCode variable containing a jmp_buf pointer for longjmp.
  */
  record VARBUFPTR
    String name;
  end VARBUFPTR;
end VarBufPtr;

uniontype OutVar
  record OUT_VAR
    Var var;
  end OUT_VAR;
  record OUT_WILD end OUT_WILD;
end OutVar;

public
function varString
  input Var var;
  output String str;
algorithm
  str := "(" + DAEDump.daeTypeStr(var.ty) + ") " + var.name;
end varString;

uniontype Function
  record FUNCTION
    Absyn.Path name;
    list<Var> locals;
    list<VarBuf> localBufs; // jmb_buf for longjmp
    list<VarBufPtr> localBufPtrs; // jmb_buf pointers for longjmp
    list<Var> inputs;
    list<Var> outputs;
    list<Block> body;
    Integer entryId;
    Integer exitId;
  end FUNCTION;
end Function;

uniontype Block
  record BLOCK
  "Basic block.
  No control flow within block.
  Can branch or jump on exit, called the block's terminator."
    Integer id;
    list<Stmt> stmts;
    Terminator terminator;
  end BLOCK;
end Block;

uniontype Terminator
  record GOTO
    Integer next;
  end GOTO;

  record BRANCH
    Var condition;
    Integer onTrue;
    Integer onFalse;
  end BRANCH;
//In LLVM this would be more logical to have as a statement //John
  record CALL
    Absyn.Path func;
    Boolean builtin;
    list<Var> inputs;
    list<OutVar> outputs;
    Integer next;
	DAE.Type ty;
  end CALL;

  record RETURN
  end RETURN;

  record SWITCH
    Var condition;
    list<tuple<Integer,Integer>> cases;
  end SWITCH;

  record LONGJMP "used for fail() stmts"
  end LONGJMP;

  record PUSHJMP "used for match-continue fail() handling"
    VarBufPtr old_buf "where to save old jmp_buf";
    VarBuf new_buf "what to use as new jmp_buf";
    Integer next "where to goto next and the setjmp target";
  end PUSHJMP;

  /* POPJMP does not cause control flow but
     if it is a terminator to simplify matching
     with their respective PUSHJMPS.
  */
  record POPJMP "used for match-continue fail() handling"
    VarBufPtr old_buf "what to reset to";
    Integer next;
  end POPJMP;

  record ASSERT
    Var condition;
    Var message;
    Var level;
    Integer next;
  end ASSERT;

  record TERMINATE
    Var message;
  end TERMINATE;

end Terminator;

uniontype Stmt
  record NOP
  end NOP;

  record ASSIGN
    Var dest;
    RValue src;
  end ASSIGN;

  record ALLOCARRAY
    String func "runtime function to do the allocation";
    Var array "The array to be allocated";
    Var dimSize "Variable that describes the dimension of the allocation";
    list<Var> sizeOfDims "Specifies the size of the dimensions";
  end ALLOCARRAY;

end Stmt;

uniontype RValue

  record VARIABLE
    Var src;
  end VARIABLE;

  record UNARYOP
    UnaryOp op;
    Var src;
  end UNARYOP;

  record BINARYOP
    BinaryOp op;
    Var lsrc;
    Var rsrc;
  end BINARYOP;

  record LITERALINTEGER
    Integer value;
  end LITERALINTEGER;

  record LITERALREAL
    Real value;
  end LITERALREAL;

  record LITERALBOOLEAN
    Boolean value;
  end LITERALBOOLEAN;

  record LITERALSTRING
    String value;
  end LITERALSTRING;

  record LITERALMETATYPE
    list<Var> elements;
    DAE.Type ty;
  end LITERALMETATYPE;

  record LITERALARRAY
	"Represents T_ARRAY, e.g normal arrays for Scalars."
	list<RValue> elements; //As a list since we need to support multidimensional arrays.
	DAE.Type ty;
	DAE.Dimensions dims;
	//TODO extend with dimensions. ?
  end LITERALARRAY;

/*
CTOR    SLOTS
0       0       nil för list
0       1+      tuple
1       0       none för option
1       1       some för option
1       2       cons för list
2       0+      array
3+      0+      record
*/

  record UNIONTYPEVARIANT
    Var src;
  end UNIONTYPEVARIANT;

  record ISSOME
    Var src;
  end ISSOME;

  record ISCONS
    Var src;
  end ISCONS;

  record METAFIELD "get value from metamodelica object"
    Var src;
    Integer index;
    DAE.Type ty "type of value";
  end METAFIELD;

  record DEREFERENCE "Used to indicate that an array should be dereferenced"
	Var src;
	DAE.Type ty;
  end DEREFERENCE;

end RValue;

uniontype UnaryOp
  record MOVE
	DAE.Type originalType;
  end MOVE;
  record UMINUS end UMINUS;
  record NOT end NOT;
  record UNBOX end UNBOX;
  record BOX end BOX;
end UnaryOp;

uniontype BinaryOp
  record ADD end ADD;
  record SUB end SUB;
  record MUL end MUL;
  record DIV end DIV;
  record POW end POW;
  record LESS end LESS;
  record LESSEQ end LESSEQ;
  record GREATER end GREATER;
  record GREATEREQ end GREATEREQ;
  record EQUAL end EQUAL;
  record NEQUAL end NEQUAL;
end BinaryOp;

annotation(__OpenModelica_Interface="backendInterface");
end MidCode;
