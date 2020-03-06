(function _OperationMeta_s_() {

'use strict';

let _ = _global_.wTools;
let _hasLength = _.hasLength;
let _arraySlice = _.longSlice;
let _sqr = _.math.sqr;
let _sqrt = _.math.sqrt;
let _assertMapHasOnly = _.assertMapHasOnly;
let _routineIs = _.routineIs;

let _min = Math.min;
let _max = Math.max;
let _pow = Math.pow;
let sqrt = Math.sqrt;
let abs = Math.abs;

let meta = _.vectorAdapter._meta = _.vectorAdapter._meta || Object.create( null );
_.vectorAdapter._meta.routines = _.vectorAdapter._meta.routines || Object.create( null );

// --
// structure
// --

function operationSupplement( operation, atomOperation )
{
  operation = _.mapSupplement( operation, atomOperation );

  _.assert( arguments.length === 2, 'Expects exactly two arguments' );

  /* */

  if( _.routineIs( operation.onContinue ) )
  operation.onContinue = [ operation.onContinue ];
  else if( !operation.onContinue )
  operation.onContinue = [];

  if( _.routineIs( operation.onAtom ) )
  operation.onAtom = [ operation.onAtom ];
  else if( !operation.onAtom )
  operation.onAtom = [];

  if( _.routineIs( operation.onAtomsBegin ) )
  operation.onAtomsBegin = [ operation.onAtomsBegin ];
  else if( !operation.onAtomsBegin )
  operation.onAtomsBegin = [];

  if( _.routineIs( operation.onAtomsEnd ) )
  operation.onAtomsEnd = [ operation.onAtomsEnd ];
  else if( !operation.onAtomsEnd )
  operation.onAtomsEnd = [];

  if( _.routineIs( operation.onVectorsBegin ) )
  operation.onVectorsBegin = [ operation.onVectorsBegin ];
  else if( !operation.onVectorsBegin )
  operation.onVectorsBegin = [];

  if( _.routineIs( operation.onVectorsEnd ) )
  operation.onVectorsEnd = [ operation.onVectorsEnd ];
  else if( !operation.onVectorsEnd )
  operation.onVectorsEnd = [];

  if( _.routineIs( operation.onVectors ) )
  operation.onVectors = [ operation.onVectors ];
  else if( !operation.onVectors )
  operation.onVectors = [];

  /* */

  if( operation.onContinue === atomOperation.onContinue )
  operation.onContinue = operation.onContinue.slice();

  if( operation.onAtom === atomOperation.onAtom )
  operation.onAtom = operation.onAtom.slice();

  if( operation.onAtomsBegin === atomOperation.onAtomsBegin )
  operation.onAtomsBegin = operation.onAtomsBegin.slice();

  if( operation.onAtomsEnd === atomOperation.onAtomsEnd )
  operation.onAtomsEnd = operation.onAtomsEnd.slice();

  if( operation.onVectorsBegin === atomOperation.onVectorsBegin )
  operation.onVectorsBegin = operation.onVectorsBegin.slice();

  if( operation.onVectorsEnd === atomOperation.onVectorsEnd )
  operation.onVectorsEnd = operation.onVectorsEnd.slice();

  if( operation.onVectors === atomOperation.onVectors )
  operation.onVectors = operation.onVectors.slice();

  /* */

  if( _.numberIs( operation.takingArguments ) )
  operation.takingArguments = [ operation.takingArguments, operation.takingArguments ];
  else if( operation.takingArguments && operation.takingArguments === atomOperation.takingArguments )
  operation.takingArguments = operation.takingArguments.slice();

  if( _.numberIs( operation.takingVectors ) )
  operation.takingVectors = [ operation.takingVectors, operation.takingVectors ];
  else if( operation.takingVectors && operation.takingVectors === atomOperation.takingVectors )
  operation.takingVectors = operation.takingVectors.slice();

  return operation;
}

//

function _operationLogicalReducerAdjust( operation )
{

  _.assert( arguments.length === 1, 'Expects single argument' );

  let def =
  {
    usingExtraSrcs : 0,
    usingDstAsSrc : 0,
    interruptible : 1,
    reducing : 1,
    returningPrimitive : 1,
    returningBoolean : 1,
    returningNumber : 0,
    returningNew : 0,
    returningSelf : 0,
    returningLong : 0,
    modifying : 0,
  }

  _.mapExtend( operation, def );

}

//

function operationNormalizeInput( operation, routineName )
{

  let delimeter = [ 'w', 'r', 'v', 's', 'm', 't', 'a', 'n', '?', '*', '+', '!' ];
  var tokenRoutine =
  {
    'w' : tokenWrite,
    'r' : tokenRead,
    'v' : tokenVector,
    's' : tokenScalar,
    'm' : tokenMatrix,
    't' : tokenSomething,
    'a' : tokenAnything,
    'n' : tokenNull,
    '?' : tokenTimesOptional,
    '*' : tokenTimesAny,
    '+' : tokenTimesAtLeast,
    '!' : tokenBut,
  }

  if( _.strIs( operation.input ) )
  operation.input = operation.input.split( ' ' );

  if( _.mapIs( operation.input ) )
  return operation.input;

  routineName = routineName || operation.name;

  _.assert( _.strDefined( routineName ) );
  _.assert( _.longIs( operation.input ), () => `Routine::${routineName} does not have operation.input` );

  operation.input = _.longShrink( operation.input );

  // logger.log( `operationNormalizeInput ${routineName}` );

  let definition = operation.input.join( ' ' );

  for( let i = 0 ; i < operation.input.length ; i++ )
  {
    operation.input[ i ] = argParse( operation.input[ i ] );
  }

  let inputDescriptor = Object.create( null );
  inputDescriptor.definition = definition;
  inputDescriptor.args = operation.input;
  inputDescriptor.takingArguments = [ 0, 0 ];
  inputDescriptor.takingVectors = [ 0, 0 ];
  inputDescriptor.takingVectorsOnly = true;
  operation.input = inputDescriptor;

  for( let i = 0 ; i < inputDescriptor.args.length ; i++ )
  {
    let argDescriptor = inputDescriptor.args[ i ];
    inputDescriptor.takingArguments[ 0 ] += argDescriptor.times[ 0 ];
    inputDescriptor.takingArguments[ 1 ] += argDescriptor.times[ 1 ];
    if( argDescriptor.isVector )
    {
      if( argDescriptor.isVector === true )
      inputDescriptor.takingVectors[ 0 ] += argDescriptor.times[ 0 ];
      inputDescriptor.takingVectors[ 1 ] += argDescriptor.times[ 1 ];
      if( argDescriptor.isVector === _.maybe )
      inputDescriptor.takingVectorsOnly = false;
    }
    else
    {
      inputDescriptor.takingVectorsOnly = false;
    }
  }

  return inputDescriptor;

  /* */

  function argParse( definition )
  {
    let argDescriptor = Object.create( null );
    argDescriptor.types = [];
    argDescriptor.readable = false;
    argDescriptor.writable = false;
    argDescriptor.alternatives = [];
    argDescriptor.definition = definition;
    argDescriptor.times = [ Infinity, 0 ];
    argDescriptor.isVector = null;
    let alternatives = definition.split( '|' );
    for( let i = 0 ; i < alternatives.length ; i++ )
    {
      let typeDescriptor = typeParse( alternatives[ i ] )
      typeCollect( argDescriptor, typeDescriptor );
    }
    return argDescriptor;
  }

  /* */

  function typeCollect( argDescriptor, typeDescriptor )
  {

    _.assert( _.strIs( typeDescriptor.type ) );
    argDescriptor.types.push( typeDescriptor.type );

    _.assert( _.boolIs( typeDescriptor.writable ) )
    if( typeDescriptor.writable )
    argDescriptor.writable = typeDescriptor.writable;

    _.assert( _.boolIs( typeDescriptor.readable ) )
    if( typeDescriptor.readable )
    argDescriptor.readable = typeDescriptor.readable;

    argDescriptor.times[ 0 ] = Math.min( argDescriptor.times[ 0 ], typeDescriptor.times[ 0 ] );
    argDescriptor.times[ 1 ] = Math.max( argDescriptor.times[ 1 ], typeDescriptor.times[ 1 ] );

    _.assert( typeDescriptor.isVector === _.maybe || _.boolIs( typeDescriptor.isVector ) );

    // argDescriptor.isVector = _.fuzzy.and( argDescriptor.isVector, argDescriptor.isVector ); /* zzz */

    if( argDescriptor.isVector === null )
    {
      argDescriptor.isVector = typeDescriptor.isVector;
    }
    else if( argDescriptor.isVector !== _.maybe && typeDescriptor.type !== 'n' )
    {
      if( typeDescriptor.isVector === _.maybe || argDescriptor.isVector === _.maybe )
      argDescriptor.isVector = _.maybe;
      else if( typeDescriptor.isVector === false && argDescriptor.isVector === true )
      argDescriptor.isVector = _.maybe;
      else if( typeDescriptor.isVector === true && argDescriptor.isVector === false )
      argDescriptor.isVector = _.maybe;
      else
      argDescriptor.isVector = typeDescriptor.isVector;
    }

  }

  /* */

  function tokenWrite( c )
  {
    c.typeDescriptor.writable = true;
  }

  /* */

  function tokenRead( c )
  {
    c.typeDescriptor.readable = true;
  }

  /* */

  function tokenVector( c )
  {
    _.assert( c.typeDescriptor.type === null );
    c.typeDescriptor.type = 'v';
    if( !_.longHas( c.splits, '!' ) )
    {
      _.assert( c.typeDescriptor.isVector === null );
      c.typeDescriptor.isVector = true;
    }

  }

  /* */

  function tokenScalar( c )
  {
    c.typeDescriptor.readable = true;
    _.assert( c.typeDescriptor.type === null );
    c.typeDescriptor.type = 's';
    _.assert( c.typeDescriptor.isVector === null );
    c.typeDescriptor.isVector = false;
  }

  /* */

  function tokenMatrix( c )
  {
    _.assert( c.typeDescriptor.type === null );
    c.typeDescriptor.type = 'm';
    _.assert( c.typeDescriptor.isVector === null );
    c.typeDescriptor.isVector = false;
  }

  /* */

  function tokenSomething( c )
  {
    _.assert( c.typeDescriptor.type === null );
    c.typeDescriptor.type = 't';
    if( !_.longHas( c.splits, '!' ) )
    {
      _.assert( c.typeDescriptor.isVector === null );
      c.typeDescriptor.isVector = false;
    }
  }

  /* */

  function tokenAnything( c )
  {
    _.assert( c.typeDescriptor.type === null );
    c.typeDescriptor.type = 'a';
    if( !_.longHas( c.splits, '!' ) )
    {
      _.assert( c.typeDescriptor.isVector === null );
      c.typeDescriptor.isVector = _.maybe;
    }
  }

  /* */

  function tokenNull( c )
  {
    _.assert( c.typeDescriptor.type === null );
    c.typeDescriptor.type = 'n';
    _.assert( c.typeDescriptor.isVector === null );
    c.typeDescriptor.isVector = false;
  }

  /* */

  function tokenTimesOptional( c )
  {
    _.assert( c.typeDescriptor.times[ 0 ] === 1 );
    c.typeDescriptor.times[ 0 ] = 0;
  }

  /* */

  function tokenTimesAny( c )
  {
    if( c.i > 0 && !_.longHas( delimeter, c.splits[ c.i-1 ] ) )
    return;
    _.assert( c.typeDescriptor.times[ 0 ] === 1 );
    _.assert( c.typeDescriptor.times[ 1 ] === 1 );
    c.typeDescriptor.times[ 0 ] = 0;
    c.typeDescriptor.times[ 1 ] = Infinity;
  }

  /* */

  function tokenTimesAtLeast( c )
  {
    _.assert( c.typeDescriptor.times[ 0 ] === 1 );
    _.assert( c.typeDescriptor.times[ 1 ] === 1 );
    c.typeDescriptor.times[ 0 ] = 1;
    c.typeDescriptor.times[ 1 ] = Infinity;
  }

  /* */

  function tokenBut( c )
  {
    _.assert( c.splits.length > c.i+1 );
    let next = c.splits[ c.i+1 ];
    c.typeDescriptor.type = '!' + next;
    c.i += 1;
    _.assert( c.typeDescriptor.isVector === null );
    if( next === 'v' || next === 'a' )
    c.typeDescriptor.isVector = false;
    else
    c.typeDescriptor.isVector = _.maybe;
  }

  /* */

  function tokenEtc( c )
  {
    // debugger;
    let times = _.numberFromStr( c.split );
    _.assert( _.numberDefined( times ) );
    _.assert( c.splits[ c.i+1 ] === '*' );
    _.assert( c.typeDescriptor.times[ 0 ] === 1 );
    _.assert( c.typeDescriptor.times[ 1 ] === 1 );
    c.typeDescriptor.times[ 0 ] = times;
    c.typeDescriptor.times[ 1 ] = times;
  }

  /* */

  function typeParse( definition )
  {
    let c = Object.create( null );
    c.typeDescriptor = Object.create( null );
    c.typeDescriptor.type = null;
    c.typeDescriptor.readable = false;
    c.typeDescriptor.writable = false;
    c.typeDescriptor.definition = definition;
    c.typeDescriptor.times = [ 1, 1 ];
    c.typeDescriptor.isVector = null;
    c.splits = _.strSplitFast({ src : definition, delimeter : delimeter, preservingEmpty : 0 });

    for( let i = 0 ; i < c.splits.length ; i++ )
    {
      c.split = c.splits[ i ];
      c.i = i;

      let routine = tokenRoutine[ c.split ];
      if( !routine )
      routine = tokenEtc;

      routine( c );
      i = c.i;
    }

    // if( c.typeDescriptor.isVector )
    // if( c.typeDescriptor.times[ 0 ] === 0 )
    // c.typeDescriptor.isVector = _.maybe;

    return c.typeDescriptor;
  }

  /* */

  /*

  'vw' 'vw|s', 'vr|s', '?vr', '*a', '3*a'

  */
}

//

function operationNormalizeArity( operation )
{

  _.assert( !!operation.input );

  if( operation.takingArguments === undefined || operation.takingArguments === null )
  operation.takingArguments = operation.input.takingArguments;
  // if( operation.takingArguments === undefined || operation.takingArguments === null )
  // operation.takingArguments = operation.takingVectors;

  if( operation.takingVectors === undefined || operation.takingVectors === null )
  operation.takingVectors = operation.input.takingVectors;
  // if( operation.takingVectors === undefined || operation.takingVectors === null )
  // operation.takingVectors = operation.takingArguments;

  if( operation.takingArguments === undefined || operation.takingArguments === null )
  operation.takingArguments = [ 1, Infinity ];

  if( operation.takingVectors === undefined || operation.takingVectors === null )
  operation.takingVectors = [ 1, Infinity ];

  operation.takingArguments = _.numbersFromNumber( operation.takingArguments, 2 ).slice();
  operation.takingVectors = _.numbersFromNumber( operation.takingVectors, 2 ).slice();

  if( operation.takingArguments[ 0 ] < operation.takingVectors[ 0 ] )
  operation.takingArguments[ 0 ] = operation.takingVectors[ 0 ];

  if( operation.takingVectorsOnly === undefined || operation.takingVectorsOnly === null )
  operation.takingVectorsOnly = operation.input.takingVectorsOnly;

  if( operation.takingVectorsOnly === undefined || operation.takingVectorsOnly === null )
  if( operation.takingVectors[ 0 ] === operation.takingVectors[ 1 ] && operation.takingVectors[ 1 ] === operation.takingArguments[ 1 ] )
  operation.takingVectorsOnly = true;

  operation.inputWithoutLast = operation.input.args.slice( 0, operation.input.args.length-1 );
  operation.inputLast = operation.input.args[ operation.input.args.length-1 ];

  return operation;
}

//

function operationNormalize1( operation )
{

  if( !operation.name )
  operation.name = operation.onAtom.name;

  operation.onAtom.operation = operation;

  if( _.numberIs( operation.takingArguments ) )
  operation.takingArguments = [ operation.takingArguments, operation.takingArguments ];

  if( _.numberIs( operation.takingVectors ) )
  operation.takingVectors = [ operation.takingVectors, operation.takingVectors ];

  _.assertMapHasOnly( operation, _.vectorAdapter.OperationDescriptor0.fields );

}

//

function operationNormalize2( operation )
{

  _.assert( operation.onVectorsBegin === undefined );
  _.assert( operation.onVectorsEnd === undefined );

  _.assert( _.mapIs( operation ) );
  _.assert( _.routineIs( operation.onAtom ) );
  _.assert( _.strDefined( operation.name ) );
  _.assert( operation.onAtom.length === 1 );

  _.assert( _.boolIs( operation.usingExtraSrcs ) );
  _.assert( _.boolIs( operation.usingDstAsSrc ) );

  _.assert( _.strIs( operation.kind ) );

  // _.assertMapHasOnly( operation, _.vectorAdapter.OperationDescriptor0.fields );

}

//

function operationSinglerAdjust()
{
  let operations = _.vectorAdapter.operations;
  let routines = _.vectorAdapter._meta.operationRoutines;
  let atomWiseSingler = operations.atomWiseSingler = operations.atomWiseSingler || Object.create( null );

  for( let name in routines.atomWiseSingler )
  {
    let operation = routines.atomWiseSingler[ name ];

    this.operationNormalize1( operation );

    operation.kind = 'singler';

    if( operation.takingArguments === undefined )
    operation.takingArguments = [ 1, 1 ];
    operation.homogeneous = true;
    operation.atomWise = true;

    if( operation.usingExtraSrcs === undefined )
    operation.usingExtraSrcs = false;
    if( operation.usingDstAsSrc === undefined )
    operation.usingDstAsSrc = false;

    _.assert( _.arrayIs( operation.takingArguments ) );
    _.assert( operation.takingArguments.length === 2 );
    _.assert( !operations.atomWiseSingler[ name ] );

    this.operationNormalize2( operation );

    operations.atomWiseSingler[ name ] = operation;
  }

}

//

function operationsLogical1Adjust()
{
  let operations = _.vectorAdapter.operations;
  let routines = _.vectorAdapter._meta.operationRoutines;
  let logical1 = operations.logical1 = operations.logical1 || Object.create( null );

  for( let name in routines.logical1 )
  {
    let operation = routines.logical1[ name ];

    this.operationNormalize1( operation );

    operation.kind = 'logical1';

    if( operation.usingExtraSrcs === undefined )
    operation.usingExtraSrcs = false;
    if( operation.usingDstAsSrc === undefined )
    operation.usingDstAsSrc = false;

    operation.homogeneous = true;
    operation.atomWise = true;
    operation.reducing = true;
    operation.zipping = false;
    operation.interruptible = false;

    _.assert( !operations.logical1[ name ] );

    this.operationNormalize2( operation );

    operations.logical1[ name ] = operation;
  }

}

//

function operationsLogical2Adjust()
{
  let operations = _.vectorAdapter.operations;
  let routines = _.vectorAdapter._meta.operationRoutines;
  let logical2 = operations.logical2 = operations.logical2 || Object.create( null );

  for( let name in routines.logical2 )
  {
    let operation = routines.logical2[ name ];

    this.operationNormalize1( operation );

    operation.kind = 'logical2';

    if( operation.usingExtraSrcs === undefined )
    operation.usingExtraSrcs = false;
    if( operation.usingDstAsSrc === undefined )
    operation.usingDstAsSrc = false;

    operation.homogeneous = true;
    operation.atomWise = true;
    operation.reducing = true;
    operation.zipping = true;
    operation.interruptible = false;
    operation.returningBoolean = true;

    _.assert( !operations.logical2[ name ] );

    this.operationNormalize2( operation );

    operations.logical2[ name ] = operation;
  }

}

//

function operationHomogeneousAdjust()
{
  let operations = _.vectorAdapter.operations;
  let routines = _.vectorAdapter._meta.operationRoutines;
  let atomWiseHomogeneous = operations.atomWiseHomogeneous = operations.atomWiseHomogeneous || Object.create( null );

  for( let name in routines.atomWiseHomogeneous )
  {
    let operation = routines.atomWiseHomogeneous[ name ];

    this.operationNormalize1( operation );

    operation.kind = 'homogeneous';

    if( operation.takingArguments === undefined )
    operation.takingArguments = [ 2, 2 ];

    if( operation.takingVectors === undefined )
    operation.takingVectors = [ 0, operation.takingArguments[ 1 ] ];

    if( operation.usingExtraSrcs === undefined )
    operation.usingExtraSrcs = true;
    if( operation.usingDstAsSrc === undefined )
    operation.usingDstAsSrc = true;

    operation.homogeneous = true;
    operation.atomWise = true;

    _.assert( _.arrayIs( operation.takingArguments ) );
    _.assert( operation.takingArguments.length === 2 );
    _.assert( !operations.atomWiseHomogeneous[ name ] );

    this.operationNormalize2( operation );

    operations.atomWiseHomogeneous[ name ] = operation;
  }
}

//

function operationHeterogeneousAdjust()
{
  let operations = _.vectorAdapter.operations;
  let routines = _.vectorAdapter._meta.operationRoutines;
  let atomWiseHeterogeneous = operations.atomWiseHeterogeneous = operations.atomWiseHeterogeneous || Object.create( null );

  for( let name in routines.atomWiseHeterogeneous )
  {
    let operation = routines.atomWiseHeterogeneous[ name ];

    this.operationNormalize1( operation );

    operation.kind = 'heterogeneous';

    if( operation.usingDstAsSrc === undefined )
    operation.usingDstAsSrc = false;
    if( operation.usingExtraSrcs === undefined )
    operation.usingExtraSrcs = false;

    operation.homogeneous = false;
    operation.atomWise = true;

    _.assert( _.arrayIs( operation.takingArguments ) );
    _.assert( operation.takingArguments.length === 2 );
    _.assert( !!operation.input );
    _.assert( !operations.atomWiseHeterogeneous[ name ] );

    this.operationNormalize2( operation );

    operations.atomWiseHeterogeneous[ name ] = operation;

  }

}

//

function operationReducingAdjust()
{
  let operations = _.vectorAdapter.operations;
  let routines = _.vectorAdapter._meta.operationRoutines;
  let atomWiseReducing = operations.atomWiseReducing = operations.atomWiseReducing || Object.create( null );

  for( let name in routines.atomWiseReducing )
  {
    let operation = routines.atomWiseReducing[ name ];

    this.operationNormalize1( operation );

    operation.kind = 'reducing';
    operation.homogeneous = false;
    operation.atomWise = true;
    operation.reducing = true;

    if( operation.usingExtraSrcs === undefined )
    operation.usingExtraSrcs = false;
    if( operation.usingDstAsSrc === undefined )
    operation.usingDstAsSrc = false;

    _.assert( !operations.atomWiseReducing[ name ] );

    this.operationNormalize2( operation );

    operations.atomWiseReducing[ name ] = operation;
  }

}

// --
// extension
// --

let MetaExtension =
{

  operationSupplement,
  _operationLogicalReducerAdjust,
  operationNormalizeInput,
  operationNormalizeArity,

  operationNormalize1,
  operationNormalize2,

  operationSinglerAdjust,
  operationsLogical1Adjust,
  operationsLogical2Adjust,
  operationHomogeneousAdjust,
  operationHeterogeneousAdjust,
  operationReducingAdjust,

}

_.mapExtend( _.vectorAdapter._meta, MetaExtension );

})();