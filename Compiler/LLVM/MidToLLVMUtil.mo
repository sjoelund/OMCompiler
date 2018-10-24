encapsulated package MidToLLVMUtil
import MidCode;
import CodegenUtil.{underscorePath,dotPath};
import Tpl.{Text,textString};
import Util;
import List;
import System;
import EXT_LLVM;

function funcsAreJitCompiled
  input list<Absyn.Path> funcNames;
  output Boolean b;
algorithm
  b := Util.boolAndList(List.map(funcNames,funcIsJitCompiled));
end funcsAreJitCompiled;

function funcIsJitCompiled
  "Checks if there exists a handler to a function with the given Absyn.path."
  input Absyn.Path fName;
  output Boolean b;
protected
  String fString;
algorithm
  fString := textString(underscorePath(Tpl.MEM_TEXT({},{}),fName));
  b := EXT_LLVM.funcIsJitCompiled(fString);
end funcIsJitCompiled;

//Note that this function maybe should be in there own file, ValueToMid or something like that.
function valLstToMidVarLst
  input list<Values.Value> valLst;
  output list<MidCode.Var> midVarLst;
  algorithm
  midVarLst := List.map(valLst,valueToMidVar);
end valLstToMidVarLst;

function valueToMidVar
  input Values.Value val;
  output MidCode.Var midVar;
algorithm
//  print(anyString(val) + "\n");
  midVar := MidCode.VAR("_tmp_" + intString(System.tmpTickIndex(46)),ValuesUtil.valueExpType(val),false);
end valueToMidVar;

function insertDBGPrintIntoIR
  "Debuggning function, inserts a call to printf that prints A"
algorithm
  EXT_LLVM.genCallArgConstInt(1);
  EXT_LLVM.genCall(name="printf",functionTy=1/*ModelicaInteger*/,dest="",assignment=false,isVariadic=true);
end insertDBGPrintIntoIR;

/*For tests to be removed*/
function genRandomLst
  input Integer siz;
  output list<Integer> lst = {};
algorithm
  for i in 1:siz loop
	lst := System.intRand(siz) :: lst;
  end for;
end genRandomLst;

//Just for preformance test. To be removed.
function genRandomArray
  input output Real [:] inArr;
protected
  Integer ix = 1;
  Integer siz;
  Integer randInt = 0;
algorithm
  siz := size(inArr,1);
  for i in 1:siz loop
    randInt := realInt(System.intRand(siz));
	inArr[ix] := randInt;
	ix := ix + 1;
  end for;
end genRandomArray;

annotation(__OpenModelica_Interface="backendInterface");
end MidToLLVMUtil;