public class FeedBackIntentModelController {
    public  string query{get; set;}
    private static string MODEL_ID = 'EKJIJUJOFG67L7FDWK4GSWD7WY';
    private static string TEXT_DIMENSION_NAME = 'Utterance__c';
    private static string ORIGINAL_DIMENSION_NAME = 'Original_Intent__c';
    private static string PREDICTED_DIMENSION_NAME = 'Predicted_Intent__c';
    
    /* To determine the records to perform the bulk action on, extract the SAQL query */
    public PageReference init() {
        query = ApexPages.currentPage().getParameters().get('query');
        return null;
    }
    
    /* Add Feedback to the model's dataset for every misclassified utterance*/
    @RemoteAction
    public static List<Map<String, String>> updateIntentModel(List <Map<String, String>> tableRecords) {
        List<Map<String, String>> result = new List<Map<String, String>>();
        
        for (Map<String, String> r : tableRecords) {
            String utterance = r.get(TEXT_DIMENSION_NAME);
            String actualIntent = r.get(ORIGINAL_DIMENSION_NAME);
            String predictedIntent = r.get(PREDICTED_DIMENSION_NAME);
            
            //Let's interact with an Einstein Language Intent Model
            einsteinplay.Einstein_PredictionService service = new einsteinplay.Einstein_PredictionService(einsteinplay.Einstein_PredictionService.Types.INTENT);
    
            
            //If misclassified
            if (!String.isBlank(utterance) && !String.isBlank(actualIntent) && !String.isBlank(predictedIntent) && !actualIntent.equals(predictedIntent)) {
                
                // Add Feedback
                einsteinplay.Einstein_Example example =  service.createFeedbackLanguageExample(actualIntent, MODEL_ID, utterance);
                
                //Add Entry to be returned to the Visualforce page
                Map<String, String> resultEntry = new Map<String,String>();
                resultEntry.put('utterance',utterance);
                resultEntry.put('actualIntent',actualIntent);
                resultEntry.put('predictedIntent',predictedIntent);
                resultEntry.put ('exampleId',String.valueof(example.id));
                result.add(resultEntry);
            }
        }
        return result;
    }
}