package org.eclipse.vorto.codegen.utils;

import java.util.ArrayList;
import java.util.List;

import org.eclipse.emf.common.util.BasicEList;
import org.eclipse.emf.common.util.EList;
import org.eclipse.vorto.core.api.model.datatype.Property;

import org.eclipse.vorto.core.api.model.functionblock.FunctionblockModel;


public class InheritanceHelper {
	
	public EList<Property> joinStatusProperties(FunctionblockModel functionBlockModel) {
		EList<Property> properties = new BasicEList<Property>();
		List<String> propertyNames = new ArrayList<String>();
		FunctionblockModel lastFunctionblockModel = null;
		do {
			for (Property property : functionBlockModel.getFunctionblock().getStatus().getProperties()) {
				if(!propertyNames.contains(property.getName())) {
					propertyNames.add(property.getName());
					properties.add(property);
				}
			}
			lastFunctionblockModel = functionBlockModel;
			functionBlockModel = functionBlockModel.getSuperType();
		} while(functionBlockModel != null && lastFunctionblockModel != functionBlockModel);
		
		return properties;
		
	}
}
