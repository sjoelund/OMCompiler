// University of Illinois/NCSA
// Open Source License

// Copyright (c) 2003-2010 University of Illinois at Urbana-Champaign.
// All rights reserved.

// Developed by:

//     LLVM Team

//     University of Illinois at Urbana-Champaign

//     http://llvm.org

// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal with
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
// of the Software, and to permit persons to whom the Software is furnished to do
// so, subject to the following conditions:

//     * Redistributions of source code must retain the above copyright notice,
//       this list of conditions and the following disclaimers.

//     * Redistributions in binary form must reproduce the above copyright notice,
//       this list of conditions and the following disclaimers in the
//       documentation and/or other materials provided with the distribution.

//     * Neither the names of the LLVM Team, University of Illinois at
//       Urbana-Champaign, nor the names of its contributors may be used to
//       endorse or promote products derived from this Software without specific
//       prior written permission.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
// CONTRIBUTORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS WITH THE
// SOFTWARE.


/*Adapted from the LLVM tutorial, thereby the license.*/

#ifndef LLVM_EXECUTIONENGINE_ORC_OMCJIT_H
#define LLVM_EXECUTIONENGINE_ORC_OMCJIT_H

#include "llvm/ADT/STLExtras.h"
#include "llvm/ExecutionEngine/ExecutionEngine.h"
#include "llvm/ExecutionEngine/JITSymbol.h"
#include "llvm/ExecutionEngine/RTDyldMemoryManager.h"
#include "llvm/ExecutionEngine/SectionMemoryManager.h"
#include "llvm/ExecutionEngine/Orc/CompileUtils.h"
#include "llvm/ExecutionEngine/Orc/IRCompileLayer.h"
#include "llvm/ExecutionEngine/Orc/LambdaResolver.h"
#include "llvm/ExecutionEngine/Orc/RTDyldObjectLinkingLayer.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/Mangler.h"
#include "llvm/Support/DynamicLibrary.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Target/TargetMachine.h"
#include <algorithm>
#include <memory>
#include <string>
#include <vector>


namespace llvm {
namespace orc {

class OMCJIT {
private:
  std::unique_ptr<TargetMachine> TM;
  DataLayout DL;
  RTDyldObjectLinkingLayer ObjectLayer;
  IRCompileLayer<decltype(ObjectLayer), SimpleCompiler> CompileLayer;

public:
  using ModuleHandle = decltype(CompileLayer)::ModuleHandleT;

 OMCJIT()
   	:
  TM{EngineBuilder().selectTarget()}
  , DL{TM->createDataLayout()}
  ,ObjectLayer{[]() { return std::make_shared<SectionMemoryManager>(); }}
  ,CompileLayer{ObjectLayer, SimpleCompiler(*TM)}
		  {
			//Load host process.
			llvm::sys::DynamicLibrary::LoadLibraryPermanently(nullptr);
		  }

  TargetMachine &getTargetMachine() { return *TM; }

  ModuleHandle addModule(std::unique_ptr<Module> M) {

    auto Resolver = createLambdaResolver(
        [&](const std::string &Name) {
          if (auto Sym = CompileLayer.findSymbol(Name, false))
            return Sym;
		  return JITSymbol(nullptr);
        },
        [](const std::string &Name) {
		  /*We first search the JIT runtime (This have to be kept separate from the simulation runtime for now.)*/
		  auto SymAddr = RTDyldMemoryManager::getSymbolAddressInProcess(Name+"_jit");
		  if (SymAddr) {
            return JITSymbol(SymAddr, JITSymbolFlags::Exported);
		  } else {
			SymAddr = RTDyldMemoryManager::getSymbolAddressInProcess(Name);/*Ugly workaround...*/
			if (SymAddr) {
			  return JITSymbol(SymAddr, JITSymbolFlags::Exported);
			}
		  }
          return JITSymbol(nullptr);
        });

    // Add the set to the JIT with the resolver we created above and a newly
    // created SectionMemoryManager.
    return cantFail(CompileLayer.addModule(std::move(M),
                                           std::move(Resolver)));
  }

  JITSymbol findSymbol(const std::string Name) {
    std::string MangledName;
    raw_string_ostream MangledNameStream(MangledName);

    Mangler::getNameWithPrefix(MangledNameStream, Name, DL);

	JITSymbol jSym = CompileLayer.findSymbol(MangledNameStream.str(), true);

	return jSym;
  }

  void removeModule(ModuleHandle H) {
    cantFail(CompileLayer.removeModule(H));
  }
};
} // end namespace orc
} // end namespace llvm
#endif // LLVM_EXECUTIONENGINE_ORC_OMCJIT_H
