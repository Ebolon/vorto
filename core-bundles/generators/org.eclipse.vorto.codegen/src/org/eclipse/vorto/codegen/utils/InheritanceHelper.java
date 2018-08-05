package org.eclipse.vorto.codegen.utils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Collectors;

import org.eclipse.emf.common.util.BasicEList;
import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.util.EcoreUtil;
import org.eclipse.emf.ecore.util.EcoreUtil.Copier;
import org.eclipse.vorto.core.api.model.datatype.Constraint;
import org.eclipse.vorto.core.api.model.datatype.ConstraintIntervalType;
import org.eclipse.vorto.core.api.model.datatype.Property;

import org.eclipse.vorto.core.api.model.functionblock.FunctionblockModel;


public class InheritanceHelper {
	
	public EList<Property> joinStatusProperties(FunctionblockModel functionBlockModel) {
		Map<String, Property> properties = new HashMap<>();

		List<String> propertyNames = new ArrayList<String>();
		FunctionblockModel lastFunctionblockModel = null;
		do {
			for (Property property : functionBlockModel.getFunctionblock().getStatus().getProperties()) {
				if(!propertyNames.contains(property.getName())) {
					propertyNames.add(property.getName());
					properties.put(property.getName(), property);
				} else {
					Property newProp = mergeConstraints(properties.get(property.getName()), property);
					properties.put(property.getName(), newProp);
				}
			}
			lastFunctionblockModel = functionBlockModel;
			functionBlockModel = functionBlockModel.getSuperType();
		} while(functionBlockModel != null && lastFunctionblockModel != functionBlockModel);
		
		return (EList<Property>) properties.values();
		
	}

	private Property mergeConstraints(Property superProperty, Property property) {
		Map<ConstraintIntervalType, Constraint> constraints = property.getConstraintRule().getConstraints().stream().collect(Collectors.toMap(Constraint::getType, Function.identity()));
		Copier copier = new EcoreUtil.Copier();
		Property superPropertyCopy = (Property) copier.copy(superProperty);
		for (Constraint constraint : superPropertyCopy.getConstraintRule().getConstraints()) {
			Constraint baseConstraint = constraints.get(constraint.getType());
			if(constraints.containsKey(constraint.getType())) {
				switch (constraint.getType()) {
				case MIN:
					
					break;

				default:
					break;
				}
			}
		}
		return null;
	}
}
