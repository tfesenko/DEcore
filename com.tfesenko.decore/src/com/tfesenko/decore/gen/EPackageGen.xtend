package com.tfesenko.decore.gen

import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.util.EcoreUtil
import com.tfesenko.decore.IGenerator

class EPackageGen implements IGenerator<EPackage> {
	val classGen = new EClassifierGen()

	override generate(EPackage element) {
		return '''== EPackage «element.name»

«EcoreUtil.getDocumentation(element)?.toFirstLower»

«FOR classifier : element.EClassifiers»
«classGen.generate(classifier)»
«ENDFOR»

«FOR pakkage : element.ESubpackages»
«generate(pakkage)»
«ENDFOR»
		'''
	}

}  