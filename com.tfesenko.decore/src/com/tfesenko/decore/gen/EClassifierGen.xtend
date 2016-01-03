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
import com.tfesenko.decore.yuml.ClassDiagramGen

import static com.tfesenko.decore.gen.DocumentationGen.writeDocumentation
import com.tfesenko.decore.IGenerator
import java.io.File

class EClassifierGen implements IGenerator<EClassifier> {
	val protected featureGen = new EStructuralFeatureGen()
	val protected IGenerator<EClass> imageGenerator = new ClassDiagramGen(new File("images"))

	override generate(EClassifier element) {
		return '''[[«anchor(element)»,«element.name»]]
«heading(element)»
«documentation(element)»
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

	def protected heading(EClassifier element) {
		'''=== «element.eClass.name» [big]*«element.name»* '''+
		'''«FOR qualifier : qualifiers(element) BEFORE "(" SEPARATOR ", " AFTER ")"»«qualifier»«ENDFOR» '''+
		'''«FOR supertype : supertypes(element) BEFORE "->" SEPARATOR ", "»«supertype»«ENDFOR»'''
	}

	def protected documentation(EClassifier element) {
		'''++++
«EcoreUtil.getDocumentation(element)»
++++'''
	}

	dispatch def protected qualifiers(EDataType clazz) {
		val List<String> result = newArrayList()
		if (clazz.serializable) {
			result.add("serializable")
		}
		return result
	}

	dispatch def protected qualifiers(EClass clazz) {
		val List<String> result = newArrayList()
		if (clazz.abstract) {
			result.add("abstract")
		}
		if (clazz.interface) {
			result.add("interface")
		}
		return result
	}

	dispatch def protected List<String> qualifiers(EClassifier clazz) {
		emptyList
	}

	dispatch def protected Iterable<String> supertypes(EClass clazz) {
		clazz.ESuperTypes.map[anchor].map["<<" + it + ">>"]
	}

	dispatch def protected Iterable<String> supertypes(EClassifier clazz) {
		emptyList
	}

	dispatch def contents(EClass clazz) {
		'''
image::«imageGenerator.generate(clazz)»[«clazz.name»]

«FOR feature : clazz.EStructuralFeatures»
«featureGen.generate(feature)»
«ENDFOR»
«FOR operation : clazz.EOperations»
«operation(operation)»
«ENDFOR»
'''
	}

	dispatch def protected contents(EEnum enumm) {
		'''
«FOR enumLiteral : enumm.ELiterals»
	«enumLiteral(enumLiteral)»
«ENDFOR»
'''
	}

	dispatch def protected contents(EClassifier clazz) {
		""
	}

	def protected enumLiteral(EEnumLiteral enumLiteral) {
		'''«enumLiteral.eClass.name» «enumLiteral.name»(«enumLiteral.literal»)=«enumLiteral.value»«writeDocumentation(enumLiteral)»'''
	}

	def protected operation(EOperation operation) {
		val operationType = if (operation.EType != null) ''' «labelOrLinkTo(operation.EType)»''' else ""
		'''«operation.eClass.name» *«operation.name»()*: «operationType»«featureGen.cardinality(operation)»«writeDocumentation(operation)»'''
	}

}