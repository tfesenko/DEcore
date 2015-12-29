package com.tfesenko.decore.plantuml

import com.tfesenko.decore.IGenerator
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EReference
import net.sourceforge.plantuml.SourceStringReader
import java.io.File

class ClassDiagramGen implements IGenerator<EPackage> {

	override generate(EPackage element) {
		'''«header»
«FOR classifier : element.EClassifiers.filter(EClass)»
«createClass(classifier)»
«createOutgoingLinks(classifier)»
«ENDFOR»
«footer»'''
	}
	
	def createClass(EClass eclass) {
'''«IF eclass.abstract»abstract «ELSE»
   		«IF eclass.interface»interface «ELSE»class «ENDIF»
   «ENDIF»
«eclass.name»'''
	}
	
	def createClass2(EClass eclass) {
'''«IF eclass.abstract»abstract «ELSE
   		»«IF eclass.interface»interface «ELSE»class «ENDIF»«
   ENDIF
»«eclass.name»'''
	}
	
	def createOutgoingLinks(EClass eclass) {
		'''««« Extensions
	«FOR supertype : eclass.ESuperTypes»
	«IF supertype.name != null && !supertype.name.isEmpty»
«««Unresolved proxy
«supertype.name» <|-- «eclass.name»
	«ENDIF»
	«ENDFOR»
««« References
	«FOR reference : eclass.EReferences»
«eclass.name» «referenceArrow(reference)» «reference.EType.name»
	«ENDFOR»'''
	}

	def referenceArrow(EReference reference) {
		if(reference.containment) "*--" else "-->"
	}

	def header() {
		'''@startuml'''

	}

	def footer() {
		'''@enduml'''
	}
	
	def toImage(String source, File png) {
		val SourceStringReader reader = new SourceStringReader(source);
		val String desc = reader.generateImage(png);
	}

}