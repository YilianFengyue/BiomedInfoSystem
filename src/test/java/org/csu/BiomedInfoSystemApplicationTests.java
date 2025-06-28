package org.csu;

import org.csu.dao.HerbDao;
import org.csu.domain.Herb;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;

@SpringBootTest
class BiomedInfoSystemApplicationTests {
    @Autowired
    private HerbDao herbDao;
    @Test
    void contextLoads() {
    }
    @Test
    public  void  testGetAllHerbs(){
        List<Herb> herbs=herbDao.selectList(null);
        System.out.println(herbs);
    }
}
