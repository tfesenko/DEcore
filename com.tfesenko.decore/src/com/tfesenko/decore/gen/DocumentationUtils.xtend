package com.tfesenko.decore.gen

import org.eclipse.emf.ecore.EModelElement
import org.eclipse.emf.ecore.util.EcoreUtil
import com.google.common.base.Strings

class DocumentationGen {
	def static writeDocumentation(EModelElement element) {
		val doc = EcoreUtil::getDocumentation(element)
		if (Strings::isNullOrEmpty(doc))
			" +"// line  break
		else '''::
		«doc»'''
	}
}