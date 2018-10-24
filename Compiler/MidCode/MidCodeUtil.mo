/*
 * This file is part of OpenModelica.
 *
 * Copyright (c) 1998-2018, Open Source Modelica Consortium (OSMC),
 * c/o Linköpings universitet, Department of Computer and Information Science,
 * SE-58183 Linköping, Sweden.
 *
 * All rights reserved.
 *
 * THIS PROGRAM IS PROVIDED UNDER THE TERMS OF GPL VERSION 3 LICENSE OR
 * THIS OSMC PUBLIC LICENSE (OSMC-PL) VERSION 1.2.
 * ANY USE, REPRODUCTION OR DISTRIBUTION OF THIS PROGRAM CONSTITUTES
 * RECIPIENT'S ACCEPTANCE OF THE OSMC PUBLIC LICENSE OR THE GPL VERSION 3,
 * ACCORDING TO RECIPIENTS CHOICE.
 *
 * The OpenModelica software and the Open Source Modelica
 * Consortium (OSMC) Public License (OSMC-PL) are obtained
 * from OSMC, either from the above address,
 * from the URLs: http://www.ida.liu.se/pr OpenModelica distribution.
 * GNU version 3 is obtained from: http://www.gnu.org/copyleft/gpl.html.
 *
 * This program is distributed WITHOUT ANY WARRANTY; without
 * even the implied warranty of  MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE, EXCEPT AS EXPRESSLY SET FORTH
 * IN THE BY RECIPIENT SELECTED SUBSIDIARY LICENSE CONDITIONS OF OSMC-PL.
 *
 * See the full OSMC Public License conditions for more details.
 *
*/

encapsulated package MidCodeUtil
protected
import MidCode;
import SimCode.{RecordDeclaration};
import DAE;
import DAEDump;
import FCore;
import HashTableStringToPath;
import Absyn;
import List;
public
// function updateCache /*TODO: change name move to FCore at some point.*/
//   "Yet another retrofit function Get existing cache. Replace it with a MidCode cache."
//   input output FCore.Cache cache;
//   input list<MidCode.Function> midfuncs;
// protected
//   DAE.FunctionTree tree;
// algorithm
//   /*Get the current key value pairs*/
//   tree := FCore.getFunctionTree(cache);
// //  print("DEBUG:" + anyString(midfuncs) + "\n");
//   /*Replace the cache with a new cache containing the MidCode functions that where added*/
//   cache := match cache
//  	local
//  	  Mutable<DAE.FunctionTree> ef;
//  	case FCore.CACHE(_,ef,_,_,_)
//       algorithm
//  	    Mutable.update(ef,addFunctions(midfuncs, Mutable.access(ef)));
//      then cache;
//     else algorithm print("Failed to update cache\n"); then fail();
//  end match;
// end updateCache;

// function addFunctions
//   "Adds function(s) to the cache, we save both
//   SOME of the current DAE function (retrofitting..)  and SOME of the
//   MidCode functions.."
//   input list<MidCode.Function> funcs;
//   input output DAE.FunctionTree functionTree;
// protected
//   tuple<Option<DAE.Function>,Option<MidCode.Function>> fp;
// algorithm
//   for f in funcs loop
// 	fp := (functionTree.get(functionTree,f.name),SOME(f));
// 	functionTree := addPair(functionTree,f.name,fp);
//   end for;
// end addFunctions;

// function getFunctionDependencies
// "Returns all function dependencies as paths, also the main function and the function tree"
//   input FCore.Cache cache;
//   input Absyn.Path functionName;
//   output MidCode.Function mainFunction "the main function";
//   output list<Absyn.Path> dependencies "the dependencies as paths";
//   output DAE.FunctionTree funcs "the function tree";
// algorithm
//   funcs := FCore.getFunctionTree(cache);
//   // First check if the main function exists... If it does not it might be an interactive function...
//   mainFunction := getNamedFunction(functionName, funcs);
//   dependencies := getCalledFunctionsInFunction(functionName,funcs);
// end getFunctionDependencies;

// function getCalledFunctionsInFunction
// "Traverse MidCode, return all absyn.paths for all MidCode.CALL terminators."
//   input Absyn.Path path "The path to the function we are checking depdencies for";
//   input DAE.FunctionTree funcs "The MidCode function tree";
//   output list<Absyn.Path> outPaths "Path to all dependencies";
// protected
//    HashTableStringToPath.HashTable ht;
// algorithm
//   ht := HashTableStringToPath.emptyHashTable();
//   ht := getCalledFunctionsInFunction2(path,Absyn.pathStringNoQual(path),ht,funcs);
//   outPaths := BaseHashTable.hashTableValueList(ht);
// end getCalledFunctionsInFunction;

// function getCalledFunctionsInFunctionsCollector "Goes through the given DAE, finds the given functions and collects
//   the names of the functions called from within those functions"
//   input list<Absyn.Path> paths;
//   input HashTableStringToPath.HashTable inHt;
//   input DAE.FunctionTree funcs;
//   output HashTableStringToPath.HashTable outHt;
// // algorithm
// //   outHt := match (paths, inHt, funcs)
// //     local
// //       list<Absyn.Path> rest;
// //       Absyn.Path path;
// //       HashTableStringToPath.HashTable ht;
// //     case ({}, ht, _) then ht;
// //     case (path::rest, ht, _)
// //       equation
// //         ht = getCalledFunctionsInFunction2(path, Absyn.pathStringNoQual(path), ht, funcs);
// //         ht = getCalledFunctionsInFunctionsCollector(rest, ht, funcs);
// //       then ht;
// //   end match;
// end getCalledFunctionsInFunctionsCollector;


// function getNamedFunction "Return a MidCode.Function with the given name. Fails if not found."
//   input Absyn.Path path;
//   input DAE.FunctionTree functions;
//   output MidCode.Function outElement;
// algorithm
//   outElement := match (path,functions)
//     local
//       String msg;
//     case (_,_) then Util.getOption(Util.tuple22(getMidFunc(functions, path)));
//     else algorithm print("No named function in cache\n"); then fail();
//   end match;
// end getNamedFunction;

// function getFunctionList
//   "Equvivalent with the function with the same name in DAEUtil. However, this function
//   returns a list of MidCode functions from the MidCode function tree instead."
//   input DAE.FunctionTree ft;
//   output list<MidCode.Function> fns;
// algorithm
//   // fns := matchcontinue ft
//   //   local
//   //     list<tuple<DAE.AvlTreePathFunction.Key,MidCode.AvlTreePathFunction.Value>> lst, lstInvalid;
//   //     String str;
//   //   case _
//   //     equation
//   //       lst = DAE.AvlTreePathFunction.toListMid(ft);
//   //       fns = List.mapMap(lst, Util.tuple22, Util.getOption);
//   //       // fns = List.mapMap(List.select(lst, isValidFunctionEntry), Util.tuple22, Util.getOption);
//   //     then fns;
//   //   case _
//   //     equation
//   //       lst = DAE.AvlTreePathFunction.toListMid(ft);
//   //       lstInvalid = List.select(lst, isInvalidFunctionEntry);
//   //       str = stringDelimitList(list(Absyn.pathString(p) for p in List.map(lstInvalid, Util.tuple21)), "\n ");
//   //       str = "\n " + str + "\n";
//   //       Error.addMessage(Error.NON_INSTANTIATED_FUNCTION, {str});
//   //       fns = List.mapMap(List.select(lst, isValidFunctionEntry), Util.tuple22, Util.getOption);
//   //     then
//   //       fns;
//   // end matchcontinue;
// end getFunctionList;

function getFunctionStmts
  "Returns all statments for a MidCode function"
  input MidCode.Function f;
  output list<MidCode.Stmt> stmts;
algorithm
  stmts := match f
    case MidCode.FUNCTION(__) then List.mapFlat(f.body,getBodyStmts);
    else fail();
  end match;
end getFunctionStmts;

function getBodyStmts
  input MidCode.Block bl;
  output list<MidCode.Stmt> stmts;
algorithm
  stmts :=
	match bl
	  case MidCode.BLOCK(__) then bl.stmts;
	  else fail();
	end match;
end getBodyStmts;

function getBBs
  "Retrieves all basic blocks for a MidCode.Function"
  input MidCode.Function f;
  output list<MidCode.Block> bBs;
algorithm
  bBs := match f case MidCode.FUNCTION(__) then f.body; end match;
end getBBs;

function getTerminators
  "Given a list of BBs returns all terminators as a linked list"
  input list<MidCode.Block> blcks;
  output list<MidCode.Terminator> terms;
algorithm
  terms := List.map(blcks,getTerminator);
end getTerminators;

function getTerminator
  "Fetches a terminator for a given BB in MidCode."
  input MidCode.Block BB;
  output MidCode.Terminator term;
algorithm
  term := match BB case MidCode.BLOCK(__) then BB.terminator; end match;
end getTerminator;

function getCallTerminator
  input MidCode.Terminator iTerm;
  output MidCode.Terminator oTerm;
algorithm
  oTerm := match iTerm
	case MidCode.CALL(_,_,_,_,_,_) then iTerm;
  end match;
end getCallTerminator;

function isNotBuiltinCall
  input MidCode.Terminator call;
  output Boolean b;
algorithm
  b := match call
    case MidCode.CALL(__) then not call.builtin;
  end match;
end isNotBuiltinCall;

function getMidCodeCalledFuncs
  "Return the Absyn.path for all call terminators in a given MidCode function. Fetches all functions or just the user defined ones"
  input MidCode.Function f;
  input Boolean fetchAll = false;
  output list<Absyn.Path> calledFuncs;
protected
  list<MidCode.Terminator> calls;
algorithm
  calls := getTerminators(getBBs(f));
  calls := List.map(calls,getCallTerminator);
  if not fetchAll then
	calls := List.filterOnTrue(calls,isNotBuiltinCall);
  end if;
  calledFuncs := List.map(calls,getCallTermPath);
end getMidCodeCalledFuncs;

function getCallTermPath
  input MidCode.Terminator term;
  output Absyn.Path path;
algorithm
  path := match term case MidCode.CALL(__) then term.func; end match;
end getCallTermPath;

//TODO:
function getUnionTypePaths
  "Fetches all unionType paths for a list of MidCode functions."
  input list<MidCode.Function> midFuncs;
  output list<Absyn.Path> outPaths;
protected
  list<MidCode.LITERALMETATYPE> metaLits;
algorithm
  /*Fetch all metaLits from the midFuncs*/
//  _ := List.filter(List.mapFlat(midFuncs,getFunctionStmts),isLiteralMetatype);
  outPaths := {};
end getUnionTypePaths;

/*TODO:Could not place this in DAE for some reason, compiles but cannot be found during linking.*/
// function addPair
//   "Inserts a new node in the tree. Same as the regular add,
//   except adds a pair of DAE_func and Mid_func (Used for the MidCode cache.)."
//   input DAE.AvlTreePathFunction.Tree inTree;
//   input DAE.AvlTreePathFunction.Key inKey;
//   input DAE.AvlTreePathFunction.Value inValue;
//   input DAE.AvlTreePathFunction.ConflictFunc conflictFunc = DAE.AvlTreePathFunction.addConflictReplace "Used to resolve conflicts.";
//   output DAE.AvlTreePathFunction.Tree tree=inTree;
// algorithm
//   tree := match tree
// 	local
//       DAE.AvlTreePathFunction.Key key;
//       DAE.AvlTreePathFunction.Value value;
//       Integer key_comp;
//       DAE.AvlTreePathFunction.Tree outTree;
//     // Empty tree.
//     case DAE.AvlTreePathFunction.EMPTY()
//       then DAE.AvlTreePathFunction.LEAF(inKey, inValue);
//     case DAE.AvlTreePathFunction.NODE(key = key)
//       algorithm
//         key_comp := DAE.AvlTreePathFunction.keyCompare(inKey, key);
//         if key_comp == -1 then
//           // Replace left branch.
//           tree.left := addPair(tree.left, inKey, inValue, conflictFunc);
//         elseif key_comp == 1 then
//         // Replace right branch.
//           tree.right := addPair(tree.right, inKey, inValue, conflictFunc);
//         else
//           // Use the given function to resolve the conflict.
//           value := conflictFunc(inValue, tree.value, key);
//           if not referenceEq(tree.value, value) then
//             tree.value := value;
//           end if;
//         end if;
//       then
//         if key_comp == 0 then tree else DAE.AvlTreePathFunction.balance(tree);
//     case DAE.AvlTreePathFunction.LEAF(key = key)
//       algorithm
//         key_comp := DAE.AvlTreePathFunction.keyCompare(inKey, key);
//         if key_comp == -1 then
//           // Replace left branch.
//           outTree := DAE.AvlTreePathFunction.NODE(tree.key, tree.value, 2, DAE.AvlTreePathFunction.LEAF(inKey,inValue), DAE.AvlTreePathFunction.EMPTY());
//         elseif key_comp == 1 then
//           // Replace right branch.
//           outTree := DAE.AvlTreePathFunction.NODE(tree.key, tree.value, 2, DAE.AvlTreePathFunction.EMPTY(), DAE.AvlTreePathFunction.LEAF(inKey,inValue));
//         else
//           // Use the given function to resolve the conflict.
//           value := conflictFunc(inValue, tree.value, key);
//           if not referenceEq(tree.value, value) then
//             tree.value := value;
//           end if;
//           outTree := tree;
//         end if;
//       then
// 		if key_comp == 0 then outTree else DAE.AvlTreePathFunction.balance(outTree);
//       end match;
// 	end addPair;

// /*TODO: Same deal here, cannot seem to overload, remove*/
// function getMidFunc
//   "Fetches a value from the tree given a key, or fails if no value is associated
//    with the key, it is not enought we must also see that it does exist a MidCodeFunction since it will also match for the DAE functions."
//   input DAE.AvlTreePathFunction.Tree tree;
//   input DAE.AvlTreePathFunction.Key key;
//   output DAE.AvlTreePathFunction.Value value;
// protected
//   DAE.AvlTreePathFunction.Key k;
// algorithm
//   k := match tree
//     case DAE.AvlTreePathFunction.NODE() then tree.key;
//     case DAE.AvlTreePathFunction.LEAF() then tree.key;
//   end match;

//   value := match (DAE.AvlTreePathFunction.keyCompare(key, k), tree)
//     case ( 0, DAE.AvlTreePathFunction.LEAF()) algorithm existsMidFunc(tree.value); then tree.value;
//     case ( 0, DAE.AvlTreePathFunction.NODE()) algorithm existsMidFunc(tree.value); then tree.value;
//     case ( 1, DAE.AvlTreePathFunction.NODE()) algorithm existsMidFunc(tree.value); then getMidFunc(tree.right, key);
//     case (-1, DAE.AvlTreePathFunction.NODE()) algorithm existsMidFunc(tree.value); then getMidFunc(tree.left, key);
//   end match;
// end getMidFunc;

function existsMidFunc
  input tuple<Option<DAE.Function>,Option<MidCode.Function>> value;
protected
  Option<DAE.Function> df;
  Option<MidCode.Function> mf;
algorithm
  (df,mf) := value;
  /*TODO: For some reason the NONE for the mf dissapears,
    even though it should be added in DAE.mo. A bug in the omc?
  */
  if /*Hack.*/anyString(mf) == "0" then mf := NONE(); end if;
    () := match (df,mf)
    local DAE.Function df1; MidCode.Function mf1;
    case (SOME(df1),NONE()) then fail();
	case (SOME(df1),SOME(mf1)) then ();
	else fail();
  end match;
end existsMidFunc;

function blockWithId
  input MidCode.Block bb;
  input Integer id;
  output Boolean b;
algorithm
  b := bb.id == id;
end blockWithId;

/*TODO: Can this be done in a better way?*/
function rValueToLiteralInteger
  input MidCode.RValue rval;
  output Integer r;
  algorithm
  r := match rval
	case MidCode.LITERALINTEGER(__) then rval.value;
    else then fail();
  end match;
end rValueToLiteralInteger;

function rValueToLiteralReal
  input MidCode.RValue rval;
  output Real r;
algorithm
  r := match rval
	case MidCode.LITERALREAL(__) then rval.value;
    else then fail();
  end match;
end rValueToLiteralReal;

function rValueToLiteralBoolean
  input MidCode.RValue rval;
  output Boolean r;
algorithm
  r := match rval
	case MidCode.LITERALBOOLEAN(__) then rval.value;
    else then fail();
  end match;
end rValueToLiteralBoolean;

function rValueToLiteralString
  input MidCode.RValue rval;
  output String r;
algorithm
  r := match rval
	case MidCode.LITERALSTRING(__) then rval.value;
    else then fail();
  end match;
end rValueToLiteralString;

function dumpMidCodeIR
  input MidCode.Function func;
algorithm
  print("inputs:" + anyString(func.inputs) + "\n");
  print("outputs:" + anyString(func.outputs) + "\n");
  print("Locals:" + anyString(func.locals) + "\n");
  for bb in func.body loop
	print("\n"+anyString(bb) + "\n");
  end for;
end dumpMidCodeIR;

function getVarTy
  input MidCode.Var var;
  output DAE.Type ty;
algorithm
  ty := match var case MidCode.VAR(__) then var.ty; end match;
end getVarTy;

function getDimensions
  "I asume that  I get arrays like,
  T_ARRAY(T_ARRAY(T_ARRAY(non_array_type, {dim1}), {dim2}), {dim3}) (Not always true I guess?)"
  input DAE.Type arrayTy;
  output list<DAE.Dimension> dims;
algorithm
  dims := match arrayTy
    case DAE.T_ARRAY(__) then listHead(arrayTy.dims) :: getDimensions(arrayTy.ty);
    case _ then {};
  end match;
end getDimensions;

function getAllocStmts
  input MidCode.Function f;
  output list<MidCode.Stmt> allocaStmts;
algorithm
  allocaStmts := List.filter(getFunctionStmts(f),isAllocStmt);
end getAllocStmts;

function isAllocStmt
  input MidCode.Stmt stmt;
algorithm
  () := match stmt
    case MidCode.ALLOCARRAY(__) then ();
    else fail();
  end match;
end isAllocStmt;

/*TODO, Taken from Simcode util. Remove them and make them public.*/
function variableName
  input SimCodeFunction.Variable v;
  output String s;
algorithm
  s := match v
    case SimCodeFunction.VARIABLE(name=DAE.CREF_IDENT(ident=s)) then s;
    case SimCodeFunction.FUNCTION_PTR(name=s) then s;
  end match;
end variableName;

function compareSimVars
  input SimCodeFunction.Variable v1;
  input SimCodeFunction.Variable v2;
  output Boolean b;
algorithm
  b := stringEqual(variableName(v1),variableName(v2));
end compareSimVars;


annotation(__OpenModelica_Interface="backendInterface");
end MidCodeUtil;