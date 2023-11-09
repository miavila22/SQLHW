-- 2. Add a new column in the customer table for Platinum Member. This can be a boolean.
-- Platinum Members are any customers who have spent over $200. 
-- Create a procedure that updates the Platinum Member column to True for any customer who has spent over $200 and False for any 
-- customer who has spent less than $200.
-- Use the payment and customer table. Customer will be the one to alter, payment table may be the subquery maybe?

ALTER TABLE customer			
ADD COLUMN platnium_member BOOLEAN default false;

ALTER TABLE customer
DROP COLUMN platnium_member;

CREATE PROCEDURE add_platnium_member()
AS $$
	BEGIN
		UPDATE customer
		SET platnium_member = True 
		WHERE customer_id IN ( --this is the column. need to add the "attribute" so it has to be > 200. This might be where the payment table comes in.
			SELECT customer_id
			FROM payment
			GROUP BY payment.customer_id
			HAVING SUM(payment.amount) > 200
);
		COMMIT;
	END;
$$ LANGUAGE plpgsql 
		
CALL add_platnium_member()

SELECT * 
FROM customer
-- LIMIT 2;
WHERE customer_id = 526 OR customer_id = 148;



-- 1. EXTRA CREDIT: Create a procedure that adds a late fee to any customer who returned their rental after 7 days.
-- Use the payment and rental tables. Create a stored function that you call inside your procedure. 
-- The function will calculate the late fee amount based on how many days late they returned their rental. 
-- (Hint* You can subtract  two dates from each other and use Intervals to compare those dates, linked below).