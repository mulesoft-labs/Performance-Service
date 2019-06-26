package mulesoft.performance.corepaas;


import java.time.Instant;
import java.util.Map;
import java.util.Map.Entry;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
  
@RestController
@RequestMapping("/perfService")
public class Controller {
    
	@Autowired
	public JMeterTestAsyncService jmeterTestAsyncService;

    @RequestMapping(value = "/test", method = RequestMethod.POST,consumes = "application/json",produces = "application/json")
    @ResponseBody 
    public BaseResponse pay(@RequestParam(value = "jmxFile") String jmxFile, @RequestBody Map<String, Object> payload) {
    	BaseResponse response = new BaseResponse();
    	String currentUnixTime = String.valueOf(Instant.now().getEpochSecond());
		// Call Async service
    	jmeterTestAsyncService.executeTest(currentUnixTime,jmxFile,payload);
    	
	    response.setTimeStamp(currentUnixTime);
		return response;
    }
    
    @Service
    public class JMeterTestAsyncService {
    	@Async
    	public synchronized void executeTest(String currentUnixTime,String jmxFile,@RequestBody  Map<String, Object> payload) {
    		try {
    			
    			
    			String[] makeDirectoryCommand = new String[] {"bash","-c","mkdir "+"$HOME/Desktop/"+currentUnixTime+"/"};
    			
    			
    			
    			Process makeDirectory = Runtime.getRuntime().exec(makeDirectoryCommand);
    			makeDirectory.waitFor();
    			makeDirectory.destroy();
    			
    			
    			
    			//Logic to copy
    			
    			String[] copyCommand = new String[] {"bash", "-c", "cp -R "+"$HOME/Desktop/"+jmxFile+" "+"$HOME/Desktop/"+currentUnixTime+"/"}; 
    			
    			Process copyFile = Runtime.getRuntime().exec(copyCommand);


    			copyFile.waitFor();
    			
    			copyFile.destroy();
    			
    					
    			//Logic to replace values in jmx file
    			
    			for (Entry<String, Object> entry : payload.entrySet())  {

    				String key = entry.getKey();
    				Object value = entry.getValue();
    				
    				String oldText = "${"+key+"}";
    				
    				String sedHelper = "\'s/"+oldText+"/"+value+ "/g"+ "\'";
    				
    				System.out.println("SED HELPER "+sedHelper);
    				
    				System.out.println(" SED COMMAND "+ "sed -i "+ "\'\'"+ " "+sedHelper+" "+"$HOME/Desktop/"+currentUnixTime+"/"+jmxFile);
    				
    				String[] sedCommand = new String[] {"bash","-c","sed -i "+ "\'\'"+ " "+sedHelper+" "+"$HOME/Desktop/"+currentUnixTime+"/"+jmxFile};

    				Process findAndReplace = Runtime.getRuntime().exec(sedCommand);
    				findAndReplace.waitFor();
    				findAndReplace.destroy();
    			}
    			
    			// Use the replaced file to execute the test
    			
    			
    		} catch (Exception e) {
    			// We've been interrupted
    			return;
    		}

    	}
    }
    
    
}
