#include "llvm_gen_util.hpp"

extern "C"
{
  //Non template functions.
  /* Given a binary operation on the form dest = lhs OP rhs as llvm::StringRef's
    fetch l,r,d from the symbol table.
    For lhs and rhs the corresponding load instructions are created.
  */
  void binopInit(llvm::StringRef lhs, llvm::StringRef rhs,
                 llvm::StringRef dest,llvm::Value *&l, llvm::Value *&r, llvm::Value *&d)
  {
    l = program->currentFunc->symTab[lhs];
    r = program->currentFunc->symTab[rhs];
    d = program->currentFunc->symTab[dest];
    l = program->builder.CreateLoad(l,l->getName());
    r = program->builder.CreateLoad(r,r->getName());
  }

  llvm::Type *getLLVMType2(const uint8_t type,const char* structName="")
  {
    switch(type) {
    case MODELICA_INTEGER: return llvm::Type::getIntNTy(program->context,BITS);
    case MODELICA_BOOLEAN: return llvm::Type::getInt1Ty(program->context);
    case MODELICA_REAL: return llvm::Type::getDoubleTy(program->context);
    case MODELICA_METATYPE: return llvm::Type::getInt8PtrTy(program->context);
    case MODELICA_TUPLE: return program->module->getTypeByName(structName);
    case MODELICA_VOID: return llvm::Type::getVoidTy(program->context);
    case MODELICA_INTEGER_PTR: return llvm::Type::getIntNPtrTy(program->context,BITS);
    case MODELICA_BOOLEAN_PTR: return llvm::Type::getInt1PtrTy(program->context);
    case MODELICA_REAL_PTR: return llvm::Type::getDoublePtrTy(program->context);
    case MODELICA_METATYPE_PTR: return llvm::PointerType::get(llvm::Type::getInt8PtrTy(program->context), 0);
    case MODELICA_TUPLE_PTR: return nullptr; //TODO! not supported.
    default: fprintf(stderr,"Attempted to deduce unknown type:%u\n",type); return nullptr;
    }
  }

  /*Map type to stack alignment in bytes (llvm align) */
  unsigned short getAlignment(llvm::Type *type)
  {
    if (type == getLLVMType2(MODELICA_METATYPE)) {
      return 8;
    } else if (type == getLLVMType2(MODELICA_INTEGER)) {
      return 8;
    } else if (type == getLLVMType2(MODELICA_REAL)) {
      return 8;
    } else if  (type == getLLVMType2(MODELICA_BOOLEAN)) {
      return 1;
    } else if (type == getLLVMType2(MODELICA_TUPLE)) {
      //TODO add struct parameter, does however seem to work but can give problems.
      fprintf(stderr,"TODO SIZE OF STRUCT REQUESTED, NOT SUPPORTED!\n");
    }
    return 8; //All other types should have 8. Yes Linux only probably..
  }
  /*For Debugging*/
  const char *getModeicaLLVMTypeString(const uint8_t ty) {
    switch(ty) {
    case MODELICA_INTEGER: return "MODELICA_INTEGER";
    case MODELICA_BOOLEAN: return "MODELICA_BOOLEAN";
    case MODELICA_REAL: return "MODELICA_REAL";
    case MODELICA_METATYPE: return "MODELICA_METATYPE";
    case MODELICA_TUPLE: return "MODELICA_TUPLE";
    case MODELICA_VOID: return "MODELICA_VOID";
    case MODELICA_INTEGER_PTR: return "MODELICA_INTEGER_PTR";
    case MODELICA_BOOLEAN_PTR: return "MODELICA_BOOLEAN_PTR";
    case MODELICA_REAL_PTR: return "MODELICA_REAL_PTR";
    case MODELICA_METATYPE_PTR: return "MODELICA_METATYPE_PTR";
    default: fprintf(stderr,"Attempted to deduce unknown type:%u\n",ty); return nullptr;
    }
  }

  /*For debugging. Print all keys in the symbol table */
  void printSymbolTable() {
    fprintf(stderr,"Keys in symbol table:\n");
    for(const auto &p : program->currentFunc->symTab) {
      fprintf(stderr,"%s\n",p.first.c_str());
    }
    fprintf(stderr,"\n");
  }
  /*Helper function to create the different kinds of alloca instructions.
    Also referenced in createFunctionBody */
  llvm::AllocaInst *createAllocaInst(llvm::StringRef name,llvm::Type *type)
  {
    DBG("create allocaInst for:%s\n",name,__LINE__);
    llvm::AllocaInst *ai {program->builder.CreateAlloca(type,0,name)};
    if (!type) {
      fprintf(stderr,"Attempted allocation with unknown type\n");
      return nullptr;
    }
    if (type == getLLVMType2(MODELICA_TUPLE)) {
      //The size of the struct alloca type is the same as the size of it's largest member?
      llvm::StructType *sType = llvm::cast<llvm::StructType>(type);
      unsigned short maxVal = 0;
      for (auto &m : sType->elements()) {
        maxVal = std::max(maxVal,getAlignment(m));
      }
    } else {
      ai->setAlignment(getAlignment(type));
    }
    return ai;
  }

  llvm::Value *createLoadInst(const char *dest)
  {
    DBG("Create load instruction with dest:%s\n line %d of file \"%s\".\n",dest,__LINE__, __FILE__);
    llvm::AllocaInst *ai {program->currentFunc->symTab[dest]};
    llvm::LoadInst *li = program->builder.CreateLoad(ai,ai->getName());
    li->setAlignment(ai->getAlignment());
    DBG("Load instruction created\n");
    return li;
  }

  void createStoreInst(llvm::Value* val, const char *dest)
  {
    DBG("Create store instruction with dest:%s line %d of file \"%s\".\n",dest,__LINE__, __FILE__);
    llvm::AllocaInst *ai {program->currentFunc->symTab[dest]};
    if (!ai) {
      fprintf(stderr,"No variable named:%s in symboltable\n",dest);
      printSymbolTable();
      ai = program->currentFunc->symTab[dest];
    }
    llvm::StoreInst *si {program->builder.CreateStore(val,ai)};
    si->setAlignment(ai->getAlignment());
  }

} //End extern C;
