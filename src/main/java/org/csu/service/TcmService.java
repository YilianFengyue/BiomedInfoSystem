package org.csu.service;

import java.util.Map;

public interface TcmService {

    Map<String, Object> getGraphDataForFormula(String name);
    Map<String, Object> getGraphDataForDisease(String name);
    Map<String, Object> getGraphDataForHerb(String name);
    Map<String, Object> getGraphDataForSymptom(String name);
    Map<String, Object> getGraphDataForSyndrome(String name);
    Map<String, Object> getGraphDataForMeridian(String name);
    Map<String, Object> getGraphDataForAcupoint(String name);
}