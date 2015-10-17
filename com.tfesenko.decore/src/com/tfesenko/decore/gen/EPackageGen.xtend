package com.tfesenko.decore.gen

import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.util.EcoreUtil

class EPackageGen implements IGenerator<EPackage> {
	val classGen = new EClassifierGen()

	override generate(EPackage element) {
		return '''== «element.name»

«EcoreUtil.getDocumentation(element)»

«FOR classifier : element.EClassifiers»
«classGen.generate(classifier)»
«ENDFOR»
		'''
	}

}  