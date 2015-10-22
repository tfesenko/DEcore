package com.tfesenko.decore.gen

import java.util.List
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EClassifier
import org.eclipse.emf.ecore.EDataType
import org.eclipse.emf.ecore.EEnum
import org.eclipse.emf.ecore.EEnumLiteral
import org.eclipse.emf.ecore.ENamedElement
import org.eclipse.emf.ecore.EOperation
import org.eclipse.emf.ecore.util.EcoreUtil

import static com.tfesenko.decore.gen.DocumentationGen.writeDocumentation
import com.tfesenko.decore.IGenerator

class EClassifierGen implements IGenerator<EClassifier> {
	val EStructuralFeatureGen featureGen = new EStructuralFeatureGen()

	override generate(EClassifier element) {
		return '''[[«anchor(element)»,«element.name»]]
=== «element.eClass.name» «element.name» «FOR qualifier : qualifiers(element) BEFORE "(" SEPARATOR ", " AFTER ")"»«qualifier»«ENDFOR» «FOR qualifier : supertypes(element) BEFORE "->" SEPARATOR ", "»«qualifier»«ENDFOR»
«EcoreUtil.getDocumentation(element)»

«contents(element)»

		'''
	}

	def static String anchor(EClassifier element) {
		'''«element.EPackage?.name»-«element.name»'''
	}

	def static String labelOrLinkTo(EClassifier element) {
		if(isEcoreType(element)) element.name else '''<<«anchor(element)»>>'''
	}

	def static isEcoreType(EClassifier element) {
		// FIXME hack
		return element.eContainer == null || (element.eContainer as ENamedElement).name.toLowerCase == "ecore"
	}

	dispatch def qualifiers(EDataType clazz) {
		val List<String> result = newArrayList()
		if (clazz.serializable) {
			result.add("serializable")
		}
		return result
	}

	dispatch def qualifiers(EClass clazz) {
		val List<String> result = newArrayList()
		if (clazz.abstract) {
			result.add("abstract")
		}
		if (clazz.interface) {
			result.add("interface")
		}
		return result
	}

	dispatch def List<String> qualifiers(EClassifier clazz) {
		emptyList
	}

	dispatch def Iterable<String> supertypes(EClass clazz) {
		clazz.ESuperTypes.map[anchor].map["<<"+it+">>"]
	}

	dispatch def Iterable<String> supertypes(EClassifier clazz) {
		emptyList
	}

	dispatch def contents(EClass clazz) {
		'''
«FOR feature : clazz.EStructuralFeatures»
«featureGen.generate(feature)»
«ENDFOR»
«FOR operation : clazz.EOperations»
«operation(operation)»
«ENDFOR»
'''
	}

	dispatch def contents(EEnum enumm) {
		'''
«FOR enumLiteral : enumm.ELiterals»
	«enumLiteral(enumLiteral)»
«ENDFOR»
'''
	}

	dispatch def contents(EClassifier clazz) {
		""
	}

	def enumLiteral(EEnumLiteral enumLiteral) {
		'''«enumLiteral.eClass.name» «enumLiteral.name»(«enumLiteral.literal»)=«enumLiteral.value»«writeDocumentation(enumLiteral)»'''
	}
	
	def operation(EOperation operation) {
			val operationType = if (operation.EType != null) ''' «labelOrLinkTo(operation.EType)»''' else ""
		'''«operation.eClass.name» «operation.name»(): «operationType»«featureGen.cardinality(operation)»«writeDocumentation(operation)»'''
	}

}