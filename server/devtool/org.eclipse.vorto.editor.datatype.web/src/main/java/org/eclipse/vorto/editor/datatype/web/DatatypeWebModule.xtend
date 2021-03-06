/*******************************************************************************
 * Copyright (c) 2014 Bosch Software Innovations GmbH and others.
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
 *
 *******************************************************************************/
/*
 * generated by Xtext
 */
package org.eclipse.vorto.editor.datatype.web

import org.eclipse.vorto.editor.web.resource.ContentTypeProvider
import org.eclipse.vorto.editor.web.resource.WebEditorResourceSetProvider
import org.eclipse.vorto.editor.web.resource.WedEditorResourceHandler
import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor
import org.eclipse.xtext.web.server.model.IWebResourceSetProvider
import org.eclipse.xtext.web.server.persistence.IServerResourceHandler

/**
 * Use this class to register additional components to be used within the web application.
 */
@FinalFieldsConstructor
class DatatypeWebModule extends AbstractDatatypeWebModule {
	
	def Class<? extends IWebResourceSetProvider> bindIWebResourceSetProvider() {
		return WebEditorResourceSetProvider
	}

	def Class<? extends IServerResourceHandler> bindIServerResourceHandler() {
		return WedEditorResourceHandler;
	}

	override bindIContentTypeProvider() {
		return ContentTypeProvider
	}
}
