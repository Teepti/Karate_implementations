package ConduitApp;

import java.io.File;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;



//import org.testng.annotations.Test;


import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import static org.junit.jupiter.api.Assertions.*;
import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;

import org.junit.jupiter.api.Test;
public class ConduitTest {
		
	@Test
	void testParallel() {
        String karateOutputPath = "target\\files";
		Results results = Runner.path("classpath:ConduitApp")
                .tags("~@ignore")
                .outputCucumberJson(true)
                .parallel(5);
                generateReport(karateOutputPath);
                
        assertEquals(0, results.getFailCount(), results.getErrorMessages());
	}
	public static void generateReport(String karateOutputPath) {
		List<String> allJsonFiles = getJsonFiles();
		List<String> jsonFiles = new ArrayList<String>();
		for(int i=0;i<allJsonFiles.size();i++) {
			jsonFiles.add("target\\karate-reports\\"+allJsonFiles.get(i));
		}	
			String timeStamp = getTimeStamp();
			String environment = "qa";
            String filePath = System.getProperty("user.dir") + "\\KarateTestResults\\" + environment +"\\"+ timeStamp;
            System.out.println(filePath);
			File reportOutputDirectory = new File(filePath);
			String projectName = "Demo";
			Configuration configuration = new Configuration(reportOutputDirectory,projectName);
			ReportBuilder reportBuilder = new ReportBuilder(jsonFiles,configuration);
			reportBuilder.generateReports();
			System.out.println("Report got generated");
		}
	
	public static List<String> getJsonFiles(){
		
        List<String> allJsonFiles = new ArrayList<String>();
        File folder = new File(System.getProperty("user.dir")+"\\target\\karate-reports");
        System.out.println(System.getProperty("user.dir")+"\\target\\files\\karate-reports");
		File[] listOfFiles = folder.listFiles();
		for(int i=0;i<listOfFiles.length;i++) {
			if(listOfFiles[i].isFile()) {
				if(listOfFiles[i].getName().endsWith("json")) {
					boolean jsonFileValidationStatus = validateEmptyJsonFile(System.getProperty("user.dir")+"\\target\\karate-reports\\"+listOfFiles[i].getName());
					System.out.println("File" + listOfFiles[i].getName() + jsonFileValidationStatus);
					if(jsonFileValidationStatus == true) {
						allJsonFiles.add(listOfFiles[i].getName());
					}
				}
			}
		}
		
		return allJsonFiles;
		
	}
	
	public static boolean validateEmptyJsonFile(String filePath) {
		try {
			File file = new File(filePath);
			if(file.length() == 0) {
				try 
				{
					if(file.delete()) {
						System.out.println("Corrupted File Deleted Successfully");
					}
				}catch(Exception e) {
					System.out.println("Corrupted File could not deleted successfully,exception occured "+e);
				}
				return false;
			}else {
				return true;
			}
		}catch(Exception e) {
			System.out.println("Exception occured while validating JSON file is empty or not"+e);
			return false;
		}
		
	}
	
	public static String getTimeStamp() {
		Date todayDate = new Date();
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
		String timeStamp = df.format(todayDate).trim();
		String tempStr = timeStamp.replace(" ", "_");
		String tempStr1 = tempStr.replace(":", "_");
		timeStamp = tempStr1.replace("-","_");
		
		return timeStamp;
		
	}

}
