package com.tfesenko.decore.examples;

import com.tfesenko.decore.AsciiDoctorGenerator;

public class GenerateUmlDoc {

	public static void main(String[] args) {
		String resourceUrl = "http://git.eclipse.org/c/uml2/org.eclipse.uml2.git/plain/plugins/org.eclipse.uml2.uml/model/UML.ecore";
		new AsciiDoctorGenerator().generate(resourceUrl);
	}

}
