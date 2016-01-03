package com.tfesenko.decore.yuml

import com.tfesenko.decore.IGenerator
import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import java.io.InputStream
import java.io.OutputStream
import java.net.URL
import java.net.URLEncoder
import org.eclipse.emf.ecore.EClass
import org.eclipse.emf.ecore.EReference

class ClassDiagramGen implements IGenerator<EClass> {

	override generate(EClass eclass) {
		val url = '''[«IF eclass.interface»<<Interface>>«ENDIF»«eclass.name»{bg:cornsilk}],
		«createOutgoingLinks(eclass)»'''
		
		// TODO - delete dir?
		new File("images").mkdir()
		val fileName = '''images/«eclass.name».png'''
		saveImage(url, fileName)
		return fileName
	}

	def protected saveImage(String imageUrl, String destinationFile) throws IOException {
		println(imageUrl)
		val URL url = new URL(baseURL+URLEncoder::encode(imageUrl, "UTF-8"));
		println(url)
		val InputStream is = url.openStream();
		val OutputStream os = new FileOutputStream(destinationFile);

		val byte[] b = newByteArrayOfSize(2048);
		var int length;

		while ((length = is.read(b)) != -1) {
			os.write(b, 0, length);
		}

		is.close();
		os.close();
	}

	def protected createOutgoingLinks(EClass eclass) {
		'''««« Extensions
	«FOR supertype : eclass.ESuperTypes»
	«IF supertype.name != null && !supertype.name.isEmpty»
«««Unresolved proxy
[«supertype.name»]^-[«eclass.name»],
	«ENDIF»
	«ENDFOR»,
««« References
	«FOR reference : eclass.EReferences»
[«eclass.name»]«referenceArrow(reference)»[«reference.EType.name»],
	«ENDFOR»'''
	}

	def protected referenceArrow(EReference reference) {
		if(reference.containment) '''++-«reference.name» >''' else '''-«reference.name» >'''
	}

	def protected baseURL() {
		'''http://yuml.me/diagram/scruffy/class/'''
	}

}