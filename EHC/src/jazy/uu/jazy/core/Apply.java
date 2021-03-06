package uu.jazy.core ;

/**
 * Lazy and Functional.
 * Package for laziness and functions as known from functional languages.
 * Written by Atze Dijkstra, atze@cs.uu.nl
 */

import java.util.* ;
import java.io.* ;

/**
 * An application of an Eval to parameters.
 * An Apply is evaluated at most once. It has a value which is either a Function yet
 * to be applied to the stored parameters, or it is the result of the evaluation of
 * the application.
 */
public abstract class Apply extends Eval
//	implements GraphAlike
{
	protected Object funcOrVal ;
	
	protected int nrNeededParams = 0 ;
	
	//private static Stat statNew = Stat.newNewStat( "Apply" ) ;
	//private static Stat statDefaultEval0 = Stat.newEventStat( "Apply.eval0()" ) ;
	//private static Stat statDefaultEvalN = Stat.newEventStat( "Apply.evalN()" ) ;
	
	/**
	 * The maximum nr of arguments which can be passed directly instead of via an array.
	 * See the applyX, X in {1 .. MAX_DIRECT_ARGS, N}
	 */
	public final static int MAX_DIRECT_ARGS = 5 ;
	
	protected Apply( Object f )
	{
		funcOrVal = f ;
		//statNew.nrEvents++ ;
	}
	
    public void strict()
    {
        eval( this ) ;
    }
    
    /**
     * Set the value and mark as evaluated.
     */
    public synchronized void setValue( Object v )
    {
    	nrNeededParams = -1 ;
        funcOrVal = v ;
    }
    
    protected abstract void eraseRefs() ;
    
    protected void evalSet()
    {
    	funcOrVal = evalToE( funcOrVal ).evalOrApplyN( getBoundParams() ) ;
    	//eraseRefs() ;
    }
    
    /**
     * Return the value of the the evaluation, with some parameters.
     */
    protected Object eval1( Object v1 )
    {
        return evalOrApplyN( new Object[] {v1} ) ;
    }
    
    protected Object eval2( Object v1, Object v2 )
    {
        return evalOrApplyN( new Object[] {v1,v2} ) ;
    }
    
    protected Object eval3( Object v1, Object v2, Object v3 )
    {
        return evalOrApplyN( new Object[] {v1,v2,v3} ) ;
    }
    
    protected Object eval4( Object v1, Object v2, Object v3, Object v4 )
    {
        return evalOrApplyN( new Object[] {v1,v2,v3,v4} ) ;
    }

    protected Object eval5( Object v1, Object v2, Object v3, Object v4, Object v5 )
    {
        return evalOrApplyN( new Object[] {v1,v2,v3,v4,v5} ) ;
    }

    /**
     * Either evaluate or apply with arguments. Choice is made here.
     */
    protected final Object evalOrApplyN( Object[] vn )
    {
    	return getOrigFunction().evalOrApplyN( Utils.arrayConcat( getAllBoundParams(), vn ) ) ;
    }

    /**
     * @see uu.jazy.core.Eval#applyN
     */
    public Apply apply1( Object v1 )
    {
    	return new Apply1( this, v1 ) ;
    }
    
    /**
     * @see uu.jazy.core.Eval#applyN
     */
    public Apply apply2( Object v1, Object v2 )
    {
    	return new Apply2( this, v1, v2 ) ;
    }
    
    /**
     * @see uu.jazy.core.Eval#applyN
     */
    public Apply apply3( Object v1, Object v2, Object v3 )
    {
    	return new Apply3( this, v1, v2, v3 ) ;
    }
    
    /**
     * @see uu.jazy.core.Eval#applyN
     */
    public Apply apply4( Object v1, Object v2, Object v3, Object v4 )
    {
    	return new Apply4( this, v1, v2, v3, v4 ) ;
    }

    /**
     * @see uu.jazy.core.Eval#applyN
     */
    public Apply apply5( Object v1, Object v2, Object v3, Object v4, Object v5 )
    {
    	return new Apply5( this, v1, v2, v3, v4, v5 ) ;
    }

    /**
     * @see uu.jazy.core.Eval#applyN
     */
    public Apply applyN( Object[] vn )
    {
        switch ( vn.length )
        {
            case 1  : return apply1( vn[0] ) ;
            case 2  : return apply2( vn[0], vn[1] ) ;
            case 3  : return apply3( vn[0], vn[1], vn[2] ) ;
            case 4  : return apply4( vn[0], vn[1], vn[2], vn[3] ) ;
            case 5  : return apply5( vn[0], vn[1], vn[2], vn[3], vn[4] ) ;
            default : return new ApplyN( this, vn ) ;
        }
        //return new ApplyN( this, vn ) ;
    }

    protected Function getOrigFunction()
    {   
        if ( funcOrVal instanceof Eval )
            return ((Eval)funcOrVal).getOrigFunction() ;
        else
            throw new Error( "Trying to get a function from a non Eval" ) ;
    }
    
    protected Object[] getAllBoundParams()
    {
        if ( funcOrVal instanceof Function )
            return getBoundParams() ;
        else
            return Utils.arrayConcat( ((Apply)funcOrVal).getAllBoundParams(), getBoundParams() ) ;
    }
    
    protected void eraseAllRefs()
    {
        if ( nrNeededParams >= 0 )
            return ;
        if ( funcOrVal instanceof Apply )
            ((Apply)funcOrVal).eraseAllRefs() ;
        eraseRefs() ;
    }
    
    protected abstract int getNrBoundParams() ;

    /*
    public String toString()
    {
        //return getContentString() ;
        return Eval.toString( this ) ;
    }
    */
    
	/*
	public String getContentString()
	{
		StringBuffer b = new StringBuffer() ;
		if ( nrNeededParams >= 0 )
		{
			b.append( Utils.getAfterLastDot( getClass().getName() ) + "@" + hashCode() ) ;
		}
		//b.append( ", under-eval=" + underEvaluation ) ;
		if ( funcOrVal instanceof Eval )
		{
			//b.append( ", func[" + nrNeededParams + "/#needs=" + getNrParams() + "/#bound=" + getNrBoundParams() + "]=(" + funcOrVal + ")" ) ;
			b.append( ", func[" + nrNeededParams + "/#bound=" + getNrBoundParams() + "]=(" + funcOrVal + ")" ) ;
			//Utils.printAsListOn( Utils.arrayEnumeration( getBoundParams() ), b, "(", ",", ")" ) ;
		}
		else
		{
			//b.append( ", is eval'd(" + Utils.getAfterLastDot( funcOrVal.getClass().getName() ) + ")" ) ;
			b.append( funcOrVal ) ;
		}
		return b.toString() ;
	}
	*/
	
	public Enumeration getSuccessors()
	{
	    Object[] params = getBoundParams() ;
	    Object[] succ = params ;
	    if ( funcOrVal instanceof Eval )
	    {
	        succ = Utils.arrayCons( funcOrVal, params ) ;
	    }
	    return Utils.arrayEnumeration( succ ) ;
	}

    /*
    public void showOn( PrintWriter output )
    {
        show( output, funcOrVal ) ;
    }
    */
    
	public String getParentInfo()
	{
		if ( nrNeededParams >= 0 )
			return "@(" + getNrBoundParams() +")" ;
		else
			return "@" ;
	}

	public Enumeration getChildrenInfo()
	{
		if ( nrNeededParams >= 0 )
		{
			return Utils.arrayEnumeration( Utils.arrayConcat( new Object[]{funcOrVal}, getBoundParams() ) ) ;
		}
		else
		{
			return Utils.oneEnumeration( funcOrVal ) ;
		}
	}

	public String getInternalInfo()
	{
		StringBuffer b = new StringBuffer() ;
		b.append( getParentInfo() ) ;
		if ( funcOrVal instanceof Eval )
		{
			Utils.printAsListOn( ( getChildrenInfo() ), b, "(", ",", ")" ) ;
		}
		else
		{
			b.append( "value=" ) ;
			b.append( funcOrVal ) ;
		}
		return b.toString() ;
	}

    /*
    private final static Eval show =
        new Function1( "show" )
        {
            public Object eval1( Object v1 )
            {
                return Str.valueOf( ((Apply)v1).getContentString() ) ;
            }
        } ;
	*/
    
    /**
     * @see  uu.jazy.core.Show#getShow.
     */
    /*
    public Eval getShow()
    {
        return show ;
    }
    */
    
}
