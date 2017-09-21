public class EventUtils {

	public static Date calculateRecEventApproximateMaxEndDate(DateTime startDate, String RecurrenceType, Integer interval, Integer RecurrenceDayOfWeekMask){
		Integer maxDailyOccurrences = 99;
		Integer maxWeeklyOccurrences = 52;
		Integer maxMonthlyOccurrences = 59;
		
		if(RecurrenceType == 'RecursDaily'){
			return startDate.date().addDays(maxDailyOccurrences * interval - 1);
		}
		if(RecurrenceType == 'RecursEveryWeekday'){			
			return startDate.date().addDays(maxDailyOccurrences / 5 * 7 - 1);		
		}
		if(RecurrenceType == 'RecursWeekly'){
			map<Integer,String> objMap = new map<Integer,String>{1=>'Sunday', 2=>'Monday', 3=>'Tuesday', 4=>'Wednesday', 5=>'Thursday', 6=>'Friday', 7=>'Saturday'};
			map<String,Integer> objMap1 = new map<String,Integer>{'Sunday' => 1, 'Monday' => 2, 'Tuesday' => 3, 'Wednesday' => 4, 'Thursday' => 5, 'Friday' => 6, 'Saturday' => 7};
			map<String,Integer> daysMap = new map<String,Integer>();
			String startDay = startDate.format('EEEE');
			map<Integer,String> objMap2 = getDaysFromMask(RecurrenceDayOfWeekMask);
			map<Integer,String> daysOfRecurrence = new map<Integer,String>();
			Integer j = 1;
			for(Integer i = objMap1.get(startDay); i<=7; i++){
				daysMap.put(objMap.get(i),j);
				if(objMap2.containsKey(i)){
					daysOfRecurrence.put(j, objMap.get(i));
				}
				j++;
			}
			for(Integer i=1; i<objMap1.get(startDay); i++){
				daysMap.put(objMap.get(i),j);	
				if(objMap2.containsKey(i)){
					daysOfRecurrence.put(j, objMap.get(i));
				}
				j++;
			}
			system.debug('daysMap = ' + daysMap);
			system.debug('daysOfRecurrence = ' + daysOfRecurrence);
				Integer nbOfOccurrencesPerWeek = daysOfRecurrence.size();
				String firstOccurrence = '';

				for(Integer i=1; i<=7; i++){
					if(daysOfRecurrence.containsKey(i)){
						firstOccurrence = daysOfRecurrence.get(i);
						break;
					} 
				}
			
			Integer nbOfEventDaysLastWeek = Math.mod(maxWeeklyOccurrences, nbOfOccurrencesPerWeek);
			Integer nbOfDaysToAddLastWeek = 0;
			Integer counter = 1;
			for(Integer i=1; i<=7; i++){
				if(daysOfRecurrence.containsKey(i) && counter <= nbOfEventDaysLastWeek){
					nbOfDaysToAddLastWeek = i;
					counter++;
				}
			}
			return startDate.date().addDays(maxWeeklyOccurrences * interval / nbOfOccurrencesPerWeek * 7 + nbOfDaysToAddLastWeek - 1);
		}
		if(RecurrenceType == 'RecursMonthly' || RecurrenceType == 'RecursMonthlyNth'){
			return startDate.date().addDays(maxMonthlyOccurrences * interval * 30 - 1);
		}
		return null;
	}

	public static map<Integer,String> getDaysFromMask(Integer mask){
		map<Integer,String> recurrenceDaysMap = new map<Integer,String>();
		if(mask >= 64){
			recurrenceDaysMap.put(7,'Saturday');
			mask = mask - 64;
		}
		if(mask >= 32){
			recurrenceDaysMap.put(6,'Friday');
			mask = mask - 32;
		}
		if(mask >= 16){
			recurrenceDaysMap.put(5,'Thursday');
			mask = mask - 16;
		}
		if(mask >= 8){
			recurrenceDaysMap.put(4,'Wednesday');
			mask = mask - 8;
		}
		if(mask >= 4){
			recurrenceDaysMap.put(3,'Tuesday');
			mask = mask - 4;
		}
		if(mask >= 2){
			recurrenceDaysMap.put(2,'Monday');
			mask = mask - 2;
		}
		if(mask >= 1){
			recurrenceDaysMap.put(1,'Sunday');
		}
		return recurrenceDaysMap;
	}
}