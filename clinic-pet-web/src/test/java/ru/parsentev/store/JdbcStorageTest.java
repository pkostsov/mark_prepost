package ru.parsentev.store;

import org.junit.Test;
import ru.parsentev.models.User;

import static org.junit.Assert.*;

/**
 * TODO: comment
 * @author parsentev
 * @since 29.04.2015
 */
public class JdbcStorageTest {

	@Test
	public void testCreate() throws Exception {
		final JdbcStorage storage = new JdbcStorage();
		final int id = storage.add(new User(-1, "test", null));
		final User user = storage.get(id);
		assertEquals(id, user.getId());
		storage.close();
	}
}