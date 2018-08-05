package org.eclipse.vorto.codegen.tests;

import com.google.inject.Injector;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.eclipse.emf.common.util.EList;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.vorto.codegen.utils.InheritanceHelper;
import org.eclipse.vorto.core.api.model.datatype.Constraint;
import org.eclipse.vorto.core.api.model.datatype.ConstraintRule;
import org.eclipse.vorto.core.api.model.datatype.DatatypePackage;
import org.eclipse.vorto.core.api.model.datatype.Property;
import org.eclipse.vorto.core.api.model.functionblock.FunctionBlock;
import org.eclipse.vorto.core.api.model.functionblock.FunctionblockModel;
import org.eclipse.vorto.core.api.model.functionblock.FunctionblockPackage;
import org.eclipse.vorto.editor.datatype.DatatypeStandaloneSetup;
import org.eclipse.vorto.editor.functionblock.FunctionblockStandaloneSetup;
import org.eclipse.emf.ecore.resource.Resource.Diagnostic;
import org.eclipse.xtext.EcoreUtil2;
import org.eclipse.xtext.resource.XtextResource;
import org.eclipse.xtext.resource.XtextResourceSet;
import org.junit.Before;
import org.junit.Test;

public class MixMaxTest extends InheritanceHelperTest {

	final String FBA = "namespace org.eclipse.vorto.test\n" + "version 1.0.0\n" + "displayname \"FunctionBlockA\"\n"
			+ "functionblock FunctionBlockA {\n" + "	status {\n" + "		value as int <{CONSTRAINTS}>\n" + "	}\n"
			+ "}";

	final String FBB = "namespace org.eclipse.vorto.test\n" + "version 1.0.0\n" + "displayname \"FunctionBlockB\"\n"
			+ "using org.eclipse.vorto.test.FunctionBlockA ; 1.0.0\n"
			+ "functionblock FunctionBlockB extends FunctionBlockA {\n" + "	status {\n"
			+ "		value as int <{CONSTRAINTS}>\n" + "	}\n" + "}\n";

	final String PLACEHOLDER = "{CONSTRAINTS}";

	@Test
	public void overrideMinConstraint() {
		List<String> resourceStrings = Arrays.asList(FBB.replace(PLACEHOLDER, "MIN 0"),
				FBA.replace(PLACEHOLDER, "MIN -10"));

		FunctionblockModel functionBlockModel = loadFunctionBlockModel(resourceStrings);
		InheritanceHelper inHelper = new InheritanceHelper();
		System.out.println("abc" + functionBlockModel.getName());
		EList<Property> joinStatusProperties = inHelper.joinStatusProperties(functionBlockModel);
		ConstraintRule constraintRule = joinStatusProperties.get(0).getConstraintRule();
		EList<Constraint> constraints = constraintRule.getConstraints();
		assertEquals("0", constraints.get(0).getConstraintValues());
	}

	@Test
	public void keepMinConstraint() {
		List<String> resourceStrings = Arrays.asList(FBB.replace(PLACEHOLDER, ""),
				FBA.replace(PLACEHOLDER, "MIN -10"));

		FunctionblockModel functionBlockModel = loadFunctionBlockModel(resourceStrings);
		InheritanceHelper inHelper = new InheritanceHelper();
		System.out.println("abc" + functionBlockModel.getName());
		EList<Property> joinStatusProperties = inHelper.joinStatusProperties(functionBlockModel);
		ConstraintRule constraintRule = joinStatusProperties.get(0).getConstraintRule();
		EList<Constraint> constraints = constraintRule.getConstraints();
		assertEquals("-10", constraints.get(0).getConstraintValues());
	}
}
