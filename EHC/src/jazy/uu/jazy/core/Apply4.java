package uu.jazy.core ;

/**
 * Lazy and Functional.
 * Package for laziness and functions as known from functional languages.
 * Written by Atze Dijkstra, atze@cs.uu.nl
 */

/**
 * An application of a Eval to 4 parameters.
 */
class Apply4 extends Apply
{
	//private static Stat statNew = Stat.newNewStat( "Apply4" ) ;
	
	protected Object p1, p2, p3, p4 ;
	
	public Apply4( Object f, Object p1, Object p2, Object p3, Object p4 )
	{
		super( f ) ;
		this.p1 = p1 ;
		this.p2 = p2 ;
		this.p3 = p3 ;
		this.p4 = p4 ;
		//statNew.nrEvents++ ;
	}
	
    protected void eraseRefs()
    {
    	//function = null ;
    	p1 = p2 = p3 = p4 = null ;
    }
    
    public Object[] getBoundParams()
    {
	    if ( p1 == null )
	        return Utils.zeroArray ;
	    return new Object[] {p1,p2,p3,p4} ;
    }

    public int getNrBoundParams()
    {
        return 4 ;
    }

}
