package com.tfesenko.decore.examples;

import com.tfesenko.decore.AsciiDoctorGenerator;

public class GenerateEcoreDoc {

	public static void main(String[] args) {
		String ecoreUrl = "http://git.eclipse.org/c/emf/org.eclipse.emf.git/plain/plugins/org.eclipse.emf.ecore/model/Ecore.ecore?id=f3630fa9f543c7ae944704ec53b42cd7d4fa505b";
		String resourceUrl = "file:/Users/TatianaFesenko/Documents/workspace/RepreZen/com.modelsolv.reprezen.restapi/metamodels/RestAPI.ecore";
		new AsciiDoctorGenerator().generate(ecoreUrl);
	}

}
