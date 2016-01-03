package com.tfesenko.decore

import com.google.common.base.Charsets
import com.google.common.collect.Iterables
import com.google.common.io.Files
import com.tfesenko.decore.gen.EPackageGen
import java.io.File
import java.text.DateFormat
import java.text.SimpleDateFormat
import java.util.Date
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EPackage
import org.eclipse.emf.ecore.EcoreFactory
import org.eclipse.emf.ecore.EcorePackage
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.emf.ecore.resource.ResourceSet
import org.eclipse.emf.ecore.resource.impl.ResourceSetImpl
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.emf.ecore.xmi.impl.XMIResourceFactoryImpl

class AsciiDoctorGenerator implements IGenerator<EPackage> {

	def generate(String resourceUrl) {
		var resource = loadResource(resourceUrl)
		generate(resource)
	}

	def generate(Resource resource) {
		for (EPackage epackage : Iterables.filter(resource.getContents(), EPackage)) {
			val contents = new AsciiDoctorGenerator().generate(epackage)
			saveToFile(epackage.name, contents)
		}
	}

	override generate(EPackage root) {

		'''= Metamodel [big]*«root.name»*
Tatiana Fesenko <tatiana.fesenko@gmail.com>
«currentDate»
:toc:
:icons: font
:quick-uri: http://asciidoctor.org/docs/asciidoc-syntax-quick-reference/

«new EPackageGen().generate(root)»	
	'''
	}

	def static loadResource(String resourceUrl) {
		// register the package
		EcorePackage.eINSTANCE.eClass()
		EPackage.Registry.INSTANCE.put(EcoreFactory.eINSTANCE.getEPackage().getNsURI(),
			EcoreFactory.eINSTANCE.getEPackage())
		var Resource.Factory.Registry reg = Resource.Factory.Registry.INSTANCE
		reg.getExtensionToFactoryMap().put("ecore", new XMIResourceFactoryImpl())
		var URI uri = URI.createURI(
			resourceUrl
		)
		var ResourceSet rs = new ResourceSetImpl()
		var Resource resource = rs.getResource(uri, true)
		EcoreUtil.resolveAll(rs);
		resource
	}

	def protected currentDate() {
		val DateFormat dateFormat = new SimpleDateFormat("dd MMMM yyyy");
		val Date date = new Date();
		return dateFormat.format(date);
	}

	def static protected saveToFile(String fileName, String contents) {
		val outputDir = new File(".")
		val outputFile = new File(outputDir, fileName + ".adoc");
		Files.write(contents, outputFile, Charsets::UTF_8);
		println("Generated to " + outputFile.absolutePath)
	}

}
