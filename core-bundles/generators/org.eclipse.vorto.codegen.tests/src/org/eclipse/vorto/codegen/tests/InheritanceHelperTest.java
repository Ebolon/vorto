package org.eclipse.vorto.codegen.tests;

import static org.junit.Assert.assertTrue;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.Resource.Diagnostic;
import org.eclipse.vorto.core.api.model.datatype.DatatypePackage;
import org.eclipse.vorto.core.api.model.functionblock.FunctionblockModel;
import org.eclipse.vorto.core.api.model.functionblock.FunctionblockPackage;
import org.eclipse.vorto.editor.datatype.DatatypeStandaloneSetup;
import org.eclipse.vorto.editor.functionblock.FunctionblockStandaloneSetup;
import org.eclipse.xtext.EcoreUtil2;
import org.eclipse.xtext.resource.XtextResource;
import org.eclipse.xtext.resource.XtextResourceSet;
import org.junit.Before;

import com.google.inject.Injector;

public class InheritanceHelperTest {
	@Before
    public void initEMF() {
		
		FunctionblockPackage.eINSTANCE.eClass();
        DatatypePackage.eINSTANCE.eClass();

        FunctionblockStandaloneSetup.doSetup();
        DatatypeStandaloneSetup.doSetup();
    }
	
	public FunctionblockModel loadFunctionBlockModel(List<String> resourceStrings) {
		Injector injector = new FunctionblockStandaloneSetup().createInjectorAndDoEMFRegistration();
        XtextResourceSet resourceSet = injector.getInstance(XtextResourceSet.class);
        resourceSet.addLoadOption(XtextResource.OPTION_RESOLVE_ALL, Boolean.TRUE);
        resourceSet.addLoadOption(XtextResource.OPTION_ENCODING, "UTF-8");
        
        

        List<Resource> resources = new ArrayList<>();
        int counter = 1;
        for (String resourceString : resourceStrings) {
			resources.add(loadResource(resourceSet, counter + ".fbmodel", resourceString.trim()));
			counter++;
		}
        EcoreUtil2.resolveAll(resourceSet);
        // check for grammar errors
        for (Resource resource : resources) {
            List<Diagnostic> grammarErrors = resource.getErrors();
            
            assertTrue(grammarErrors.isEmpty());
        }
        FunctionblockModel fb = (FunctionblockModel) resources.get(0).getContents().get(0);
        return fb;
	}
	
    private Resource loadResource(XtextResourceSet resourceSet, String path, String resourceString) {
        Resource resource = resourceSet.createResource(URI.createURI("fake:/abc" + path));
        //System.out.println(resourceString);
        InputStream stream = new ByteArrayInputStream(resourceString.getBytes(StandardCharsets.UTF_8));
        try {
			resource.load(stream, resourceSet.getLoadOptions());
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        return resource;
    }
}
