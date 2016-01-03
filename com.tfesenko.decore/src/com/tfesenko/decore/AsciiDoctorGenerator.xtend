package com.tfesenko.decore

import com.google.common.base.Charsets
import com.google.common.collect.Iterables
import com.google.common.io.Files
import com.tfesenko.decore.gen.EPackageGen
import com.tfesenko.decore.yuml.ClassDiagramGen
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

class AsciiDoctorGenerator {
	def static void main(String[] args) {
		//val resourceUrl = "http://git.eclipse.org/c/uml2/org.eclipse.uml2.git/plain/plugins/org.eclipse.uml2.uml/model/UML.ecore"
		val ecoreUrl = "http://git.eclipse.org/c/emf/org.eclipse.emf.git/plain/plugins/org.eclipse.emf.ecore/model/Ecore.ecore?id=f3630fa9f543c7ae944704ec53b42cd7d4fa505b"
		val resourceUrl = "file:/Users/TatianaFesenko/Documents/workspace/RepreZen/com.modelsolv.reprezen.restapi/metamodels/RestAPI.ecore"
		var resource = loadResource(resourceUrl)
		for (EPackage epackage : Iterables.filter(resource.getContents(), EPackage)) {
			new AsciiDoctorGenerator().generate(epackage)
		}
		print("Done")

	}

	def void generate(EPackage root) {
		val result = '''= «root.name»
Tatiana Fesenko <tatiana.fesenko@gmail.com>
«currentDate»
:toc:
:icons: font
:quick-uri: http://asciidoctor.org/docs/asciidoc-syntax-quick-reference/

«new EPackageGen().generate(root)»	
	'''
		val outputDir = new File(".")
		val outputFile = new File(outputDir, root.name + ".adoc");
		Files.write(result, outputFile, Charsets::UTF_8);
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

	def currentDate() {
		val DateFormat dateFormat = new SimpleDateFormat("dd MMMM yyyy");
		val Date date = new Date();
		return dateFormat.format(date);
	}

}
