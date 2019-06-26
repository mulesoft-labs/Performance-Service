package mulesoft.performance.corepaas;

public class JMeterTestRequest {
	
	    private int numThreads;
	    private String applicationURL;
	    private int rampTime;
		public int getNumThreads() {
			return numThreads;
		}
		public void setNumThreads(int numThreads) {
			this.numThreads = numThreads;
		}
	    
}
