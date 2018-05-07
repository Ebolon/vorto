/*******************************************************************************
 * Copyright (c) 2015 Bosch Software Innovations GmbH and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * and Eclipse Distribution License v1.0 which accompany this distribution.
 *   
 * The Eclipse Public License is available at
 * http://www.eclipse.org/legal/epl-v10.html
 * The Eclipse Distribution License is available at
 * http://www.eclipse.org/org/documents/edl-v10.php.
 *   
 * Contributors:
 * Bosch Software Innovations GmbH - Please refer to git log
 *******************************************************************************/
package org.eclipse.vorto.codegen.templates.java

import org.eclipse.vorto.codegen.api.ITemplate
import org.eclipse.vorto.codegen.templates.java.utils.ValueMapper
import org.eclipse.vorto.core.api.model.datatype.Entity
import org.eclipse.vorto.core.api.model.datatype.Enum
import org.eclipse.vorto.core.api.model.functionblock.Operation
import org.eclipse.vorto.core.api.model.functionblock.Param
import org.eclipse.vorto.codegen.api.InvocationContext
import org.eclipse.vorto.core.api.model.datatype.ObjectPropertyType
import org.eclipse.vorto.core.api.model.datatype.PrimitivePropertyType

class JavaClassMethodTemplate implements ITemplate<Operation>{
	
	var ITemplate<Param> parameter
	
	new(ITemplate<Param> parameter) {
		this.parameter = parameter;
	}
	
	override getContent(Operation op,InvocationContext invocationContext) {
		'''
			/**
			* «op.description»
			*/
			
			«IF op.returnType.type instanceof ObjectPropertyType»
				«var objectType = op.returnType.type as ObjectPropertyType»
				public «objectType.type.name» «op.name»(«getParameterString(op,invocationContext)») {
					«IF objectType.type instanceof Entity»
						«objectType.type.name» result = new «objectType.type.name»();
						// Add your code here.
						
						return result;
					«ELSEIF objectType.type instanceof Enum»
						// Add your code here.
						
						return «objectType.type.name».«(objectType.type as Enum).enums.get(0).name.toUpperCase»;
					«ENDIF»
				}
			«ELSEIF op.returnType.type instanceof PrimitivePropertyType»
				«var primitiveType = op.returnType.type as PrimitivePropertyType»
				public «primitiveType.type.getName» «op.name»(«getParameterString(op,invocationContext)») {
					«IF ValueMapper.getInitialValue(primitiveType.type).equalsIgnoreCase("")» 
						«primitiveType.type.getName» result;
					«ELSE»
						«primitiveType.type.getName» result = «ValueMapper.getInitialValue(primitiveType.type)»;
					«ENDIF»
					// Add your code here.
					
					return result;
				}
			«ELSE»
				public void «op.name»(«getParameterString(op,invocationContext)») {
					// Add your code here.
				}
			«ENDIF»
		'''
	}
	
	public def String getParameterString(Operation op,InvocationContext invocationContext) {
		var String result="";
		for (param : op.params) {
			result =  result + ", " + parameter.getContent(param,invocationContext);
		}
		if (result.isNullOrEmpty) {
			return "";
		}
		else {
			return result.substring(2, result.length).replaceAll("\n", "").replaceAll("\r", "");
		}
	}
}