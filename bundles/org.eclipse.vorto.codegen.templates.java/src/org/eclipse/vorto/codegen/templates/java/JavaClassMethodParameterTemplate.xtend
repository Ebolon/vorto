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
import org.eclipse.vorto.core.api.model.datatype.PrimitiveType
import org.eclipse.vorto.core.api.model.functionblock.Param
import org.eclipse.vorto.codegen.api.InvocationContext
import org.eclipse.vorto.core.api.model.datatype.PrimitivePropertyType
import org.eclipse.vorto.core.api.model.datatype.ObjectPropertyType

class JavaClassMethodParameterTemplate implements ITemplate<Param>{
	
	override getContent(Param property,InvocationContext invocationContext) {
		'''
		«IF property.type instanceof PrimitivePropertyType»
			«ValueMapper.mapSimpleDatatype((property.type as PrimitivePropertyType).type as PrimitiveType)» «property.name»
		«ELSEIF property.type instanceof ObjectPropertyType»
			«var ObjectPropertyType object = property.type as ObjectPropertyType»
			«IF object.type instanceof Entity» 
				«(object.type as Entity).name.toFirstUpper» «property.name»
			«ELSEIF object.type instanceof Enum»
				«(object.type as Enum).name.toFirstUpper» «property.name»
			«ENDIF»
		«ENDIF»
		'''
	}
}