package com.tfesenko.decore.gen

import com.tfesenko.decore.gen.IGenerator
import org.eclipse.emf.ecore.EStructuralFeature
import org.eclipse.emf.ecore.util.EcoreUtil
import java.util.List
import org.eclipse.emf.ecore.EAttribute
import org.eclipse.emf.ecore.EReference

class EStructuralFeatureGen implements IGenerator<EStructuralFeature> {

	override generate(EStructuralFeature feature) {
		'''«feature.eClass.name» «feature.name»: «type(feature)» «FOR qualifier : qualifiers(feature) BEFORE "(" SEPARATOR ", " AFTER ")"»«qualifier»«ENDFOR»::
«EcoreUtil::getDocumentation(feature)»'''
	}

	dispatch def type(EReference feature) {
		'''<<«EClassifierGen.anchor(feature.EType)»>>'''
	}

	dispatch def String type(EStructuralFeature feature) {
		feature.EType.name
	}

	dispatch def List<String> qualifiers(EAttribute element) {
		val List<String> result = commonQualifiers(element)
		if (element.ID) {
			result.add("ID")
		}
		return result
	}

	dispatch def List<String> qualifiers(EReference element) {
		val List<String> result = commonQualifiers(element)
		if (element.containment) {
			result.add("containment")
		}
		if (element.container) {
			result.add("container")
		}
		if (!element.resolveProxies) {
			result.add("NOT resolveProxies")
		}
		return result
	}

	def dispatch List<String> qualifiers(EStructuralFeature element) {
		emptyList
	}

	def List<String> commonQualifiers(EStructuralFeature element) {
		val List<String> result = newArrayList()
		if (element.transient) {
			result.add("transient")
		}
		if (element.volatile) {
			result.add("volatile")
		}
		if (element.derived) {
			result.add("derived")
		}
		if (element.unsettable) {
			result.add("unsettable")
		}
		if (!element.changeable) {
			result.add("NOT changeable")
		}
		return result
	}

}