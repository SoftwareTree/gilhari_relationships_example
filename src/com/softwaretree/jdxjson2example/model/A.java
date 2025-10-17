package com.softwaretree.jdxjson2example.model;

import org.json.JSONException;
import org.json.JSONObject;

import com.softwaretree.jdx.JDX_JSONObject;

/**
 * A shell (container) class parallel to a domain model object class for objects of type A 
 * based on the class JSONObject.  This class needs to define just two constructors.
 * Most of the processing is handled by the superclass JDX_JSONObject.
 * <p> 
 * @author Damodar Periwal
 *
 */
public class A extends JDX_JSONObject {

    public A() {
        super();
    }

    public A(JSONObject jsonObject) throws JSONException {
        super(jsonObject);
    }
    
    // The following attributes (aB and aCs) are defined to mimic the underlying JSON object structure and 
    // are used for defining the JDX ORM specification. There is no need to define their setters/getters.

    public B aB;
    
    public C[] aCs;

}
