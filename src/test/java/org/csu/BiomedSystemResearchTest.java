package org.csu;

import org.csu.dao.research.TaskDao;
import org.csu.domain.research.Task;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.List;

@SpringBootTest
public class BiomedSystemResearchTest {
    @Autowired
    private TaskDao taskDao;
    @Test
    public void test() {
        List<Task> tasks=taskDao.selectList(null);
        System.out.println(tasks);
    }
}
