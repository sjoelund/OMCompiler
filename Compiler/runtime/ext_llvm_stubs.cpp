#ext_llvm.h

extern "C"
{
  void initGen(const char *) {}

  /* Functions called externally from Compiler/LLVM/MidToLLVM.mo */
  void* runJIT(void *valLst) {
    return nullptr;
  }

  int createFunctionProtArg(const uint8_t,const char *) {
    return 0;
  }

  void finishGen() {}

  void startFuncGen(const char *) {}

  int genFunctionType() {return 0;}

  int createFunctionPrototype(const char *) {return NULL;}

  int createFunctionBody(const char *) {return NULL;}

  int setNewActiveBlock(const modelica_integer) {return 0;}

  /*Functions to create misc instructions */
  int createStoreVarInst(const char *src, const char *) {return 0;}

  /*Function related */
  int createReturn(const char *){return 0;}

  int createExit(const modelica_integer exit_id){return 0;}

  int createCallArg(const char *){return 0;}

  int createCall(const char *, const uint8_t, const char *, modelica_boolean, modelica_boolean){return 0;}

  /* Unary instructions */
  int createIUminus(const char *src,const char *){return 0;}

  int createDUminus(const char *src, const char *){return 0;}

  int createNot(const char *src,const char *){return 0;}

  //Move instructions, e.g casts
  int createIntToDouble(const char*,const char*){return 0;}

  int createDoubleToInt(const char*,const char*){return 0;}

  int createIntToBool(const char*,const char*){return 0;}

  int createBoolToInt(const char*,const char*){return 0;}

  int createIntToMeta(const char*,const char*){return 0;}

  int createMetaToInt(const char*,const char*){return 0;}

  int createDoubleToBool(const char*,const char*){return 0;}

  int createBoolToDouble(const char*,const char*){return 0;}

  int createDoubleToMeta(const char*,const char*){return 0;}

  int createMetaToDouble(const char*,const char*){return 0;}

  int createDoubleToMeta(const char*,const char*){return 0;}

  /* Binary instructions */
  int createIAdd(const char *, const char *,const char *){return 0;}

  int createISub(const char *, const char *,const char *){return 0;}

  int createIMul(const char *, const char *,const char *){return 0;}

  int createIDiv(const char *, const char *,const char *){return 0;}

  int createIPow(const char *, const char *,const char *){return 0;}

  int createILess(const char *, const char *,const char *){return 0;}

  int createILESSQ(const char *, const char *,const char *){return 0;}

  int createIEqual(const char *, const char *,const char *){return 0;}

  int createINequal(const char *, const char *,const char *){return 0;}

  int createDAdd(const char* , const char *, const char *){return 0;}

  int createDSub(const char *, const char *, const char *){return 0;}

  int createDMul(const char *, const char *, const char *){return 0;}

  int createDDiv(const char *, const char *, const char *){return 0;}

  int createDPow(const char *, const char *, const char *){return 0;}

  int createDLess(const char *, const char *, const char *){return 0;}

  int createDLessq(const char *, const char *, const char *){return 0;}

  int createDEqual(const char *, const char *, const char *){return 0;}

  int createDNequal(const char *, const char *, const char *){return 0;}

  int createBAdd(const char * , const char *, const char *){return 0;}

  int createBSub(const char *, const char *, const char *){return 0;}

  int createBMul(const char *, const char *, const char *){return 0;}

  int createBBiv(const char *, const char *, const char *){return 0;}

  int createBPow(const char *, const char *, const char *){return 0;}

  int createBLess(const char *, const char *, const char *){return 0;}

  int createBLESSQ(const char *, const char *, const char *){return 0;}

  int createBEqual(const char *, const char *, const char *){return 0;}

  int createBNequal(const char *, const char *, const char *){return 0;}

  int createPow(const char *, const char *, const char *){return 0;}

  int storeLiteralInt64 (const modelica_integer,const char*){return 0;}

  int storeLiteralReal (const double,const char *){return 0;}

  int storeLiteralIntForPtrTy(const uint64_t addr,const char *dest){return 0;}
}
