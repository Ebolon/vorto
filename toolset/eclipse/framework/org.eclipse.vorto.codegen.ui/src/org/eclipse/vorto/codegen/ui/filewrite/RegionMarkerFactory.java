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
package org.eclipse.vorto.codegen.ui.filewrite;

public class RegionMarkerFactory {

	public static IRegionMarker getRegionMarker(String key,
			String existingContent) {
		if (XMLRegionMarker.isValidRegionMarker(key, existingContent)) {
			return new XMLRegionMarker(key);
		} else if (JavaRegionMarker.isValidRegionMarker(key, existingContent)) {
			return new JavaRegionMarker(key);
		} else {
			throw new UnsupportedOperationException(
					"Existing file contains generator comment which is not supported!");
		}
	}
}
