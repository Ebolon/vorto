/*******************************************************************************
 * Copyright (c) 2017 Bosch Software Innovations GmbH and others.
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
package org.eclipse.vorto.codegen.ditto.schema.tasks.template;

import org.eclipse.vorto.codegen.api.ITemplate
import org.eclipse.vorto.codegen.api.InvocationContext
import org.eclipse.vorto.core.api.model.datatype.Entity
import org.eclipse.vorto.core.api.model.datatype.Enum
import org.eclipse.vorto.core.api.model.functionblock.FunctionblockModel
import org.eclipse.vorto.core.api.model.functionblock.Operation
import org.eclipse.vorto.core.api.model.datatype.PrimitivePropertyType
import org.eclipse.vorto.core.api.model.datatype.ObjectPropertyType

class OperationResponseValidationTemplate implements ITemplate<Operation> {

	val static EntityValidationTemplate entityValidationTemplate = new EntityValidationTemplate();
	val static EnumValidationTemplate enumValidationTemplate = new EnumValidationTemplate();
	val static PrimitiveTypeValidationTemplate primitiveTypeValidationTemplate = new PrimitiveTypeValidationTemplate();

	new() {
	}

	override getContent(Operation operation, InvocationContext invocationContext) {
		var fbm = operation.eContainer.eContainer as FunctionblockModel;
		var definition = fbm.namespace + ":" + fbm.name + ":" + fbm.version;
		'''
			{
				"$schema": "http://json-schema.org/draft-04/schema#",
				"title": "Operation response payload validation of definition <«definition»> for message subject (operation name) <«operation.name»>",
				"description": "«operation.description»"«IF operation.returnType !== null»,«ENDIF»
				«IF operation.returnType !== null»
					«val returnType = operation.returnType»
					«IF returnType.type instanceof PrimitivePropertyType»
						«val primitiveReturnType = returnType.type as PrimitivePropertyType»
						«IF returnType.isMultiplicity»
							"type": "array",
							"items" : {
								«primitiveTypeValidationTemplate.getContent(primitiveReturnType.type, invocationContext)»
							}
						«ELSE»
							«primitiveTypeValidationTemplate.getContent(primitiveReturnType.type, invocationContext)»
						«ENDIF»
					«ELSEIF returnType.type instanceof ObjectPropertyType»
						«val returnObjectType = returnType as ObjectPropertyType»
						«IF returnObjectType.type instanceof Entity»
							«val entity = returnObjectType.type as Entity»
							«IF returnType.isMultiplicity»
								"type": "array",
								"items": {
									"type": "object",
									"properties": {
										«entityValidationTemplate.getContent(entity, invocationContext)»
									},
									«EntityValidationTemplate.calculateRequired(entity.properties)»
								}
							«ELSE»
								"type": "object",
								"properties": {
									«entityValidationTemplate.getContent(entity, invocationContext)»
								},
								«EntityValidationTemplate.calculateRequired(entity.properties)»
							«ENDIF»
						«ELSEIF returnObjectType.type instanceof Enum»
							«val enum = returnObjectType.type as Enum»
							«IF returnType.isMultiplicity»
								"type": "array",
								"items" : {
									«enumValidationTemplate.getContent(enum, invocationContext)»
								}
							«ELSE»
							«enumValidationTemplate.getContent(enum, invocationContext)»
							«ENDIF»
						«ENDIF»
					«ENDIF»
				«ENDIF»
			}
		'''
	}
}
