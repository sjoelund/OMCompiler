﻿#pragma once
#define BOOST_EXTENSION_SYSTEM_DECL BOOST_EXTENSION_EXPORT_DECL
#define BOOST_EXTENSION_EVENTHANDLING_DECL BOOST_EXTENSION_EXPORT_DECL
 #include "System/SystemDefaultImplementation.h"
 #include "Math/ArrayOperations.h"
 #include "System/EventHandling.h"
 #include "SimulationSettings/IGlobalSettings.h"
 #include "DataExchange/IHistory.h"
 #include "HistoryImpl.h"
 #include "DataExchange/Policies/TextfileWriter.h"
 


/*****************************************************************************
* 
* Simulation code for Modelica generated by the OpenModelica Compiler.
* System class Modelica implements the Interface IMixedSystem
*
*****************************************************************************/
typedef HistoryImpl<TextFileWriter,0,0,0> HistoryImplType;


class Modelica: public IMixedSystem ,public IContinuous ,public IEvent ,public ISystemProperties, public SystemDefaultImplementation
 { 
 public: 

  Modelica(IGlobalSettings& globalSettings); 

  ~Modelica(); 

  //Releases the Modelica System
   virtual void destroy();

  //Provide number (dimension) of variables according to the index
   virtual int getDimVars() const ;

  //Provide number (dimension) of right hand sides (equations and/or residuals) according to the index 
   virtual int getDimRHS()const;

  //(Re-) initialize the system of equations
   virtual void init(double ts,double te);

  //Resets all time events
   virtual void resetTimeEvents();

  //Set current integration time 
   virtual void setTime(const double& t);

  // Provide variables with given index to the system 
   virtual void giveVars(double* z);

  // Set variables with given index to the system
   virtual void setVars(const double* z);

  // Update transfer behavior of the system of equations according to command given by solver
   virtual void update(const UPDATE command =IContinuous::UNDEF_UPDATE);

  // Provide the right hand side (according to the index)
   virtual void giveRHS(double* f);

  // Output routine (to be called by the solver after every successful integration step)
   virtual void writeOutput(const OUTPUT command = UNDEF_OUTPUT);

  // Provide pattern for Jacobian
   virtual void giveJacobianSparsityPattern(SparcityPattern pattern) ;

  // Provide Jacobian
   virtual void giveJacobian(SparseMatrix& matrix);

  // Provide pattern for mass matrix
   virtual void giveMassSparsityPattern(SparcityPattern pattern) ;

  // Provide mass matrix 
   virtual void giveMassMatrix(SparseMatrix& matrix);

  // Provide pattern for global constraint jacobian 
   virtual void giveConstraintSparsityPattern(SparcityPattern pattern);

  // Provide global constraint jacobian 
   virtual void giveConstraint(SparseMatrix matrix);

  // Provide number (dimension) of zero functions 
   virtual int getDimZeroFunc() ;

  // Provides current values of root/zero functions 
   virtual void giveZeroFunc(double* f);
  virtual void giveConditions(bool* c);
   //Called to handle all  events occured at same time  
   virtual void handleSystemEvents( bool* events);
   virtual void checkConditions(const bool* events, bool all);
  //Called to handle an event  
   virtual void handleEvent(const bool* events);
  virtual IHistory* getHistory();
  //Checks if a discrete variable has changed and triggers an event 
   virtual bool checkForDiscreteEvents();

  //Returns the vector with all time events 
  virtual event_times_type getTimeEvents();

  // No input
   virtual bool isAutonomous() ;

  // Time is not present
   virtual bool isTimeInvariant();

  // M is regular 
   virtual bool isODE();

  // M is singular 
   virtual bool isAlgebraic();

  // M = identity 
   virtual bool isExplicit() ;

  // M does not depend on t, z 
   virtual bool hasConstantMass() ;

  // M depends on z 
   virtual bool hasStateDependentMass() ;

  // System is able to provide the Jacobian symbolically 
   virtual bool provideSymbolicJacobian() ;
   virtual void saveDiscreteVars();
private:

  //Methods:
  //Saves all variables before an event is handled, is needed for the pre, edge and change operator
  void saveAll();

   void resetHelpVar(const int index);

  //Variables:
  EventHandling _event_handling;


  HistoryImplType* _historyImpl;
  SparseMatrix _jacobian;
};
