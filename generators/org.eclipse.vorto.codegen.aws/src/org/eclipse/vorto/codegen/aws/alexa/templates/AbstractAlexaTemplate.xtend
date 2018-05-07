/**
 * Copyright (c) 2015-2016 Bosch Software Innovations GmbH and others.
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
 */
package org.eclipse.vorto.codegen.aws.alexa.templates

import org.eclipse.vorto.codegen.api.IFileTemplate
import org.eclipse.vorto.core.api.model.datatype.Enum
import org.eclipse.vorto.core.api.model.datatype.PrimitiveType
import org.eclipse.vorto.core.api.model.functionblock.Param
import org.eclipse.vorto.core.api.model.informationmodel.InformationModel
import org.eclipse.vorto.core.api.model.datatype.PrimitivePropertyType
import org.eclipse.vorto.core.api.model.datatype.ObjectPropertyType

abstract class AbstractAlexaTemplate implements IFileTemplate<InformationModel> {
		
	protected static final String STEREOTYPE_ALEXA = "alexa";
	
	override getPath(InformationModel context) {
		return "aws/alexa";
	}
		
	protected def boolean isAlexaSupportedParamType(Param param) {
		if (param.type instanceof PrimitivePropertyType) {
			var primitiveType = (param.type as PrimitivePropertyType).type;
			if (primitiveType == PrimitiveType.INT || 
				primitiveType == PrimitiveType.DATETIME ||
				primitiveType == PrimitiveType.LONG) {
					return true;
				} else {
					return false;
				}
		} else if (param.type instanceof Enum ) {
			return true;
		} else {
			return false;
		}
	}
	
	protected def String mapToAlexaSupportedType(Param param) {
		if (param.type instanceof PrimitivePropertyType) {
			var primitiveType = (param.type as PrimitivePropertyType).type;
			if (primitiveType == PrimitiveType.INT || primitiveType == PrimitiveType.LONG) {
				return "AMAZON.NUMBER";
			} else if (primitiveType == PrimitiveType.DATETIME) {
				return "AMAZON.DATE";
			}
		} else if(param.type instanceof Enum) {
			var enumType = (param.type as Enum);
			return enumType.name
		}
		
		return null;
	}
}
